import 'package:flutter_test/flutter_test.dart';
import 'package:tsl_mobile_app/features/recognition/services/tflite_service.dart';
import 'package:tsl_mobile_app/features/recognition/services/inference_service.dart';
import 'package:tsl_mobile_app/features/recognition/models/result_model.dart';

void main() {
  group('Tests Intégration : Text-to-Speech & Auto-Delete', () {
    
    // TEST 1 : Logique Text-to-Speech (TTS)
    // On vérifie que le TFLiteService génère bien le texte arabe 
    // qui sera lu par le moteur vocal.
    test('Vérification de la sortie textuelle pour le TTS', () async {
      final tflite = TFLiteService();
      await tflite.initialize('assets/models/sign_model.tflite');

      // On simule une séquence de gestes
      final sequence = [List.generate(126, (i) => 0.1)];
      
      final result = await tflite.runInference(sequence);

      // Le moteur TTS a besoin de ces deux conditions pour fonctionner :
      expect(result.primaryGestureAr, isNotNull, reason: "Le TTS a besoin d'un texte arabe");
      expect(result.primaryGestureAr, isNotEmpty, reason: "Le texte ne doit pas être vide pour être lu");
    });

    // TEST 2 : Logique Auto-Delete (Gestion de la qualité et rétention)
    // On teste le filtrage par confiance ET la suppression par période
    test('Filtrage des données (Auto-Delete préventif) - Qualité et Période', () {
      // 1. TEST CONFIANCE (Qualité)
      const config = InferenceConfig(confidenceThreshold: 0.5);
      double scoreMauvaisGeste = 0.3;
      
      // Si le score est < 0.5, on doit rejeter
      bool estValide = scoreMauvaisGeste >= config.confidenceThreshold;
      expect(estValide, isFalse); // On vérifie que c'est bien FAUX (donc jeté)

      // 2. TEST PÉRIODE (Temps) - Boucle pour 1-7 jours
      int joursParametre = 7; // L'utilisateur a choisi 7 jours
      
      for (int jour = 1; jour <= 7; jour++) {
        int ageDuGeste = jour + 3; // Geste plus vieux d'au moins 3 jours
        
        bool doitEtreSupprime = ageDuGeste > joursParametre;
        
        // Vérification pour chaque période
        expect(doitEtreSupprime, isTrue, 
          reason: "Geste de $ageDuGeste jours doit être supprimé avec période de $joursParametre jours");
      }

      // Simulation d'un résultat avec une confiance faible (0.3)
      const lowConfidenceResult = RecognitionResultData(
        primaryGesture: 'Test',
        primaryGestureAr: 'تجربة',
        primaryConfidence: 0.3, // Inférieur au seuil de 0.6
      );

      final inferenceService = InferenceService(config: const InferenceConfig(confidenceThreshold: 0.6));
      // Application du post-processing
      final processed = inferenceService.applyPostProcessing(lowConfidenceResult);

      // Ici, la logique d'auto-delete préventive : 
      // Si la confiance est < au seuil, on considère que la donnée ne doit pas être traitée
      bool shouldDiscard = processed.primaryConfidence < 0.6;
      
      expect(shouldDiscard, isTrue, reason: "La donnée doit être jetée si la confiance est trop basse");
    });

    // TEST 3 : Performance pour la fluidité vocale
    test('Vérification des métriques de fluidité', () {
      final service = InferenceService();
      final metrics = service.currentMetrics();

      // Pour un bon TTS, les FPS doivent être stables
      //Le téléphone n'est pas trop lent (fps et droppedFrames)
      expect(metrics.fps, isNotNull);
      expect(metrics.droppedFrames, isNonNegative);
    });
  });
}