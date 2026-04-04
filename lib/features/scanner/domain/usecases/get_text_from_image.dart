import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/scanner_repository.dart';

class GetTextFromImage {
  final ScannerRepository repository;
  GetTextFromImage(this.repository);

  Future<Either<Failure, String>> call(File image) async {
    return await repository.getTextFromImage(image);
  }
}
