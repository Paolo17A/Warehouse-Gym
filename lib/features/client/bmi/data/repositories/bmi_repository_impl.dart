import 'package:dartz/dartz.dart';
import 'package:the_warehouse_gym/core/errors/failures.dart';
import 'package:the_warehouse_gym/core/network/api_client.dart';
import 'package:the_warehouse_gym/core/network/network_info.dart';
import 'package:the_warehouse_gym/features/client/bmi/domain/entities/bmi_entry.dart';
import 'package:the_warehouse_gym/features/client/bmi/domain/repositories/bmi_repository.dart';
import '../models/bmi_entry_model.dart';
import '../services/bmi_service.dart';

class BmiRepositoryImpl implements BmiRepository {
  final BmiService _service;
  final NetworkInfo _networkInfo;

  BmiRepositoryImpl(this._service, this._networkInfo);

  @override
  Future<Either<Failure, List<BmiEntry>>> getBmiHistory(String uid) async {
    if (!await _networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final raw = await _service.getBmiHistory(uid);
      final entries =
          raw.map((e) => BmiEntryModel.fromJson(e).toEntity()).toList()
            ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
      return Right(entries);
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addBmiEntry(
    String uid,
    BmiEntry entry, {
    required double heightCm,
    required double weightKg,
  }) async {
    if (!await _networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      await _service.addBmiEntry(
        uid,
        bmiValue: entry.bmiValue,
        heightCm: heightCm,
        weightKg: weightKg,
        recordedAt: entry.dateTime,
      );
      return const Right(null);
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
