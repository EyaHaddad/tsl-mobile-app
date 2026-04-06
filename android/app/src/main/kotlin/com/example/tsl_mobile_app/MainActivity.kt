package com.example.tsl_mobile_app

import android.graphics.BitmapFactory
import com.google.mediapipe.tasks.components.containers.NormalizedLandmark
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.Executors

class MainActivity : FlutterActivity() {
	// Channel used by Flutter to call native MediaPipe.
	private val channelName = "tsl_mobile_app/mediapipe"
	private val landmarkCountPerHand = 21
	// 2 hands x 21 landmarks x 3 coordinates (x,y,z).
	private val featureCountPerFrame = 126
	private val worker = Executors.newSingleThreadExecutor()
	private var handLandmarkerHelper: HandLandmarkerHelper? = null

	override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
		super.configureFlutterEngine(flutterEngine)

		MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
			.setMethodCallHandler { call, result ->
				when (call.method) {
					"initializeHandLandmarker" -> {
						worker.execute {
							try {
								if (handLandmarkerHelper == null || handLandmarkerHelper?.isClose() == true) {
									handLandmarkerHelper = HandLandmarkerHelper(context = applicationContext)
								}
								result.success(true)
							} catch (e: Exception) {
								result.error("mediapipe_init_error", e.message, null)
							}
						}
					}

					"detectHands" -> {
						val bytes = call.argument<ByteArray>("bytes")
						if (bytes == null || bytes.isEmpty()) {
							result.success(emptyList<Map<String, Double>>())
							return@setMethodCallHandler
						}

						worker.execute {
							try {
								if (handLandmarkerHelper == null || handLandmarkerHelper?.isClose() == true) {
									handLandmarkerHelper = HandLandmarkerHelper(context = applicationContext)
								}

								val bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.size)
								if (bitmap == null) {
									result.error("invalid_image", "Failed to decode input image bytes.", null)
									return@execute
								}

								// Run one-frame detection.
								val detectionResult = handLandmarkerHelper?.detectImage(bitmap)
								val handResult = detectionResult?.results?.firstOrNull()
								val landmarksByHand = handResult?.landmarks() ?: emptyList()
								val handednessByHand = handResult?.handednesses() ?: emptyList()

								var leftHand: List<NormalizedLandmark>? = null
								var rightHand: List<NormalizedLandmark>? = null

								for (index in landmarksByHand.indices) {
									val handedness = handednessByHand.getOrNull(index)
										?.firstOrNull()
										?.categoryName()
										?.lowercase()
										?: ""

									// Keep strict order expected by LSTM: left first, then right.
									when {
										handedness.contains("left") -> leftHand = landmarksByHand[index]
										handedness.contains("right") -> rightHand = landmarksByHand[index]
										leftHand == null -> leftHand = landmarksByHand[index]
										rightHand == null -> rightHand = landmarksByHand[index]
									}
								}

								val leftNormalized = normalizeHand(leftHand)
								val rightNormalized = normalizeHand(rightHand)

								// Flatten to 126 features in strict xyz order.
								val frameFeatures = mutableListOf<Double>()
								appendXyzFeatures(frameFeatures, leftNormalized)
								appendXyzFeatures(frameFeatures, rightNormalized)

								val payload = mapOf(
									"leftLandmarks" to leftNormalized,
									"rightLandmarks" to rightNormalized,
									"frameFeatures" to frameFeatures
								)

								if (frameFeatures.size == featureCountPerFrame) {
									result.success(payload)
								} else {
									result.success(mapOf<String, Any>(
										"leftLandmarks" to emptyList<Map<String, Double>>(),
										"rightLandmarks" to emptyList<Map<String, Double>>(),
										"frameFeatures" to emptyList<Double>()
									))
								}
							} catch (e: Exception) {
								result.error("mediapipe_detect_error", e.message, null)
							}
						}
					}

					"disposeHandLandmarker" -> {
						worker.execute {
							try {
								handLandmarkerHelper?.clearHandLandmarker()
								handLandmarkerHelper = null
								result.success(true)
							} catch (e: Exception) {
								result.error("mediapipe_dispose_error", e.message, null)
							}
						}
					}

					else -> result.notImplemented()
				}
			}
	}

	override fun onDestroy() {
		handLandmarkerHelper?.clearHandLandmarker()
		handLandmarkerHelper = null
		worker.shutdownNow()
		super.onDestroy()
	}

	// Build exactly 21 landmarks, zero-filled when a hand is missing.
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
		// For each landmark: x then y then z.
		for (landmark in landmarks) {
			features.add(landmark["x"] ?: 0.0)
			features.add(landmark["y"] ?: 0.0)
			features.add(landmark["z"] ?: 0.0)
		}
	}
}
