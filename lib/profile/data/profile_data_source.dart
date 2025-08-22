import 'dart:io';
import 'package:dio/dio.dart';
import 'user_model.dart';
import '../../auth/data/secure_storage_service.dart';

class ProfileDataSource {
  final Dio _dio = Dio();
  final String _baseUrl = 'http://10.0.2.2:8000/api';
  final SecureStorageService _storageService = SecureStorageService();

  Future<UserModel> getUserProfile() async {
    try {
      final token = await _storageService.getToken();
      final response = await _dio.get(
        '$_baseUrl/get/user',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return UserModel.fromJson(response.data['user'][0]);
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  Future<String> changePassword(String oldPassword, String newPassword) async {
    try {
      final token = await _storageService.getToken();
      final formData = FormData.fromMap({
        'old_password': oldPassword,
        'new_password': newPassword,
      });

      final response = await _dio.post(
        '$_baseUrl/change-password',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return response.data['message'];
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to change password',
      );
    }
  }

  Future<String> updateUserImage(File imageFile) async {
    try {
      final token = await _storageService.getToken();
      String fileName = imageFile.path.split('/').last;
      final formData = FormData.fromMap({
        'user_image': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });
      final response = await _dio.post(
        '$_baseUrl/add/image/profile',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data['user_image'];
    } catch (e) {
      throw Exception('Failed to update image: $e');
    }
  }
}
