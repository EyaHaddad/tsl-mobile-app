import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:camera/camera.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tsl_mobile_app/features/recognition/screens/result_screen.dart';
import 'package:tsl_mobile_app/features/recognition/models/result_model.dart';
import 'package:tsl_mobile_app/features/recognition/services/recognition_controller.dart';
import 'package:tsl_mobile_app/features/recognition/services/tflite_service.dart';
import 'package:tsl_mobile_app/features/recognition/services/mediapipe_service.dart';
import 'package:tsl_mobile_app/features/recognition/services/inference_service.dart';
import 'package:tsl_mobile_app/features/recognition/models/managers/sequence_manager.dart';
import 'package:tsl_mobile_app/core/routes/transition_routes.dart';
import 'package:tsl_mobile_app/features/camera/screens/camera_screen_web.dart';
import 'package:tsl_mobile_app/features/camera/camera_service.dart';

// Camera Screen - Mobile implementation
class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late final CameraService _cameraService;
  late RecognitionController _recognitionController;
  late StreamSubscription<RecognitionResultData> _resultSubscription;
  Future<void>? _initializeControllerFuture;

  bool _isRecording = false;
  bool _isSwitchingCamera = false;
  String? _cameraError;
  RecognitionResultData? _lastRecognitionResult;

  @override
  void initState() {
    super.initState();
    _cameraService = CameraService(
      preferredLensDirection: CameraLensDirection.back,
    );

    // Initialize camera
    if (!kIsWeb) {
      _initializeControllerFuture = _initCamera();
    }

    // RecognitionController will be initialized later in _startRecording
    // when we have metadata loaded
  }

  Future<void> _initCamera() async {
    try {
      // Use low resolution for better performance on mid-range devices
      await _cameraService.initialize(resolution: ResolutionPreset.low);
      if (!mounted) return;
      setState(() {
        _cameraError = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _cameraError = 'تعذر تشغيل الكاميرا. تحقق من الأذونات ثم أعد المحاولة.';
      });
      _showErrorSnackBar(e.toString());
    }
  }

  @override
  void dispose() {
    try {
      _resultSubscription.cancel();
    } catch (_) {
      // Subscription might not be initialized yet
    }
    try {
      _recognitionController.dispose();
    } catch (_) {
      // RecognitionController might not be initialized yet
    }
    _cameraService.dispose();
    super.dispose();
  }

  Future<void> _toggleCamera() async {
    if (_isRecording || _isSwitchingCamera) return;

    setState(() => _isSwitchingCamera = true);

    try {
      await _cameraService.switchCamera();
      if (!mounted) return;
      setState(() {
        _cameraError = null;
      });
    } catch (e) {
      _showErrorSnackBar('تعذر تبديل الكاميرا');
      if (!mounted) return;
      setState(() {
        _cameraError = e.toString();
      });
    } finally {
      if (!mounted) return;
      setState(() => _isSwitchingCamera = false);
    }
  }

  Future<void> _startRecording() async {
    if (!_cameraService.isInitialized) {
      _showErrorSnackBar('الكاميرا غير جاهزة بعد');
      return;
    }

    try {
      print('🚀 [INIT] Démarrage de l\'initialisation du pipeline...');
      
      // Load metadata and create SequenceManager with correct scaler values
      final sequenceManager = await SequenceManager.fromDefaultMetaAsset()
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () => throw TimeoutException('Timeout loading metadata'),
          );

      // Initialize recognition controller with proper metadata
      _recognitionController = RecognitionController(
        cameraService: _cameraService,
        mediaPipeService: MediaPipeService(),
        tfliteService: TFLiteService(),
        sequenceManager: sequenceManager,
        inferenceService: InferenceService(),
      );

      // Listen to recognition results from TFLite
      _resultSubscription = _recognitionController.resultStream.listen((result) {
        // DEBUG: Verify AI is processing frames
        print('🔥 IA en action : ${result.primaryGestureAr} (Confiance: ${(result.primaryConfidence * 100).toStringAsFixed(1)}%)');
        if (mounted) {
          setState(() {
            _lastRecognitionResult = result;
          });
        }
      });

      // Initialize the controller with model path + TIMEOUT
      print('🧠 [INIT] Chargement du modèle TFLite...');
      await _recognitionController
          .initialize(
            modelPath: TFLiteService.defaultModelPath,
            metadataAssetPath: TFLiteService.defaultMetadataAssetPath,
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw TimeoutException('Timeout initializing TFLite model'),
          );
      print('✅ [INIT] Modèle TFLite chargé avec succès!');

      // Start live recognition (ImageStream pour l'IA)
      print('📹 [INIT] Démarrage du flux caméra...');
      await _recognitionController.start();
      print('✅ [INIT] Pipeline prêt! Flux caméra activé.');

      // DÉSACTIVÉ: startVideoRecording() verrouille le flux caméra sur Android!
      // On utilise UNIQUEMENT ImageStream pour l'IA
      // await _cameraService.startVideoRecording();
      
      if (!mounted) return;
      setState(() => _isRecording = true);
      
      print('✅ Enregistrement commencé - IA activée (ImageStream uniquement, 5 FPS)');
    } on TimeoutException catch (e) {
      print('❌ [TIMEOUT] $e');
      _showErrorSnackBar('استغرق التحميل وقتاً طويلاً جداً: $e');
    } catch (e) {
      print('❌ [ERROR] Erreur pendant l\'initialisation: $e');
      _showErrorSnackBar('تعذر بدء التسجيل: $e');
    }
  }

  Future<void> _endRecording() async {
    if (!_isRecording) {
      _showErrorSnackBar('لا يوجد تسجيل جارٍ');
      return;
    }

    // Stop recognition
    await _recognitionController.stop();

    // DEBUG: Check if we have a recognition result
    print('📊 Au moment du clic "Finir":');
    print('   - _lastRecognitionResult: $_lastRecognitionResult');
    if (_lastRecognitionResult != null) {
      print('   - Signe reconnu: ${_lastRecognitionResult!.primaryGestureAr}');
      print('   - Confiance: ${(_lastRecognitionResult!.primaryConfidence * 100).toStringAsFixed(1)}%');
    } else {
      print('   ⚠️ Aucun résultat! MediaPipe n\'a peut-être pas détecté les mains.');
    }

    // DÉSACTIVÉ: stopVideoRecording() verrouille le flux
    // String? recordedVideoPath;
    // try {
    //   recordedVideoPath = await _cameraService.stopVideoRecording();
    // } catch (_) {
    //   _showErrorSnackBar('تعذر إنهاء التسجيل');
    // }

    if (!mounted) return;
    setState(() => _isRecording = false);

    // Note: recordedVideoPath n'est plus utilisé (VideoRecording désactivé)
    // On navigue directement avec le résultat de reconnaissance

    // Navigate to result screen with the latest recognition result
    if (!mounted) return;
    Navigator.of(context).push(
      FadeSlidePageRoute(
        page: ResultScreen(
          recognitionResult: _lastRecognitionResult,
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildPreview() {
    final controller = _cameraService.controller;
    if (controller == null || !controller.value.isInitialized) {
      if (_cameraError != null) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Text(
              _cameraError!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54),
            ),
          ),
        );
      }

      return const Center(child: CircularProgressIndicator());
    }

    final previewSize = controller.value.previewSize;
    if (previewSize == null) {
      return CameraPreview(controller);
    }

    // Cover the available space while maintaining aspect ratio
    // Using swapped width/height matches typical camera preview orientation
    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: previewSize.height,
        height: previewSize.width,
        child: CameraPreview(controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const CameraScreenWeb();
    }

    final isCameraReady = _cameraService.isInitialized;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // تسجيل button with red dot
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_isRecording) {
                        _endRecording();
                      } else {
                        _startRecording();
                      }
                    },
                    icon: const Icon(
                      Icons.circle,
                      color: Colors.white,
                      size: 10,
                    ),
                    label: const Text(
                      'تسجيل',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE63950),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                  ),
                  // Camera flip icon
                  IconButton(
                    onPressed: _isSwitchingCamera ? null : _toggleCamera,
                    icon: SvgPicture.asset(
                      'assets/icons/camera_flip.svg',
                      width: 32,
                      height: 32,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFFE63950),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Camera preview area
              if (isCameraReady)
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFFE63950),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: FutureBuilder<void>(
                            future: _initializeControllerFuture,
                            builder: (context, snapshot) {
                              return _buildPreview();
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'الكاميرا قيد التشغيل',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                )
              else
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 160,
                            height: 130,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFFE63950),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: FutureBuilder<void>(
                              future: _initializeControllerFuture,
                              builder: (context, snapshot) {
                                return _buildPreview();
                              },
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'الكاميرا قيد التشغيل',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Detected sign box - DYNAMIC
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFF2DC9A0),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Label row with dynamic confidence
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          ': إشارة مكتشفة',
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        SizedBox(width: 6),
                        // ✅ DYNAMIC: Show confidence percentage
                        Text(
                          _lastRecognitionResult != null
                              ? '[${(_lastRecognitionResult!.primaryConfidence * 100).toStringAsFixed(0)}%]'
                              : '[انتظر...]',
                          style: TextStyle(
                            fontSize: 16,
                            color: _lastRecognitionResult != null 
                                ? (_lastRecognitionResult!.primaryConfidence > 0.7 
                                    ? Colors.green 
                                    : Colors.orange)
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // ✅ DYNAMIC: Detected gesture name in Arabic
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        _lastRecognitionResult?.primaryGestureAr ?? 'في انتظار الإشارة...',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 18,
                          color: _lastRecognitionResult != null 
                              ? Colors.black87 
                              : Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // End recording button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isRecording ? _endRecording : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE63950),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'إنهاء التسجيل',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
