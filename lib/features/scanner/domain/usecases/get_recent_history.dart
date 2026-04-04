import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/scan_result.dart';
import '../repositories/scanner_repository.dart';

class GetRecentHistory {
  final ScannerRepository repository;
  GetRecentHistory(this.repository);

  Future<Either<Failure, List<ScanResult>>> call() async {
    return await repository.getRecentHistory();
  }
}
