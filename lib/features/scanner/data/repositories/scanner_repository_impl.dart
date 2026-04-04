import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/scan_result.dart';
import '../../domain/repositories/scanner_repository.dart';
import '../datasources/scanner_local_datasource.dart';
import '../models/scan_result_model.dart';

class ScannerRepositoryImpl implements ScannerRepository {
  final ScannerLocalDataSource localDataSource;

  ScannerRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, String>> getTextFromImage(File image) async {
    try {
      final text = await localDataSource.getTextFromImage(image);
      return Right(text);
    } catch (e) {
      return Left(OCRFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveScanResult(ScanResult result) async {
    try {
      await localDataSource.saveScanResult(ScanResultModel.fromEntity(result));
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ScanResult>>> getRecentHistory() async {
    try {
      final results = await localDataSource.getRecentHistory();
      return Right(results);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
