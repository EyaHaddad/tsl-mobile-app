# tsl_mobile_app

Flutter mobile app for Tunisian sign language recognition with on-device inference, local history persistence, and text to speech playback

## Current Stack

- camera
- tflite_flutter
- tflite_flutter_helper
- flutter_tts
- permission_handler
- shared_preferences
- isar
- isar_flutter_libs
- freezed and json_serializable
- flutter_svg
- intl

## Main Features

- Camera capture flow for recognition
- On-device TensorFlow Lite inference
- Local history saved in Isar
- Favorites support in history
- Auto-delete for expired non-favorite records based on settings
- On-demand text to speech from result and history detail screens
- Persistent storage settings with SharedPreferences

## Project Structure

```text
lib/
├── main.dart
├── core/
│   ├── constants/
│   ├── database/
│   │   └── isar_service.dart
│   ├── routes/
│   ├── services/
│   │   ├── history_retention_service.dart
│   │   └── text_to_speech_service.dart
│   ├── theme/
│   └── utils/
├── features/
│   ├── camera/
│   ├── history/
│   │   ├── models/
│   │   │   └── history_record.dart
│   │   ├── screens/
│   │   │   ├── history_screen.dart
│   │   │   └── item_history_screen.dart
│   │   └── services/
│   │       └── history_storage.dart
│   ├── home/
│   ├── recognition/
│   │   ├── managers/
│   │   ├── models/
│   │   ├── screens/
│   │   │   └── result_screen.dart
│   │   └── services/
│   └── settings/
│       ├── models/
│       │   └── settings_model.dart
│       ├── screens/
│       │   └── settings_screen.dart
│       └── services/
│           └── settings_service.dart
└── shared/
	├── providers/
	└── widgets/
```

## Recognition Pipeline

Camera -> MediaPipe landmarks -> sequence buffer -> LSTM inference -> predicted text

## Audio Behavior

- Audio is practical and on-demand
- User taps play or convert to voice to run TTS
- Language, rate, and pitch are loaded from saved settings

## History Retention Rules

- Favorites are persistent
- Non-favorite records can be removed automatically when expired
- Auto-delete and retention duration are managed in settings

## Getting Started

Install dependencies

```bash
flutter pub get
```

Run the app

```bash
flutter run
```

Run static analysis

```bash
flutter analyze
```

Run tests

```bash
flutter test
```
