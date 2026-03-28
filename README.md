# tsl_mobile_app

A Flutter mobile application using camera capture, on-device TensorFlow Lite inference, speech synthesis, and permission management.

## Dependencies

The following packages are currently installed:

- `camera: ^0.9.8+1` : Accesses device cameras for image capture and stream handling.
- `tflite_flutter: ^0.9.0` : Runs TensorFlow Lite models on-device.
- `tflite_flutter_helper: ^0.3.1` : Provides preprocessing/postprocessing utilities for TFLite inputs and outputs.
- `flutter_tts: ^3.8.0` : Converts text to speech on mobile platforms.
- `provider: ^6.0.0` : Lightweight state management and dependency injection.
- `permission_handler: ^11.0.0` : Requests and checks runtime permissions.
- `path_provider: ^2.0.15` : Gets platform-specific filesystem paths (documents, temp, cache).
- `cupertino_icons: ^1.0.8` : iOS-style icon set for Flutter widgets.

## Project Structure

The application follows a feature-based architecture, ensuring modularity, scalability, and maintainability.

```text
lib/
│
├── main.dart
│
├── core/
│   ├── utils/
│   ├── constants/
│
├── features/
│
│   ├── camera/
│   │   ├── camera_service.dart
│   │   ├── camera_screen.dart
│
│   ├── recognition/
│   │   ├── models/
│   │   │     └── gesture_model.dart
│   │   ├── services/
│   │   │     ├── mediapipe_service.dart
│   │   │     ├── tflite_service.dart
│   │   │     ├── inference_service.dart
│   │   ├── managers/
│   │   │     └── sequence_manager.dart
│
│   ├── history/
│   │   ├── models/
│   │   │     └── history_item.dart
│   │   ├── services/
│   │   │     └── history_storage.dart
│   │   ├── screens/
│   │   │     └── history_screen.dart
│
│   ├── settings/
│   │   ├── models/
│   │   │     └── settings_model.dart
│   │   ├── screens/
│   │   │     └── settings_screen.dart
│
│   ├── home/
│   │   └── home_screen.dart
│
├── shared/
│   ├── widgets/
│   ├── providers/
```

## Processing Pipeline

The gesture recognition follows this pipeline:

- `Camera → MediaPipe → Landmarks → Sequence Buffer → LSTM → Prediction`

1. The camera captures real-time frames.
2. MediaPipe extracts hand landmarks.
3. A sequence of frames is stored.
4. The LSTM model processes the sequence.
5. The prediction is displayed and stored in the history.

## Key Features

- Real-time sign language recognition
- Fully offline processing
- Local history storage
- User settings customization

## Getting Started

Install packages:

```bash
flutter pub get
```

Run the app:

```bash
flutter run
```

For first-time Flutter setup and platform requirements, see the official docs:

- [Flutter documentation](https://docs.flutter.dev/)
