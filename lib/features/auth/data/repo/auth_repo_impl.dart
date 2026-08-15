import 'package:arch_vault/core/errors/exception_to_faliure_mapper.dart';
import 'package:arch_vault/core/errors/exceptions.dart';
import 'package:arch_vault/core/errors/failure.dart';
import 'package:arch_vault/features/auth/domain/data_source.dart/auth_local_data_source.dart';
import 'package:arch_vault/features/auth/domain/data_source.dart/auth_remote_data_source.dart';
import 'package:arch_vault/features/auth/domain/entities/auth_token_entity.dart';
import 'package:arch_vault/features/auth/domain/entities/sign_up_response_entity.dart';
import 'package:dartz/dartz.dart';
import '../../domain/repo/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  AuthRepoImpl({
    required this.authRemoteDataSource,
    required this.authLocalDataSource,
  });

  @override
  Future<Either<Failure, AuthTokenEntity>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await authRemoteDataSource.signIn(
        email: email,
        password: password,
      );
      await authLocalDataSource.saveTokens(
        accessToken: response.access,
        refreshToken: response.refresh,
      );
      return right(response);
    } on AppException catch (e) {
      return left(mapExceptionToFailure(e));
    } catch (_) {
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, SignUpResponseEntity>> signUp({
    required String email,
    required String password,
    required String username,
    required String confirmPassword,
    required String role,
  }) async {
    try {
      final response = await authRemoteDataSource.signUp(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        username: username,
        role: role,
      );
      return right(response);
    } on AppException catch (e) {
      return left(mapExceptionToFailure(e));
    } catch (_) {
      return left(UnknownFailure());
    }
  }
}
