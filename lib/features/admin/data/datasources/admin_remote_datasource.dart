import 'package:arch_vault/core/errors/exceptions.dart';
import 'package:arch_vault/core/network/api_service.dart';
import 'package:arch_vault/features/admin/data/models/get_reports_response_model.dart';
import 'package:arch_vault/features/admin/domain/entities/get_reports_response_entity.dart';
import 'package:dio/dio.dart';

abstract class AdminRemoteDataSource {
  // Future<AdminDashboardEntity> getDashboard();

  // Future<void> resolveReport(String id);

  // Future<void> dismissReport(String id);

  // Future<void> setUserRole(String id, String role);

  // Future<void> updateModelLabel(String modelId, String label);
  Future<GetReportsResponseEntity> getResponse();
}

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  final ApiService apiService;

  AdminRemoteDataSourceImpl(this.apiService);

  @override
  Future<GetReportsResponseEntity> getResponse() async {
    try {
      final response = await apiService.get('models/admin/reports/');
      final data = response.data;
      if (data == null) {
        throw ServerException(message: 'Invalid response from server');
      }
      return GetReportsResponseModel.fromJson(data);
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    } catch (e) {
      throw ServerException(message: 'Failed to get models');
    }
  }
}
