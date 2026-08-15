import 'package:arch_vault/core/errors/exceptions.dart';
import 'package:arch_vault/core/network/api_service.dart';
import 'package:arch_vault/features/auth/data/models/auth_token_model.dart';
import 'package:arch_vault/features/auth/data/models/sign_up_response_model.dart';
import 'package:arch_vault/features/auth/domain/data_source.dart/auth_remote_data_source.dart';
import 'package:arch_vault/features/auth/domain/entities/auth_token_entity.dart';
import 'package:arch_vault/features/auth/domain/entities/sign_up_response_entity.dart';
import 'package:dio/dio.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService _apiService;

  AuthRemoteDataSourceImpl({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<AuthTokenEntity> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        'auth/login/',
        body: {'email': email, 'password': password},
      );
      final data = response.data;
      if (data == null) {
        throw ServerException(message: 'Invalid login response');
      }
      return AuthTokenModel.fromJson(data);
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    } catch (e) {
      throw ServerException(message: 'Failed to login');
    }
  }

  @override
  Future<SignUpResponseEntity> signUp({
    required String email,
    required String password,
    required String confirmPassword,
    required String username,
    required String role,
  }) async {
    try {
      final response = await _apiService.post(
        'auth/register/',
        body: {
          "username": username,
          'email': email,
          'password': password,
          'password2': confirmPassword,
        },
      );
      final data = response.data;
      if (data == null) {
        throw ServerException(message: 'Invalid login response');
      }
      return SignUpResponseModel.fromJson(data);
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    } catch (e) {
      throw ServerException(message: 'Failed to login');
    }
  }
}
