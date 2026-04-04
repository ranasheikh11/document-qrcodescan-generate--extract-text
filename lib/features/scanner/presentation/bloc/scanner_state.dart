import 'package:equatable/equatable.dart';
import '../../domain/entities/scan_result.dart';

abstract class ScannerState extends Equatable {
  const ScannerState();
  
  @override
  List<Object?> get props => [];
}

class ScannerInitial extends ScannerState {}

class ScannerLoading extends ScannerState {}

class ScannerResultState extends ScannerState {
  final String text;
  const ScannerResultState(this.text);

  @override
  List<Object?> get props => [text];
}

class HistoryLoadedState extends ScannerState {
  final List<ScanResult> history;
  const HistoryLoadedState(this.history);

  @override
  List<Object?> get props => [history];
}

class ScannerError extends ScannerState {
  final String message;
  const ScannerError(this.message);

  @override
  List<Object?> get props => [message];
}

class SaveSuccess extends ScannerState {}
