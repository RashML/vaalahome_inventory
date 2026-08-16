/// Reads camera buffers and emits decoded QR values.
///
/// Doesn't own the camera or its preview — that's [CameraPreviewSource]'s
/// job, kept separate so either side can be swapped independently (e.g. a
/// different decode engine, or a mock that emits canned values).
abstract interface class QrDetector {
  /// Emits a decoded QR value each time one is detected in a camera frame.
  Stream<String> get codes;
}
