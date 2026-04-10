import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ShareException implements Exception {
  const ShareException(this.message);
  final String message;

  @override
  String toString() => 'ShareException: $message';
}

class ShareService {
  // Future<void> shareCard(GlobalKey key) async {
  //   final boundary =
  //       key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
  //   if (boundary == null) {
  //     throw const ShareException('Could not find render boundary');
  //   }
  //
  //   final ui.Image image;
  //   try {
  //     image = await boundary.toImage(pixelRatio: 3.0);
  //   } catch (e) {
  //     throw ShareException('Failed to capture widget: $e');
  //   }
  //
  //   final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  //   if (byteData == null) {
  //     throw const ShareException('Failed to encode image');
  //   }
  //
  //   final dir = await getTemporaryDirectory();
  //   final file = File('${dir.path}/sentence_card.png');
  //   try {
  //     await file.writeAsBytes(byteData.buffer.asUint8List());
  //     await Share.shareXFiles([XFile(file.path)]);
  //   } finally {
  //     if (await file.exists()) {
  //       await file.delete();
  //     }
  //   }
  // }


  Future<void> shareCard(GlobalKey key) async {
    final boundary =
    key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) {
      throw const ShareException('Could not find render boundary');
    }

    final ui.Image image;
    try {
      image = await boundary.toImage(pixelRatio: 3.0);
    } catch (e) {
      throw ShareException('Failed to capture widget: $e');
    }

    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      throw const ShareException('Failed to encode image');
    }

    // 공유 시트 위치 계산
    final box = key.currentContext?.findRenderObject() as RenderBox?;
    final position = box != null
        ? box.localToGlobal(Offset.zero) & box.size
        : null;

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/sentence_card.png');
    try {
      await file.writeAsBytes(byteData.buffer.asUint8List());
      await Share.shareXFiles(
        [XFile(file.path)],
        sharePositionOrigin: position,
      );
    } finally {
      if (await file.exists()) {
        await file.delete();
      }
    }
  }
}
