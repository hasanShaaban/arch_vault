import 'package:arch_vault/core/errors/exceptions.dart';
import 'package:arch_vault/core/network/api_service.dart';
import 'package:arch_vault/features/home/data/models/model_3d_model.dart';
import 'package:arch_vault/features/model_detail/domain/data_source/model_detail_remote_data_source.dart';
import 'package:dio/dio.dart';

class ModelDetailRemoteDataSourceImpl implements ModelDetailRemoteDataSource {
  final ApiService apiService;

  ModelDetailRemoteDataSourceImpl(this.apiService);

  @override
  Future<List<Model3dModel>> getSimilar(String ids) async {
    try {
      final response = await apiService.get(
        'models/similar-models/?model_id=$ids&limit=12',
      );
      final List<dynamic> rawList = response.data;

      final List<Model3dModel> models = rawList
          .map((json) => Model3dModel.fromJson(json))
          .toList();
      return models;
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    } catch (e) {
      throw ServerException(message: 'Failed to get models');
    }
  }

  @override
  Future<bool> reportModel({required String id, required String reason}) async {
    try {
      final response = await apiService.post(
        'models/report/',
        body: {'model': id, 'reason': reason},
      );
      return response.statusCode == 201;
    } catch (e) {
      throw ServerException(message: 'Failed to report model');
    }
  }
}
