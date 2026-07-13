import 'package:dartz/dartz.dart';
import 'package:the_warehouse_gym/core/errors/failures.dart';
import '../entities/bmi_entry.dart';
import '../repositories/bmi_repository.dart';

class BmiUseCase {
  final BmiRepository _repository;

  const BmiUseCase(this._repository);

  Future<Either<Failure, List<BmiEntry>>> getBmiHistory(String uid) =>
      _repository.getBmiHistory(uid);

  Future<Either<Failure, void>> addBmiEntry(
    String uid,
    BmiEntry entry, {
    required double heightCm,
    required double weightKg,
  }) =>
      _repository.addBmiEntry(
        uid,
        entry,
        heightCm: heightCm,
        weightKg: weightKg,
      );
}
