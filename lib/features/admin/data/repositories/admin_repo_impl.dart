import 'package:dartz/dartz.dart';

import '../../../../core/errors/exception_to_faliure_mapper.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../datasources/admin_local_datasource.dart';
import '../datasources/admin_remote_datasource.dart';
import '../../domain/entities/get_reports_response_entity.dart';
import '../../domain/repositories/admin_repo.dart';

class AdminRepoImpl implements AdminRepo {
  AdminRepoImpl(this._localDataSource, this._remoteDataSource);

  final AdminLocalDataSource _localDataSource;
  final AdminRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, GetReportsResponseEntity>> getReports() async {
    try {
      final response = await _remoteDataSource.getResponse();
      return right(response);
    } on AppException catch (e) {
      return left(mapExceptionToFailure(e));
    } catch (_) {
      return left(UnknownFailure());
    }
  }
}
