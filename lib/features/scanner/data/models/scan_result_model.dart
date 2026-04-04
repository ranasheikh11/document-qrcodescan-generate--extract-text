import '../../domain/entities/scan_result.dart';

class ScanResultModel extends ScanResult {
  const ScanResultModel({
    required super.text,
    required super.dateTime,
    super.type,
  });

  factory ScanResultModel.fromJson(Map<String, dynamic> json) {
    return ScanResultModel(
      text: json['text'],
      dateTime: DateTime.parse(json['dateTime']),
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'dateTime': dateTime.toIso8601String(),
      'type': type,
    };
  }

  factory ScanResultModel.fromEntity(ScanResult result) {
    return ScanResultModel(
      text: result.text,
      dateTime: result.dateTime,
      type: result.type,
    );
  }
}
