import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:hive/hive.dart';
import '../models/scan_result_model.dart';

abstract class ScannerLocalDataSource {
  Future<String> getTextFromImage(File image);
  Future<void> saveScanResult(ScanResultModel result);
  Future<List<ScanResultModel>> getRecentHistory();
}

class ScannerLocalDataSourceImpl implements ScannerLocalDataSource {
  final TextRecognizer _textRecognizer = TextRecognizer();
  final Box<ScanResultModel> scanBox;

  ScannerLocalDataSourceImpl({required this.scanBox}) {
    _pruneExpiredData();
  }

  /// Removes data older than 7 days from the Hive box.
  void _pruneExpiredData() {
    final now = DateTime.now();
    final keysToDelete = <dynamic>[];

    for (var key in scanBox.keys) {
      final item = scanBox.get(key);
      if (item != null) {
        final difference = now.difference(item.dateTime).inDays;
        if (difference >= 7) {
          keysToDelete.add(key);
        }
      }
    }

    if (keysToDelete.isNotEmpty) {
      scanBox.deleteAll(keysToDelete);
    }
  }

  @override
  Future<String> getTextFromImage(File image) async {
    final inputImage = InputImage.fromFile(image);
    final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
    return recognizedText.text;
  }

  @override
  Future<void> saveScanResult(ScanResultModel result) async {
    // Check for pruning before saving as well
    _pruneExpiredData();
    await scanBox.add(result);
  }

  @override
  Future<List<ScanResultModel>> getRecentHistory() async {
    _pruneExpiredData();
    // Return items sorted by date (newest first)
    final history = scanBox.values.toList();
    history.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return history;
  }
}
