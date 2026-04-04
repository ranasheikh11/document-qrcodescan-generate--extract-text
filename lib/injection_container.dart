import 'package:hive_flutter/hive_flutter.dart';
import 'features/scanner/data/models/scan_result_model.dart';
import 'package:get_it/get_it.dart';
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
  //! External
  await Hive.initFlutter();
  Hive.registerAdapter(ScanResultModelAdapter());
  final scanBox = await Hive.openBox<ScanResultModel>('scans');
  sl.registerLazySingleton(() => scanBox);
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
    () => ScannerLocalDataSourceImpl(scanBox: sl()),
  );

  //! External
  sl.registerLazySingleton(() => ImagePicker());
}
