import 'package:arch_vault/core/errors/exception_to_faliure_mapper.dart';
import 'package:arch_vault/core/errors/exceptions.dart';
import 'package:arch_vault/core/errors/failure.dart';
import 'package:arch_vault/features/browse/domain/data_source/search_remote_data_source.dart';
import 'package:arch_vault/features/home/domain/entities/get_models_response_entity.dart';
import 'package:dartz/dartz.dart';

import '../../domain/entities/browse_asset_entity.dart';
import '../../domain/repo/browse_repo.dart';
import '../data_sources/browse_local_data_source.dart';

class BrowseRepoImpl implements BrowseRepo {
  BrowseRepoImpl(this._localDataSource, this._remoteDataSource);

  final BrowseLocalDataSource _localDataSource;
  final SearchRemoteDataSource _remoteDataSource;

  @override
  Future<List<BrowseAssetEntity>> getAssets() async {
    final models = await _localDataSource.getAssets();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Either<Failure, GetModelsResponseEntity>> search({
    String? q,
    String? superCategory,
    String? subFamily,
    String? styleClass,
    required int page,
  }) async {
    try {
      return right(
        await _remoteDataSource.search(
          q: q,
          superCategory: superCategory,
          subFamily: subFamily,
          styleClass: styleClass,
          page: page,
        ),
      );
    } on AppException catch (e) {
      return left(mapExceptionToFailure(e));
    } catch (_) {
      return left(UnknownFailure());
    }
  }
}
