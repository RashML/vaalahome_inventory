import 'package:flutter/widgets.dart';

/// Owns the camera capture lifecycle and renders a live preview.
///
/// Doesn't decide what happens with the frames it captures — that's
/// [QrDetector]'s job, kept separate so either side can be swapped
/// independently.
abstract interface class CameraPreviewSource {
  Future<void> start();

  /// Builds the live camera preview widget. Only valid after [start].
  Widget buildPreview();

  Future<void> stop();
}
