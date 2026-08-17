import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import 'package:inventory_app/features/home/presentation/home_page.dart';
import 'package:inventory_app/l10n/app_localizations.dart';
import 'package:inventory_app/shared/widgets/app_toast.dart';

/// Shows the QR generated from a newly created item's ID, with sharing and
/// printing options. Reached from [ItemCreatePage] after a successful
/// create.
class ItemQrSharePage extends StatefulWidget {
  static const path = '/items/:id/qr';

  static String location(String itemId) => '/items/$itemId/qr';

  final String itemId;

  const ItemQrSharePage({super.key, required this.itemId});

  @override
  State<ItemQrSharePage> createState() => _ItemQrSharePageState();
}

class _ItemQrSharePageState extends State<ItemQrSharePage> {
  final _qrBoundaryKey = GlobalKey();
  bool _busy = false;

  String get _qrData => '{"id":"${widget.itemId}"}';

  Future<Uint8List?> _captureQrPng() async {
    final boundary =
        _qrBoundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return null;
    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }

  Future<void> _share() async {
    setState(() => _busy = true);
    try {
      final bytes = await _captureQrPng();
      if (bytes == null) return;
      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile.fromData(
              bytes,
              mimeType: 'image/png',
              name: 'item-${widget.itemId}-qr.png',
            ),
          ],
        ),
      );
    } catch (_) {
      if (!mounted) return;
      AppToast.error(context, AppLocalizations.of(context)!.itemQrShareError);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _print() async {
    setState(() => _busy = true);
    try {
      final bytes = await _captureQrPng();
      if (bytes == null) return;
      final image = pw.MemoryImage(bytes);
      await Printing.layoutPdf(
        onLayout: (_) {
          final doc = pw.Document();
          doc.addPage(
            pw.Page(
              build: (context) => pw.Center(
                child: pw.Image(image, width: 240, height: 240),
              ),
            ),
          );
          return doc.save();
        },
      );
    } catch (_) {
      if (!mounted) return;
      AppToast.error(context, AppLocalizations.of(context)!.itemQrPrintError);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go(HomePage.path),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: RepaintBoundary(
                  key: _qrBoundaryKey,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: QrImageView(
                      data: _qrData,
                      size: 220,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _busy ? null : _print,
                      icon: const Icon(Icons.print_outlined),
                      label: Text(l10n.itemQrPrintCta),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _busy ? null : _share,
                      icon: const Icon(Icons.share),
                      label: Text(l10n.itemQrShareCta),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
