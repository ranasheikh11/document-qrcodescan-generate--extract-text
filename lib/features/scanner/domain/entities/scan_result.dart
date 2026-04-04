import 'package:equatable/equatable.dart';

class ScanResult extends Equatable {
  final String text;
  final DateTime dateTime;
  final String? type; // 'OCR' or 'QR'

  const ScanResult({
    required this.text,
    required this.dateTime,
    this.type,
  });

  @override
  List<Object?> get props => [text, dateTime, type];
}
