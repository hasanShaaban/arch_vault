import 'dart:developer';

import 'package:arch_vault/features/auth/domain/data_source.dart/auth_local_data_source.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  const AuthInterceptor({required AuthLocalDataSource localDataSource})
    : _localDataSource = localDataSource;

  final AuthLocalDataSource _localDataSource;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _localDataSource.getAccessToken();
    if (token != null) {
      log(options.baseUrl + options.path);
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
