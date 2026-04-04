import 'package:equatable/equatable.dart';

class ScanResult extends Equatable {
  final String text;
  final DateTime dateTime;
  final String? type; // 'OCR' or 'QR'
  final String? status; // e.g. 'OCR DONE', '65% UPLOADED'
  final double? progress; // 0.0 to 1.0
  final String? fileName;
  final String? category; // e.g. 'PDF', 'QR', 'TEXT', 'LEGAL', 'NETWORK'

  const ScanResult({
    required this.text,
    required this.dateTime,
    this.type,
    this.status,
    this.progress,
    this.fileName,
    this.category,
  });

  @override
  List<Object?> get props => [text, dateTime, type, status, progress, fileName, category];
}
