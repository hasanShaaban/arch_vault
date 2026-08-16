import 'package:arch_vault/core/errors/exceptions.dart';
import 'package:arch_vault/core/network/api_service.dart';
import 'package:arch_vault/features/home/data/models/get_models_response_model.dart';
import 'package:arch_vault/features/home/domain/data_source/home_remote_data_sorce.dart';
import 'package:arch_vault/features/home/domain/entities/get_models_response_entity.dart';
import 'package:dio/dio.dart';

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiService apiService;

  HomeRemoteDataSourceImpl(this.apiService);
  @override
  Future<GetModelsResponseEntity> getAllModels({required int page}) async {
    try {
      final response = await apiService.get('models/?page=$page');
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
