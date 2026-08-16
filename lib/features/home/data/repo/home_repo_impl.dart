import 'package:arch_vault/core/errors/exception_to_faliure_mapper.dart';
import 'package:arch_vault/core/errors/exceptions.dart';
import 'package:arch_vault/core/errors/failure.dart';
import 'package:arch_vault/features/home/domain/data_source/home_remote_data_sorce.dart';

import 'package:arch_vault/features/home/domain/entities/get_models_response_entity.dart';

import 'package:dartz/dartz.dart';

import '../../domain/entities/model_asset_entity.dart';
import '../../domain/repo/home_repo.dart';
import '../data_sources/home_local_data_source.dart';

class HomeRepoImpl implements HomeRepo {
  HomeRepoImpl(this._localDataSource, this._remoteDataSource);

  final HomeLocalDataSource _localDataSource;
  final HomeRemoteDataSource _remoteDataSource;

  @override
  Future<List<ModelAssetEntity>> getFeaturedModels() async {
    final models = await _localDataSource.getFeaturedModels();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Either<Failure, GetModelsResponseEntity>> getAllModels({
    required int page,
  }) async {
    try {
      final response = await _remoteDataSource.getAllModels(page: page);
      return right(response);
    } on AppException catch (e) {
      return left(mapExceptionToFailure(e));
    } catch (_) {
      return left(UnknownFailure());
    }
  }
}
