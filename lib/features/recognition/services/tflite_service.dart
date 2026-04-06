import '../models/result_model.dart';

// Service TFLite (squelette)
class TFLiteService {
  static const String defaultMetadataAssetPath =
      'assets/data/lstm_dataset_meta.json';

  bool _isInitialized = false;
  LstmDatasetMetadata? _metadata;
  String? _modelPath;

  TFLiteService();

  // Prépare le service
  Future<void> initialize(
    String modelPath, {
    String metadataAssetPath = defaultMetadataAssetPath,
  }) async {
    _modelPath = modelPath;
    _metadata = LstmDatasetMetadata.placeholder(sourcePath: metadataAssetPath);
    _isInitialized = true;
  }

  // Exécute l'inférence
  Future<RecognitionResultData> runInference(
    List<List<double>> sequence,
  ) async {
    if (!_isInitialized) {
      return const RecognitionResultData(
        primaryGesture: 'NotInitialized',
        primaryGestureAr: 'غير مهيأ',
        primaryConfidence: 0.0,
        debug: 'Service not initialized yet.',
      );
    }

    return RecognitionResultData(
      primaryGesture: 'NotImplemented',
      primaryGestureAr: 'غير مطبق',
      primaryConfidence: 0.0,
      sequenceLength: sequence.length,
      debug:
          'TFLite inference will be implemented when model is ready. Model path: ${_modelPath ?? 'unset'}',
    );
  }

  // Libère les ressources
  void dispose() {
    _isInitialized = false;
    _metadata = null;
    _modelPath = null;
  }

  bool get isInitialized => _isInitialized;
  LstmDatasetMetadata? get metadata => _metadata;
}

// Metadata LSTM (squelette)
// 
// Cette classe définit le format attendu
// Le vrai chargement/parsing sera ajouté plus tard
class LstmDatasetMetadata {
  final int seqLen;
  final int numFeatures;
  final List<String> classNames;
  final List<String> landmarkCols;
  final List<double> scalerMean;
  final List<double> scalerScale;
  final String sourcePath;

  const LstmDatasetMetadata({
    required this.seqLen,
    required this.numFeatures,
    required this.classNames,
    required this.landmarkCols,
    required this.scalerMean,
    required this.scalerScale,
    required this.sourcePath,
  });

  // Placeholder metadata used until real parser is implemented
  factory LstmDatasetMetadata.placeholder({required String sourcePath}) {
    return LstmDatasetMetadata(
      seqLen: 10,
      numFeatures: 126,
      classNames: const [],
      landmarkCols: const [],
      scalerMean: const [],
      scalerScale: const [],
      sourcePath: sourcePath,
    );
  }
}
