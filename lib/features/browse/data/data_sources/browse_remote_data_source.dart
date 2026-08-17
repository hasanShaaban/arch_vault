import 'package:arch_vault/core/errors/exceptions.dart';
import 'package:arch_vault/core/network/api_service.dart';
import 'package:arch_vault/features/home/data/models/get_models_response_model.dart';
import 'package:arch_vault/features/home/domain/entities/get_models_response_entity.dart';
import 'package:dio/dio.dart';

import '../../domain/data_source/search_remote_data_source.dart';

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final ApiService apiService;

  SearchRemoteDataSourceImpl(this.apiService);
  @override
  Future<GetModelsResponseEntity> search({
    String? q,
    String? superCategory,
    String? subFamily,
    String? styleClass,
    required int page,
  }) async {
    try {
      final response = await apiService.get(
        'models/search/?keyword=$q&ai_label=$superCategory&style=$styleClass&object_category=$subFamily&page=$page',
      );
      final data = response.data;
      if (data == null) {
        throw ServerException(message: 'Invalid response from server');
      }
      return GetModelsResponseModel.fromJson(data);
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    } catch (e) {
      throw ServerException(message: 'Failed to get models');
    }
  }
}
