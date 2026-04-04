import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/scan_result.dart';
import '../repositories/scanner_repository.dart';

class SaveScanResult {
  final ScannerRepository repository;
  SaveScanResult(this.repository);

  Future<Either<Failure, void>> call(ScanResult result) async {
    return await repository.saveScanResult(result);
  }
}
