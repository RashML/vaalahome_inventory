import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:inventory_app/features/camera/permission/camera_permission_manager.dart';
import 'package:inventory_app/features/camera/preview/camera_preview_source.dart';
import 'package:inventory_app/features/camera/preview/mobile_scanner_preview_source.dart';
import 'package:inventory_app/features/camera/preview/web_camera_release.dart';
import 'package:inventory_app/features/camera/qr/mobile_scanner_qr_detector.dart';
import 'package:inventory_app/features/camera/qr/qr_detector.dart';
import 'package:inventory_app/features/item/presentation/item_details_page.dart';
import 'package:inventory_app/l10n/app_localizations.dart';
import 'package:inventory_app/shared/di/locator.dart';
import 'package:inventory_app/shared/widgets/app_toast.dart';

/// Live camera QR scanner.
///
/// On a detected item QR (`{"id":"<itemId>"}`, see ItemQrSharePage), replaces
/// itself with [ItemDetailsPage], which stops the camera; back then returns
/// to the page that opened the scanner (home).
class ScanPage extends StatefulWidget {
  static const path = '/scan';

  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  late final MobileScannerController _controller;
  late final CameraPreviewSource _preview;
  late final QrDetector _detector;
  StreamSubscription<String>? _subscription;

  bool _ready = false;
  bool _permissionDenied = false;
  bool _cameraError = false;
  bool _handling = false;
  String? _errorDetail;

  @override
  void initState() {
    super.initState();
    // Started manually, after the permission check.
    _controller = MobileScannerController(
      autoStart: false,
      formats: const [BarcodeFormat.qrCode],
    );
    _preview = MobileScannerPreviewSource(_controller);
    _detector = MobileScannerQrDetector(_controller);
    _subscription = _detector.codes.listen(_onCode);
    // MobileScanner.start() needs the MobileScanner widget to be attached,
    // so wait for the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _start();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _controller.dispose();
    releaseWebCameraTracks();
    super.dispose();
  }

  Future<void> _start() async {
    setState(() {
      _ready = false;
      _permissionDenied = false;
      _cameraError = false;
      _errorDetail = null;
    });
    try {
      // The browser prompts for camera access itself on web, and
      // permission_handler doesn't support web.
      if (!kIsWeb) {
        await getIt<CameraPermissionManager>().requestOrThrow();
      }
      await _preview.start();
      if (mounted) setState(() => _ready = true);
    } on CameraPermissionDeniedException {
      if (mounted) setState(() => _permissionDenied = true);
    } on MobileScannerException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorDetail = '${e.errorCode}: ${e.errorDetails?.message ?? e.toString()}';
        if (e.errorCode == MobileScannerErrorCode.permissionDenied) {
          _permissionDenied = true;
        } else {
          _cameraError = true;
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _cameraError = true;
          _errorDetail = e.toString();
        });
      }
    }
  }

  Future<void> _onCode(String raw) async {
    if (_handling) return;
    final itemId = _parseItemId(raw);
    if (itemId == null) {
      _handling = true;
      AppToast.error(context, AppLocalizations.of(context)!.scanInvalidCode);
      // Don't re-toast on every frame while the same code stays in view.
      await Future<void>.delayed(const Duration(seconds: 2));
      _handling = false;
      return;
    }
    _handling = true;
    // Replace (not push) so the scanner is disposed and the camera released;
    // back from the details page then returns to whatever opened the scan
    // page (home).
    await _preview.stop();
    // mobile_scanner's web stop() leaves the browser camera running.
    releaseWebCameraTracks();
    if (!mounted) return;
    context.pushReplacement(ItemDetailsPage.location(itemId));
  }

  static String? _parseItemId(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map && decoded['id'] is String) {
        final id = decoded['id'] as String;
        if (id.isNotEmpty) return id;
      }
    } catch (_) {}
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final Widget? overlay;
    if (_permissionDenied) {
      overlay = _MessageView(
        icon: Icons.no_photography_outlined,
        title: l10n.scanPermissionDenied,
        message: kIsWeb ? l10n.scanPermissionStepsWeb : l10n.scanPermissionStepsApp,
        detail: kDebugMode ? _errorDetail : null,
        actions: [
          if (!kIsWeb)
            FilledButton(
              onPressed: () => getIt<CameraPermissionManager>().openSettings(),
              child: Text(l10n.scanOpenSettingsCta),
            ),
          OutlinedButton(onPressed: _start, child: Text(l10n.itemFormRetryCta)),
        ],
      );
    } else if (_cameraError) {
      overlay = _MessageView(
        icon: Icons.videocam_off_outlined,
        message: l10n.scanCameraError,
        detail: kDebugMode ? _errorDetail : null,
        actions: [
          OutlinedButton(onPressed: _start, child: Text(l10n.itemFormRetryCta)),
        ],
      );
    } else if (!_ready) {
      overlay = const Center(child: CircularProgressIndicator());
    } else {
      overlay = null;
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.scanTitle)),
      // The preview stays mounted (so the controller stays attached and can be
      // restarted); loading/error/guide screens are drawn on top of it.
      body: Stack(
        fit: StackFit.expand,
        children: [
          _preview.buildPreview(),
          if (overlay != null)
            ColoredBox(color: Theme.of(context).colorScheme.surface, child: overlay),
        ],
      ),
    );
  }
}

class _MessageView extends StatelessWidget {
  const _MessageView({
    required this.icon,
    this.title,
    required this.message,
    this.detail,
    required this.actions,
  });

  final IconData icon;
  final String? title;
  final String message;
  final String? detail;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: theme.colorScheme.onSurfaceVariant),
            if (title != null) ...[
              const SizedBox(height: 12),
              Text(title!, style: theme.textTheme.titleMedium, textAlign: TextAlign.center),
            ],
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            if (detail != null) ...[
              const SizedBox(height: 8),
              SelectableText(
                detail!,
                textAlign: TextAlign.center,
                textDirection: TextDirection.ltr,
                style: theme.textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 16),
            Wrap(spacing: 12, runSpacing: 8, alignment: WrapAlignment.center, children: actions),
          ],
        ),
      ),
    );
  }
}
