import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/scan_result.dart';
import '../../domain/usecases/get_recent_history.dart';
import '../../domain/usecases/get_text_from_image.dart';
import '../../domain/usecases/save_scan_result.dart';
import 'scanner_event.dart';
import 'scanner_state.dart';

class ScannerBloc extends Bloc<ScannerEvent, ScannerState> {
  final GetTextFromImage getTextFromImage;
  final SaveScanResult saveScanResult;
  final GetRecentHistory getRecentHistory;

  ScannerBloc({
    required this.getTextFromImage,
    required this.saveScanResult,
    required this.getRecentHistory,
  }) : super(ScannerInitial()) {
    on<ScanImageEvent>(_onScanImage);
    on<SaveScanEvent>(_onSaveResult);
    on<GetHistoryEvent>(_onGetHistory);
  }

  Future<void> _onScanImage(ScanImageEvent event, Emitter<ScannerState> emit) async {
    emit(ScannerLoading());
    final result = await getTextFromImage(event.image);
    result.fold(
      (failure) => emit(ScannerError(failure.message)),
      (text) => emit(ScannerResultState(text)),
    );
  }

  Future<void> _onSaveResult(SaveScanEvent event, Emitter<ScannerState> emit) async {
    final result = await saveScanResult(ScanResult(
      text: event.text,
      dateTime: DateTime.now(),
      type: event.type,
    ));
    result.fold(
      (failure) => emit(ScannerError(failure.message)),
      (_) {
        emit(SaveSuccess());
        add(GetHistoryEvent());
      },
    );
  }

  Future<void> _onGetHistory(GetHistoryEvent event, Emitter<ScannerState> emit) async {
    final result = await getRecentHistory();
    result.fold(
      (failure) => emit(ScannerError(failure.message)),
      (history) => emit(HistoryLoadedState(history)),
    );
  }
}
