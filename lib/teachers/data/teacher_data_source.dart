import 'package:dio/dio.dart';

import 'teacher_model.dart';
import '../../auth/data/secure_storage_service.dart';

class TeacherDataSource {
  final Dio _dio = Dio();
  final String _baseUrl = 'http://10.0.2.2:8000/api';
  final SecureStorageService _storageService = SecureStorageService();

  Future<List<Teacher>> getTeachersForSubject(int subjectId) async {
    try {
      final token = await _storageService.getToken();

      final response = await _dio.get(
        '$_baseUrl/get/teachers/subject/$subjectId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final List<dynamic> teacherJsonList = response.data;
      return teacherJsonList.map((json) => Teacher.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to load teachers: ${e.message}');
    }
  }
}
