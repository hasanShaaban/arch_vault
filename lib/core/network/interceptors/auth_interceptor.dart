import 'package:arch_vault/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor();
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    //TODO: get token from local data source
    // final token = local.getToken();
    // if (token != null) {
    //   options.headers['Authorization'] = 'Bearer $token';
    // }
    handler.next(options);
  }
}
