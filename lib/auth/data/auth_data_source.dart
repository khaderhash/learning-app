import 'package:dio/dio.dart';

class AuthDataSource {
  final Dio _dio = Dio();
  final String _baseUrl = 'http://10.0.2.2:8000/api';
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      final formData = FormData.fromMap({
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      });

      final response = await _dio.post('$_baseUrl/register', data: formData);

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      print(e);
      throw Exception('Failed to register');
    }
  }

  Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  }) async {
    try {
      final formData = FormData.fromMap({'phone': phone, 'password': password});

      final response = await _dio.post('$_baseUrl/login', data: formData);

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Invalid phone number or password');
      }

      throw Exception('');
    }
  }
}
