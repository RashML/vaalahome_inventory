# Project Rules

## Builds & Verification

- The agent MUST NOT run builds (`flutter build`, `flutter run`, `flutter analyze`, `flutter test`, etc.) — the Flutter/Dart SDK is not available in the agent's PATH.
- Whenever a build, analysis, or test run is needed, the agent must STOP and ask the user to run it, then wait for the user's output before proceeding.
