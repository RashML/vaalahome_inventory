import 'package:mobile_scanner/mobile_scanner.dart';

import 'qr_detector.dart';

/// [QrDetector] implementation backed by `mobile_scanner`.
///
/// Takes the [MobileScannerController] rather than owning it, so it reads
/// the same feed a [CameraPreviewSource] node is rendering.
class MobileScannerQrDetector implements QrDetector {
  MobileScannerQrDetector(this._controller);

  final MobileScannerController _controller;

  @override
  Stream<String> get codes => _controller.barcodes
      .expand((capture) => capture.barcodes)
      .where((barcode) => barcode.format == BarcodeFormat.qrCode)
      .map((barcode) => barcode.rawValue)
      .where((value) => value != null)
      .cast<String>();
}
