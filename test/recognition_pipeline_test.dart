import 'package:flutter_test/flutter_test.dart';
import 'package:tsl_mobile_app/features/recognition/managers/sequence_manager.dart';
import 'package:tsl_mobile_app/features/recognition/services/tflite_service.dart';

void main() {
  group('TFLiteService Error Handling', () {
    test('Initialize should fail if model file not found', () async {
      final service = TFLiteService();

      expect(
        () => service.initialize('/nonexistent/path/to/model.tflite'),
        throwsA(isA<Exception>()),
      );
    });

    test(
      'runInference should return NotInitialized error if not initialized',
      () async {
        final service = TFLiteService();
        final sequence = List.generate(10, (_) => List.filled(126, 0.0));

        final result = await service.runInference(sequence);

        expect(result.primaryGesture, equals('NotInitialized'));
        expect(result.primaryConfidence, equals(0.0));
        expect(result.debug, contains('not initialized'));
      },
    );

    test(
      'runInference should return InvalidInput error for empty sequence',
      () async {
        final service = TFLiteService();
        final sequence = <List<double>>[];

        final result = await service.runInference(sequence);

        expect(result.primaryGesture, equals('NoData'));
        expect(result.debug, contains('empty'));
      },
    );

    test(
      'runInference should return NotInitialized for uninitialized service with valid input',
      () async {
        final service = TFLiteService();
        final sequence = List.generate(10, (_) => List.filled(126, 0.0));

        final result = await service.runInference(sequence);

        expect(result.primaryGesture, equals('NotInitialized'));
        expect(result.debug, contains('not initialized'));
      },
    );

    test('Confidence should always be valid (clamped to [0.0, 1.0])', () async {
      final service = TFLiteService();
      final emptySeq = <List<double>>[];
      final validSeq = List.generate(10, (_) => List.filled(126, 0.0));

      final result1 = await service.runInference(emptySeq);
      final result2 = await service.runInference(validSeq);

      expect(result1.primaryConfidence, greaterThanOrEqualTo(0.0));
      expect(result1.primaryConfidence, lessThanOrEqualTo(1.0));
      expect(result2.primaryConfidence, greaterThanOrEqualTo(0.0));
      expect(result2.primaryConfidence, lessThanOrEqualTo(1.0));
    });

    test('Result data structure should be consistent', () async {
      final service = TFLiteService();
      final emptySeq = <List<double>>[];
      final validSeq = List.generate(10, (_) => List.filled(126, 0.0));

      final result1 = await service.runInference(emptySeq);
      final result2 = await service.runInference(validSeq);

      // All results should have consistent structure
      expect(result1.primaryGesture, isNotEmpty);
      expect(result1.primaryGestureAr, isNotEmpty);
      expect(result1.debug, isNotEmpty);

      expect(result2.primaryGesture, isNotEmpty);
      expect(result2.primaryGestureAr, isNotEmpty);
      expect(result2.debug, isNotEmpty);
    });
  });

  group('SequenceManager Shape Validation', () {
    test('SequenceManager should maintain correct window size', () async {
      final scalerMean = List.filled(126, 0.0);
      final scalerScale = List.filled(126, 1.0);
      final manager = SequenceManager(
        scalerMean: scalerMean,
        scalerScale: scalerScale,
      );

      // Add frames
      for (int i = 0; i < 10; i++) {
        final frameFeatures = List.filled(126, 0.5);
        manager.addFrameFeatures(frameFeatures);
      }

      expect(manager.isReady, isTrue);

      final output = manager.buildModelInput2D();
      expect(output, isNotNull);
      expect(output!.length, equals(10));
      expect(output.every((frame) => frame.length == 126), isTrue);
    });

    test('SequenceManager should normalize features correctly', () async {
      final scalerMean = List.filled(126, 0.5);
      final scalerScale = List.filled(126, 2.0);
      final manager = SequenceManager(
        scalerMean: scalerMean,
        scalerScale: scalerScale,
      );

      // Add frames with known values
      for (int i = 0; i < 10; i++) {
        final frameFeatures = List.filled(126, 1.0);
        manager.addFrameFeatures(frameFeatures);
      }

      final output = manager.buildModelInput2D();
      expect(output, isNotNull);

      // Check normalization: (1.0 - 0.5) / 2.0 = 0.25
      for (final frame in output!) {
        for (final value in frame) {
          expect(value, closeTo(0.25, 0.001));
        }
      }
    });

    test('SequenceManager should handle NaN values', () async {
      final scalerMean = List.filled(126, 0.0);
      final scalerScale = List.filled(126, 1.0);
      final manager = SequenceManager(
        scalerMean: scalerMean,
        scalerScale: scalerScale,
      );

      // Add frames with NaN values
      for (int i = 0; i < 10; i++) {
        final frameFeatures = List.filled(126, double.nan);
        manager.addFrameFeatures(frameFeatures);
      }

      final output = manager.buildModelInput2D();
      expect(output, isNotNull);

      // NaN should be converted to 0.0
      for (final frame in output!) {
        for (final value in frame) {
          expect(value.isNaN, isFalse);
          expect(value, equals(0.0));
        }
      }
    });

    test('SequenceManager should handle variable frame lengths', () async {
      final scalerMean = List.filled(126, 0.0);
      final scalerScale = List.filled(126, 1.0);
      final manager = SequenceManager(
        scalerMean: scalerMean,
        scalerScale: scalerScale,
      );

      // Add frame with fewer features than expected
      final shortFrame = List.filled(50, 0.5);
      manager.addFrameFeatures(shortFrame);

      // Should pad with zeros
      expect(manager.isReady, isFalse); // Not ready yet (only 1 frame)

      // Complete the window
      for (int i = 1; i < 10; i++) {
        final frameFeatures = List.filled(126, 0.5);
        manager.addFrameFeatures(frameFeatures);
      }

      final output = manager.buildModelInput2D();
      expect(output, isNotNull);
      expect(output!.length, equals(10));
      expect(output.every((frame) => frame.length == 126), isTrue);
    });

    test('SequenceManager should respect stride', () async {
      final scalerMean = List.filled(126, 0.0);
      final scalerScale = List.filled(126, 1.0);
      final manager = SequenceManager(
        scalerMean: scalerMean,
        scalerScale: scalerScale,
        realtimeStride: 2, // Only emit every 2 frames
      );

      // Add frames and check emission
      var emissionCount = 0;

      for (int i = 0; i < 20; i++) {
        final frameFeatures = List.filled(126, 0.5);
        final shouldInfer = manager.addFrameFeatures(frameFeatures);
        if (shouldInfer) emissionCount++;
      }

      expect(emissionCount, greaterThan(0));
    });

    test(
      'SequenceManager.fromDefaultMetaAsset should fail if asset missing',
      () async {
        expect(
          () => SequenceManager.fromDefaultMetaAsset(),
          throwsA(isA<Exception>()),
        );
      },
    );
  });

  group('Integration: Full Recognition Pipeline', () {
    test('TFLiteService confidence should be valid double', () async {
      final service = TFLiteService();
      final emptySeq = <List<double>>[];
      final validSeq = List.generate(10, (_) => List.filled(126, 0.0));

      final result1 = await service.runInference(emptySeq);
      final result2 = await service.runInference(validSeq);

      expect(result1.primaryConfidence, isA<double>());
      expect(result1.primaryConfidence.isNaN, isFalse);
      expect(result1.primaryConfidence.isInfinite, isFalse);

      expect(result2.primaryConfidence, isA<double>());
      expect(result2.primaryConfidence.isNaN, isFalse);
      expect(result2.primaryConfidence.isInfinite, isFalse);
    });

    test('TFLiteService should handle zero features correctly', () async {
      final service = TFLiteService();
      final sequence = List.generate(10, (_) => List.filled(126, 0.0));

      final result = await service.runInference(sequence);

      expect(result.primaryGesture, isNotEmpty);
      expect(result.processingTime, greaterThanOrEqualTo(0));
      // Should return NotInitialized since service not initialized
      expect(result.primaryGesture, equals('NotInitialized'));
    });

    test('Sequential inferences should produce consistent errors', () async {
      final service = TFLiteService();
      final sequence = List.generate(10, (_) => List.filled(126, 0.5));

      final result1 = await service.runInference(sequence);
      final result2 = await service.runInference(sequence);

      // Both should return same error (NotInitialized)
      expect(result1.primaryGesture, equals(result2.primaryGesture));
      expect(result1.primaryConfidence, equals(result2.primaryConfidence));
    });

    test('Different input types should be handled consistently', () async {
      final service = TFLiteService();

      final emptySeq = <List<double>>[];
      final smallSeq = List.generate(5, (_) => List.filled(126, 0.1));
      final largeSeq = List.generate(10, (_) => List.filled(126, 0.9));

      final result1 = await service.runInference(emptySeq);
      final result2 = await service.runInference(smallSeq);
      final result3 = await service.runInference(largeSeq);

      expect(result1.primaryGesture, equals('NoData'));
      expect(result2.primaryGesture, equals('NotInitialized'));
      expect(result3.primaryGesture, equals('NotInitialized'));
    });
  });
}
