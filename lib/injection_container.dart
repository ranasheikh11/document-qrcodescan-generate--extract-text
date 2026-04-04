import 'package:get_it/get_it.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'features/scanner/data/datasources/scanner_local_datasource.dart';
import 'features/scanner/data/repositories/scanner_repository_impl.dart';
import 'features/scanner/domain/repositories/scanner_repository.dart';
import 'features/scanner/domain/usecases/get_text_from_image.dart';
import 'features/scanner/domain/usecases/save_scan_result.dart';
import 'features/scanner/domain/usecases/get_recent_history.dart';
import 'features/scanner/presentation/bloc/scanner_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Scanner
  // Bloc
  sl.registerFactory(
    () => ScannerBloc(
      getTextFromImage: sl(),
      saveScanResult: sl(),
      getRecentHistory: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetTextFromImage(sl()));
  sl.registerLazySingleton(() => SaveScanResult(sl()));
  sl.registerLazySingleton(() => GetRecentHistory(sl()));

  // Repository
  sl.registerLazySingleton<ScannerRepository>(
    () => ScannerRepositoryImpl(
      localDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ScannerLocalDataSource>(
    () => ScannerLocalDataSourceImpl(),
  );

  //! External
  sl.registerLazySingleton(() => ImagePicker());
  sl.registerLazySingleton(() => TextRecognizer(script: TextRecognitionScript.latin));
}
