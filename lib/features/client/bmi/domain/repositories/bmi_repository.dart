import 'package:dartz/dartz.dart';
import 'package:the_warehouse_gym/core/errors/failures.dart';
import '../entities/bmi_entry.dart';

abstract class BmiRepository {
  Future<Either<Failure, List<BmiEntry>>> getBmiHistory(String uid);
  Future<Either<Failure, void>> addBmiEntry(
    String uid,
    BmiEntry entry, {
    required double heightCm,
    required double weightKg,
  });
}
