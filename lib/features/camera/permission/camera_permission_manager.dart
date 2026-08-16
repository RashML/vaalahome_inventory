/// Resolved state of the OS camera permission.
enum CameraPermissionState {
  granted,
  denied,

  /// Denied and the OS won't show the request dialog again; user must enable
  /// it from system settings.
  permanentlyDenied,

  /// Restricted by e.g. parental controls; the user cannot grant it.
  restricted,
}

/// Thrown by [CameraPermissionManager.requestOrThrow] when permission isn't
/// granted.
class CameraPermissionDeniedException implements Exception {
  const CameraPermissionDeniedException(this.state);

  final CameraPermissionState state;

  @override
  String toString() => 'CameraPermissionDeniedException: $state';
}

/// Checks/requests the OS camera permission, independent of whatever reads
/// the camera afterwards (preview, QR detection, ...).
abstract interface class CameraPermissionManager {
  Future<CameraPermissionState> checkStatus();

  Future<CameraPermissionState> request();
}

extension CameraPermissionManagerX on CameraPermissionManager {
  /// Convenience wrapper: requests permission, throwing
  /// [CameraPermissionDeniedException] if it isn't [CameraPermissionState.granted].
  Future<void> requestOrThrow() async {
    final state = await request();
    if (state != CameraPermissionState.granted) {
      throw CameraPermissionDeniedException(state);
    }
  }
}
