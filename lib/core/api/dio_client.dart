import 'package:dio/dio.dart';

import '../../auth/data/secure_storage_service.dart';

class DioClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:8000/api',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    ),
  )..interceptors.add(AuthInterceptor());

  static Dio get instance => _dio;
}

class AuthInterceptor extends Interceptor {
  final SecureStorageService _storageService = SecureStorageService();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storageService.getToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }
}
