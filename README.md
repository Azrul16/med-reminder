# Med Reminder

A Flutter medicine reminder app with authentication, medicine scheduling, local notifications, a medicine information browser, and a BMI calculator. The app stores medicine entries locally, schedules reminder notifications based on dosage intervals, and uses Firebase for authentication.

## Features

- Firebase authentication with login and signup screens.
- Splash screen and authenticated home flow.
- Add, view, toggle, and delete medicine reminders.
- Local notification scheduling for medicine intervals.
- SharedPreferences persistence for saved medicines.
- Medicine list/search screen with external drug-label lookup.
- BMI calculator.
- Success animation after creating a medicine entry.

## Tech Stack

- Flutter
- Dart
- Firebase Core and Firebase Auth
- Flutter Local Notifications
- Provider and RxDart
- SharedPreferences
- Sizer and Google Fonts
- OpenFDA drug label API

## Project Structure

```text
medicine_reminder/
|-- lib/
|   |-- main.dart
|   |-- global_bloc.dart
|   |-- local_notification.dart
|   |-- models/
|   `-- pages/
|-- assets/
|-- patched/flare_flutter/
`-- pubspec.yaml
```

## Getting Started

```bash
cd medicine_reminder
flutter pub get
flutter run
```

## Firebase Setup

The project includes `firebase_options.dart`, but you should connect it to your own Firebase project before publishing or sharing builds. Configure Firebase Auth providers and verify that Android/iOS bundle identifiers match your Firebase apps.

## Notes

Notification behavior should be tested on a real device. Platform notification permissions, exact alarms, and background behavior can vary by Android/iOS version.
