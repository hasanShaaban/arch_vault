import 'package:arch_vault/core/errors/exception_to_faliure_mapper.dart';
import 'package:arch_vault/core/errors/exceptions.dart';
import 'package:arch_vault/core/errors/failure.dart';
import 'package:arch_vault/features/home/domain/entities/model_3d_entity.dart';
import 'package:arch_vault/features/model_detail/domain/data_source/model_detail_remote_data_source.dart';
import 'package:dartz/dartz.dart';

import '../../domain/repo/model_detail_repo.dart';

class ModelDetailRepoImpl implements ModelDetailRepo {
  ModelDetailRepoImpl(this._remoteDataSource);
  final ModelDetailRemoteDataSource _remoteDataSource;
  // final ModelDetailLocalDataSource _localDataSource;

  @override
  // Future<ModelDetailEntity> getById(String id) async {
  //   try {
  //     final model = await _localDataSource.getById(id);
  //     return model.toEntity();
  //   } on Failure {
  //     rethrow;
  //   } catch (_) {
  //     throw const Failure('Unexpected model detail error');
  //   }
  // }
  @override
  Future<Either<Failure, List<Model3dEntity>>> getSimilar(String ids) async {
    try {
      final response = await _remoteDataSource.getSimilar(ids);
      return right(response);
    } on AppException catch (e) {
      return left(mapExceptionToFailure(e));
    } catch (_) {
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> reportModel({
    required String id,
    required String reason,
  }) async {
    try {
      final response = await _remoteDataSource.reportModel(
        id: id,
        reason: reason,
      );
      return right(response);
    } on AppException catch (e) {
      return left(mapExceptionToFailure(e));
    } catch (_) {
      return left(UnknownFailure());
    }
  }

  // @override
  // Future<void> downloadModel(String id) {
  //   return _localDataSource.downloadModel(id);
  // }

  // @override
  // Future<double> rateModel({required String id, required int stars}) {
  //   return _localDataSource.rateModel(id: id, stars: stars);
  // }
}
