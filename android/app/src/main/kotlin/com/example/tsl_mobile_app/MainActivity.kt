package com.example.tsl_mobile_app

import android.graphics.BitmapFactory
import android.util.Log
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
	// Background thread for MediaPipe inference (non-blocking)
	private val worker = Executors.newSingleThreadExecutor { runnable ->
		Thread(runnable, "MediaPipe-Worker").apply { isDaemon = false }
	}
	private var handLandmarkerHelper: HandLandmarkerHelper? = null

	override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
		super.configureFlutterEngine(flutterEngine)

		MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
			.setMethodCallHandler { call, result ->
				when (call.method) {
					"initializeHandLandmarker" -> {
						worker.execute {
							try {
								val threadName = Thread.currentThread().name
								Log.d(TAG, "⚙️ [INIT] Starting MediaPipe init on thread: $threadName")
								
								if (handLandmarkerHelper == null || handLandmarkerHelper?.isClose() == true) {
									// Get confidence parameters from Flutter
									val minHandDetectionConfidence = (call.argument<Number>("minHandDetectionConfidence") as? Number)?.toFloat() ?: 0.5f
									val minHandPresenceConfidence = (call.argument<Number>("minHandPresenceConfidence") as? Number)?.toFloat() ?: 0.5f
									
									handLandmarkerHelper = HandLandmarkerHelper(
										minHandDetectionConfidence = minHandDetectionConfidence,
										minHandPresenceConfidence = minHandPresenceConfidence,
										context = applicationContext
									)
									Log.d(TAG, "✅ [INIT] MediaPipe initialized on $threadName")
								}
								result.success(true)
							} catch (e: Exception) {
								Log.e(TAG, "❌ [INIT] MediaPipe init failed: ${e.message}", e)
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

						// Execute detection on background thread to avoid blocking main thread
						worker.execute {
							try {
								val threadName = Thread.currentThread().name
								val startTime = System.currentTimeMillis()
								Log.d(TAG, "🔍 [DETECT] Starting on thread: $threadName | Bytes: ${bytes.size}")
								
								if (handLandmarkerHelper == null || handLandmarkerHelper?.isClose() == true) {
									Log.w(TAG, "⚠️ [DETECT] Helper not initialized, re-initializing...")
									handLandmarkerHelper = HandLandmarkerHelper(context = applicationContext)
								}

								// Check if this is a raw image (Plan Y) or compressed image
								val isRaw = call.argument<Boolean>("isRaw") ?: false
								val width = call.argument<Number>("width")?.toInt() ?: 320
								val height = call.argument<Number>("height")?.toInt() ?: 240
								val format = call.argument<String>("format") ?: "unknown"
								val rotation = call.argument<Number>("rotation")?.toInt() ?: 0

								// 1. OBTENTION DU RÉSULTAT (Type explicite)
								val detectionResult: HandLandmarkerHelper.ResultBundle? = if (isRaw && format == "grayscale") {
									Log.d(TAG, "🎯 [NATIVE] Mode RAW: Converting ${bytes.size} bytes (${width}x${height}, rotation: ${rotation}°)")
									handLandmarkerHelper?.detectImageFromRawBytes(
										bytes = bytes,
										width = width,
										height = height,
										rotation = rotation,
										isRaw = true,
										format = "grayscale"
									)
								} else {
									Log.d(TAG, "🎯 [NATIVE] Mode COMPRESSED: Decoding image bytes...")
									val bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.size)
									if (bitmap == null) {
										result.error("invalid_image", "Failed to decode input image bytes.", null)
										return@execute
									}
									handLandmarkerHelper?.detectImage(bitmap)
								}

								// 2. EXTRACTION DES DONNÉES (La partie qui manquait!)
								val landmarksByHand = detectionResult?.results?.firstOrNull()?.landmarks() ?: emptyList()
								val handednessByHand = detectionResult?.results?.firstOrNull()?.handedness() ?: emptyList()

								var leftHand: List<NormalizedLandmark>? = null
								var rightHand: List<NormalizedLandmark>? = null

								// 3. TRI DES MAINS (Gauche vs Droite)
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

								// 4. NORMALISATION ET PAYLOAD
								val leftNormalized = normalizeHand(leftHand)
								val rightNormalized = normalizeHand(rightHand)

								val frameFeatures = mutableListOf<Double>()
								appendXyzFeatures(frameFeatures, leftNormalized)
								appendXyzFeatures(frameFeatures, rightNormalized)

								val payload = mapOf(
									"leftLandmarks" to leftNormalized,
									"rightLandmarks" to rightNormalized,
									"frameFeatures" to frameFeatures
								)

								val elapsed = System.currentTimeMillis() - startTime
								if (frameFeatures.size == featureCountPerFrame) {
									Log.d(TAG, "✅ [DETECT] Complete in ${elapsed}ms | Features: ${frameFeatures.size} | Thread: $threadName")
									result.success(payload)
								} else {
									Log.w(TAG, "⚠️ [DETECT] Invalid feature count: ${frameFeatures.size}/${featureCountPerFrame}")
									result.success(mapOf<String, Any>(
										"leftLandmarks" to emptyList<Map<String, Double>>(),
										"rightLandmarks" to emptyList<Map<String, Double>>(),
										"frameFeatures" to emptyList<Double>()
									))
								}
							} catch (e: Exception) {
								Log.e(TAG, "❌ [DETECT] Error: ${e.message}", e)
								result.error("mediapipe_detect_error", e.message, null)
							}
						}
					}

					"disposeHandLandmarker" -> {
						worker.execute {
							try {
								val threadName = Thread.currentThread().name
								Log.d(TAG, "🧹 [DISPOSE] Cleaning up MediaPipe on thread: $threadName")
								handLandmarkerHelper?.clearHandLandmarker()
								handLandmarkerHelper = null
								Log.d(TAG, "✅ [DISPOSE] MediaPipe disposed successfully")
								result.success(true)
							} catch (e: Exception) {
								Log.e(TAG, "❌ [DISPOSE] Error: ${e.message}", e)
								result.error("mediapipe_dispose_error", e.message, null)
							}
						}
					}

					else -> result.notImplemented()
				}
			}
	}

	override fun onDestroy() {
		Log.d(TAG, "🔌 [LIFECYCLE] MainActivity.onDestroy() - Cleaning up resources")
		handLandmarkerHelper?.clearHandLandmarker()
		handLandmarkerHelper = null
		worker.shutdownNow()
		Log.d(TAG, "✅ [LIFECYCLE] MediaPipe worker thread shut down")
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

	companion object {
		private const val TAG = "MainActivity"
	}
}
