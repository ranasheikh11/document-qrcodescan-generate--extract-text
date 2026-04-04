import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class ScannerEvent extends Equatable {
  const ScannerEvent();

  @override
  List<Object?> get props => [];
}

class ScanImageEvent extends ScannerEvent {
  final File image;
  const ScanImageEvent(this.image);

  @override
  List<Object?> get props => [image];
}

class SaveScanEvent extends ScannerEvent {
  final String text;
  final String type;
  const SaveScanEvent({required this.text, required this.type});

  @override
  List<Object?> get props => [text, type];
}

class GetHistoryEvent extends ScannerEvent {}
