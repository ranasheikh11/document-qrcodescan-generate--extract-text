import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../models/scan_result_model.dart';

abstract class ScannerLocalDataSource {
  Future<String> getTextFromImage(File image);
  Future<void> saveScanResult(ScanResultModel result);
  Future<List<ScanResultModel>> getRecentHistory();
}

class ScannerLocalDataSourceImpl implements ScannerLocalDataSource {
  final TextRecognizer _textRecognizer = TextRecognizer();
  
  // For simplicity, we'll use a local list for history in this session
  // In a real app, use SharedPreferences or a Database
  final List<ScanResultModel> _history = [];

  @override
  Future<String> getTextFromImage(File image) async {
    final inputImage = InputImage.fromFile(image);
    final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
    return recognizedText.text;
  }

  @override
  Future<void> saveScanResult(ScanResultModel result) async {
    _history.insert(0, result);
    if (_history.length > 10) _history.removeLast();
  }

  @override
  Future<List<ScanResultModel>> getRecentHistory() async {
    return _history;
  }
}
