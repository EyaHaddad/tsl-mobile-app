import '../models/result_model.dart';

// Configuration used for post-processing prediction in real-time
class InferenceConfig {
	final double confidenceThreshold;
	final int smoothWindowSize;
	final int maxFps;

	const InferenceConfig({
		this.confidenceThreshold = 0.5,
		this.smoothWindowSize = 5,
		this.maxFps = 15,
	});
}

// Runtime metrics that we can show in debug mode
class InferenceMetrics {
	final double fps;
	final double avgLatencyMs;
	final int droppedFrames;

	const InferenceMetrics({
		required this.fps,
		required this.avgLatencyMs,
		required this.droppedFrames,
	});
}

// Helper service that will host smoothing + threshold logic
class InferenceService {
	final InferenceConfig config;

	InferenceService({this.config = const InferenceConfig()});

	RecognitionResultData applyPostProcessing(RecognitionResultData raw) {
		return raw;
	}

	InferenceMetrics currentMetrics() {
		return const InferenceMetrics(fps: 0.0, avgLatencyMs: 0.0, droppedFrames: 0);
	}
}

