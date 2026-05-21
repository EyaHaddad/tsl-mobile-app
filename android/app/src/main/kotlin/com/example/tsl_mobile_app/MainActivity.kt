package com.example.tsl_mobile_app

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.ImageFormat
import android.graphics.Matrix
import android.graphics.Rect
import android.graphics.YuvImage
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.camera.core.CameraSelector
import androidx.camera.core.ImageAnalysis
import androidx.camera.core.ImageProxy
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.core.content.ContextCompat
import com.google.mediapipe.tasks.components.containers.NormalizedLandmark
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

class MainActivity : FlutterActivity() {
	private val channelName = "tsl_mobile_app/mediapipe"
	private val eventChannelName = "tsl_mobile_app/mediapipe_events"
	private val landmarkCountPerHand = 21
	private val featureCountPerFrame = 126

	private val worker = Executors.newSingleThreadExecutor { runnable ->
		Thread(runnable, "MediaPipe-Worker").apply { isDaemon = false }
	}
	private val analysisExecutor: ExecutorService = Executors.newSingleThreadExecutor { runnable ->
		Thread(runnable, "CameraX-Analysis").apply { isDaemon = false }
	}
	private val mainHandler = Handler(Looper.getMainLooper())

	private var handLandmarkerHelper: HandLandmarkerHelper? = null
	private var cameraProvider: ProcessCameraProvider? = null
	private var featureEventSink: EventChannel.EventSink? = null

	override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
		super.configureFlutterEngine(flutterEngine)

		EventChannel(flutterEngine.dartExecutor.binaryMessenger, eventChannelName)
			.setStreamHandler(object : EventChannel.StreamHandler {
				override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
					featureEventSink = events
				}

				override fun onCancel(arguments: Any?) {
					featureEventSink = null
				}
			})

		MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
			.setMethodCallHandler { call, result ->
				when (call.method) {
					"initializeHandLandmarker" -> {
						worker.execute {
							try {
								if (handLandmarkerHelper == null || handLandmarkerHelper?.isClose() == true) {
									val minHandDetectionConfidence =
										(call.argument<Number>("minHandDetectionConfidence") as? Number)?.toFloat()
											?: 0.5f
									val minHandPresenceConfidence =
										(call.argument<Number>("minHandPresenceConfidence") as? Number)?.toFloat()
											?: 0.5f

									handLandmarkerHelper = HandLandmarkerHelper(
										minHandDetectionConfidence = minHandDetectionConfidence,
										minHandPresenceConfidence = minHandPresenceConfidence,
										context = applicationContext
									)
								}
								result.success(true)
							} catch (e: Exception) {
								Log.e(TAG, "[INIT] MediaPipe init failed: ${e.message}", e)
								result.error("mediapipe_init_error", e.message, null)
							}
						}
					}

					"detectHands" -> {
						val bytes = call.argument<ByteArray>("bytes")
						if (bytes == null || bytes.isEmpty()) {
							result.success(emptyFeaturePayload())
							return@setMethodCallHandler
						}

						worker.execute {
							try {
								if (handLandmarkerHelper == null || handLandmarkerHelper?.isClose() == true) {
									handLandmarkerHelper = HandLandmarkerHelper(context = applicationContext)
								}

								val isRaw = call.argument<Boolean>("isRaw") ?: false
								val width = call.argument<Number>("width")?.toInt() ?: 320
								val height = call.argument<Number>("height")?.toInt() ?: 240
								val format = call.argument<String>("format") ?: "unknown"
								val rotation = call.argument<Number>("rotation")?.toInt() ?: 0

								val detectionResult = if (isRaw && format == "grayscale") {
									handLandmarkerHelper?.detectImageFromRawBytes(
										bytes = bytes,
										width = width,
										height = height,
										rotation = rotation,
										isRaw = true,
										format = "grayscale"
									)
								} else {
									val bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.size)
									if (bitmap == null) {
										result.error("invalid_image", "Failed to decode input image bytes.", null)
										return@execute
									}
									handLandmarkerHelper?.detectImage(bitmap)
								}

								result.success(buildFeaturePayload(detectionResult))
							} catch (e: Exception) {
								Log.e(TAG, "[DETECT] Error: ${e.message}", e)
								result.error("mediapipe_detect_error", e.message, null)
							}
						}
					}

					"startNativeCameraAnalysis" -> {
						startNativeCameraAnalysis(result)
					}

					"stopNativeCameraAnalysis" -> {
						stopNativeCameraAnalysis()
						result.success(true)
					}

					"disposeHandLandmarker" -> {
						worker.execute {
							try {
								stopNativeCameraAnalysis()
								handLandmarkerHelper?.clearHandLandmarker()
								handLandmarkerHelper = null
								result.success(true)
							} catch (e: Exception) {
								Log.e(TAG, "[DISPOSE] Error: ${e.message}", e)
								result.error("mediapipe_dispose_error", e.message, null)
							}
						}
					}

					else -> result.notImplemented()
				}
			}
	}

	override fun onDestroy() {
		stopNativeCameraAnalysis()
		handLandmarkerHelper?.clearHandLandmarker()
		handLandmarkerHelper = null
		worker.shutdownNow()
		analysisExecutor.shutdownNow()
		super.onDestroy()
	}

	private fun startNativeCameraAnalysis(result: MethodChannel.Result) {
		val providerFuture = ProcessCameraProvider.getInstance(this)
		providerFuture.addListener({
			try {
				val provider = providerFuture.get()
				cameraProvider = provider

				if (handLandmarkerHelper == null || handLandmarkerHelper?.isClose() == true) {
					handLandmarkerHelper = HandLandmarkerHelper(context = applicationContext)
				}

				val analysis = ImageAnalysis.Builder()
					.setBackpressureStrategy(ImageAnalysis.STRATEGY_KEEP_ONLY_LATEST)
					.build()

				analysis.setAnalyzer(analysisExecutor) { imageProxy ->
					analyzeCameraXFrame(imageProxy)
				}

				provider.unbindAll()
				provider.bindToLifecycle(this, CameraSelector.DEFAULT_BACK_CAMERA, analysis)

				Log.d(TAG, "[CAMERAX] Native image analysis started")
				result.success(true)
			} catch (e: Exception) {
				Log.e(TAG, "[CAMERAX] Failed to start analysis: ${e.message}", e)
				result.error("camerax_start_error", e.message, null)
			}
		}, ContextCompat.getMainExecutor(this))
	}

	private fun stopNativeCameraAnalysis() {
		try {
			cameraProvider?.unbindAll()
			cameraProvider = null
			Log.d(TAG, "[CAMERAX] Native image analysis stopped")
		} catch (e: Exception) {
			Log.e(TAG, "[CAMERAX] Failed to stop analysis: ${e.message}", e)
		}
	}

	private fun analyzeCameraXFrame(imageProxy: ImageProxy) {
		try {
			val bitmap = imageProxyToBitmap(imageProxy)
			val detectionResult = if (bitmap == null) {
				null
			} else {
				handLandmarkerHelper?.detectImage(bitmap)
			}
			val payload = buildFeaturePayload(detectionResult)
			emitFrameFeatures(payload["frameFeatures"] as List<Double>)
		} catch (e: Exception) {
			Log.e(TAG, "[CAMERAX] Analyze frame failed: ${e.message}", e)
			emitFrameFeatures(emptyFeatureFrame())
		} finally {
			imageProxy.close()
		}
	}

	private fun emitFrameFeatures(features: List<Double>) {
		mainHandler.post {
			featureEventSink?.success(features)
		}
	}

	private fun imageProxyToBitmap(imageProxy: ImageProxy): Bitmap? {
		val nv21 = yuv420ToNv21(imageProxy)
		val yuvImage = YuvImage(nv21, ImageFormat.NV21, imageProxy.width, imageProxy.height, null)
		val outputStream = ByteArrayOutputStream()
		yuvImage.compressToJpeg(Rect(0, 0, imageProxy.width, imageProxy.height), 90, outputStream)
		val jpegBytes = outputStream.toByteArray()
		val decoded = BitmapFactory.decodeByteArray(jpegBytes, 0, jpegBytes.size) ?: return null
		val rotation = imageProxy.imageInfo.rotationDegrees
		if (rotation == 0) return decoded

		val matrix = Matrix().apply { postRotate(rotation.toFloat()) }
		return Bitmap.createBitmap(decoded, 0, 0, decoded.width, decoded.height, matrix, true)
	}

	private fun yuv420ToNv21(imageProxy: ImageProxy): ByteArray {
		val width = imageProxy.width
		val height = imageProxy.height
		val yPlane = imageProxy.planes[0]
		val uPlane = imageProxy.planes[1]
		val vPlane = imageProxy.planes[2]
		val nv21 = ByteArray(width * height * 3 / 2)

		var outputOffset = 0
		val yBuffer = yPlane.buffer
		for (row in 0 until height) {
			yBuffer.position(row * yPlane.rowStride)
			yBuffer.get(nv21, outputOffset, width)
			outputOffset += width
		}

		val chromaHeight = height / 2
		val chromaWidth = width / 2
		val uBuffer = uPlane.buffer
		val vBuffer = vPlane.buffer
		for (row in 0 until chromaHeight) {
			for (col in 0 until chromaWidth) {
				val vuOffset = outputOffset + row * width + col * 2
				val vIndex = row * vPlane.rowStride + col * vPlane.pixelStride
				val uIndex = row * uPlane.rowStride + col * uPlane.pixelStride
				nv21[vuOffset] = vBuffer.get(vIndex)
				nv21[vuOffset + 1] = uBuffer.get(uIndex)
			}
		}

		return nv21
	}

	private fun buildFeaturePayload(detectionResult: HandLandmarkerHelper.ResultBundle?): Map<String, Any> {
		val landmarksByHand = detectionResult?.results?.firstOrNull()?.landmarks() ?: emptyList()
		val handednessByHand = detectionResult?.results?.firstOrNull()?.handedness() ?: emptyList()

		var leftHand: List<NormalizedLandmark>? = null
		var rightHand: List<NormalizedLandmark>? = null

		for (index in landmarksByHand.indices) {
			val handedness = handednessByHand.getOrNull(index)
				?.firstOrNull()
				?.categoryName()
				?.lowercase()
				?: ""

			when {
				handedness.contains("left") -> leftHand = landmarksByHand[index]
				handedness.contains("right") -> rightHand = landmarksByHand[index]
				leftHand == null -> leftHand = landmarksByHand[index]
				else -> rightHand = landmarksByHand[index]
			}
		}

		val leftNormalized = normalizeHand(leftHand)
		val rightNormalized = normalizeHand(rightHand)
		val frameFeatures = mutableListOf<Double>()
		appendXyzFeatures(frameFeatures, leftNormalized)
		appendXyzFeatures(frameFeatures, rightNormalized)

		return mapOf(
			"leftLandmarks" to leftNormalized,
			"rightLandmarks" to rightNormalized,
			"frameFeatures" to frameFeatures
		)
	}

	private fun emptyFeaturePayload(): Map<String, Any> {
		return mapOf(
			"leftLandmarks" to emptyList<Map<String, Double>>(),
			"rightLandmarks" to emptyList<Map<String, Double>>(),
			"frameFeatures" to emptyFeatureFrame()
		)
	}

	private fun emptyFeatureFrame(): List<Double> {
		return List(featureCountPerFrame) { 0.0 }
	}

	private fun normalizeHand(hand: List<NormalizedLandmark>?): List<Map<String, Double>> {
		val normalized = mutableListOf<Map<String, Double>>()
		for (index in 0 until landmarkCountPerHand) {
			val landmark = hand?.getOrNull(index)
			normalized.add(
				mapOf(
					"x" to (landmark?.x()?.toDouble() ?: 0.0),
					"y" to (landmark?.y()?.toDouble() ?: 0.0),
					"z" to (landmark?.z()?.toDouble() ?: 0.0),
					"visibility" to 1.0
				)
			)
		}
		return normalized
	}

	private fun appendXyzFeatures(
		features: MutableList<Double>,
		landmarks: List<Map<String, Double>>
	) {
		for (landmark in landmarks) {
			features.add(landmark["x"] ?: 0.0)
			features.add(landmark["y"] ?: 0.0)
			features.add(landmark["z"] ?: 0.0)
		}
	}

	companion object {
		private const val TAG = "MainActivity"
	}
}
