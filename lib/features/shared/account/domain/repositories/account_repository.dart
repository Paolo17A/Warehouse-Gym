import 'package:dartz/dartz.dart';
import 'package:the_warehouse_gym/core/errors/failures.dart';
import 'package:the_warehouse_gym/features/shared/account/domain/entities/full_user.dart';

abstract class AccountRepository {
  Future<Either<Failure, FullUser>> getProfile(String uid);

  Future<Either<Failure, void>> updateProfile(
    String uid,
    Map<String, dynamic> data,
  );

  Future<Either<Failure, String>> uploadProfileImage(
    String uid,
    String filePath,
  );
}
