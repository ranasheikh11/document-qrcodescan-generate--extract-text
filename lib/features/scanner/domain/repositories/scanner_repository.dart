import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/scan_result.dart';

abstract class ScannerRepository {
  Future<Either<Failure, String>> getTextFromImage(File image);
  Future<Either<Failure, void>> saveScanResult(ScanResult result);
  Future<Either<Failure, List<ScanResult>>> getRecentHistory();
}
