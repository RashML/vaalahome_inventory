import 'package:flutter/widgets.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'camera_preview_source.dart';

/// [CameraPreviewSource] implementation backed by `mobile_scanner`.
///
/// Takes the [MobileScannerController] rather than owning it, so the same
/// controller's frame stream can also feed a [QrDetector] node.
class MobileScannerPreviewSource implements CameraPreviewSource {
  MobileScannerPreviewSource(this._controller);

  final MobileScannerController _controller;

  @override
  Future<void> start() => _controller.start();

  @override
  Widget buildPreview() => MobileScanner(controller: _controller);

  @override
  Future<void> stop() => _controller.stop();
}
