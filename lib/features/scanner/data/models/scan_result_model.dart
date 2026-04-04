import 'package:hive/hive.dart';
import '../../domain/entities/scan_result.dart';

part 'scan_result_model.g.dart';

@HiveType(typeId: 0)
class ScanResultModel extends ScanResult {
  @HiveField(0)
  final String text;
  
  @HiveField(1)
  final DateTime dateTime;
  
  @HiveField(2)
  final String? type;
  
  @HiveField(3)
  final String? status;
  
  @HiveField(4)
  final double? progress;
  
  @HiveField(5)
  final String? fileName;
  
  @HiveField(6)
  final String? category;

  const ScanResultModel({
    required this.text,
    required this.dateTime,
    this.type,
    this.status,
    this.progress,
    this.fileName,
    this.category,
  }) : super(
          text: text,
          dateTime: dateTime,
          type: type,
          status: status,
          progress: progress,
          fileName: fileName,
          category: category,
        );

  factory ScanResultModel.fromJson(Map<String, dynamic> json) {
    return ScanResultModel(
      text: json['text'],
      dateTime: DateTime.parse(json['dateTime']),
      type: json['type'],
      status: json['status'],
      progress: (json['progress'] as num?)?.toDouble(),
      fileName: json['fileName'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'dateTime': dateTime.toIso8601String(),
      'type': type,
      'status': status,
      'progress': progress,
      'fileName': fileName,
      'category': category,
    };
  }

  factory ScanResultModel.fromEntity(ScanResult result) {
    return ScanResultModel(
      text: result.text,
      dateTime: result.dateTime,
      type: result.type,
      status: result.status,
      progress: result.progress,
      fileName: result.fileName,
      category: result.category,
    );
  }
}
