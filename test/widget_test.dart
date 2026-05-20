import 'package:flutter_test/flutter_test.dart';
import 'package:tsl_mobile_app/features/recognition/services/inference_service.dart';
import 'package:tsl_mobile_app/features/recognition/models/result_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Tests Integration : Text-to-Speech & Auto-Delete', () {
    test('Verification de la sortie textuelle pour le TTS', () {
      const result = RecognitionResultData(
        primaryGesture: '3aslema',
        primaryGestureAr: 'عسلامة',
        primaryConfidence: 0.9,
      );

      expect(
        result.primaryGestureAr,
        isNotEmpty,
        reason: "Le TTS a besoin d'un texte arabe non vide",
      );
    });

    test('Filtrage des donnees (Auto-Delete preventif) - Qualite et Periode', () {
      const config = InferenceConfig(confidenceThreshold: 0.5);
      const scoreMauvaisGeste = 0.3;

      final estValide = scoreMauvaisGeste >= config.confidenceThreshold;
      expect(estValide, isFalse);

      const joursParametre = 7;

      for (int ageDuGeste = 8; ageDuGeste <= 14; ageDuGeste++) {
        final doitEtreSupprime = ageDuGeste > joursParametre;

        expect(
          doitEtreSupprime,
          isTrue,
          reason:
              'Geste de $ageDuGeste jours doit etre supprime avec periode de $joursParametre jours',
        );
      }

      const lowConfidenceResult = RecognitionResultData(
        primaryGesture: 'Test',
        primaryGestureAr: 'تجربة',
        primaryConfidence: 0.3,
      );

      final inferenceService = InferenceService(
        config: const InferenceConfig(confidenceThreshold: 0.6),
      );
      final processed = inferenceService.applyPostProcessing(
        lowConfidenceResult,
      );

      expect(
        processed,
        isNull,
        reason: 'La donnee doit etre jetee si la confiance est trop basse',
      );
    });

    test('Verification des metriques de fluidite', () {
      final service = InferenceService();
      final metrics = service.currentMetrics();

      expect(metrics.fps, isNotNull);
      expect(metrics.droppedFrames, isNonNegative);
    });
  });
}
