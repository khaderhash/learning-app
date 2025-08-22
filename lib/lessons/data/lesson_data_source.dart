import 'package:dio/dio.dart';
import 'lesson_model.dart';
import '../../auth/data/secure_storage_service.dart';

class LessonDataSource {
  final Dio _dio = Dio();
  final String _baseUrl = 'http://10.0.2.2:8000/api';
  final SecureStorageService _storageService = SecureStorageService();

  Future<List<Lesson>> getLessons(int teacherId, int subjectId) async {
    try {
      final token = await _storageService.getToken();

      final formData = FormData.fromMap({'subject_id': subjectId});

      final response = await _dio.post(
        '$_baseUrl/get/lessons/teacher/$teacherId',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final List<dynamic> lessonJsonList = response.data['lessons'];
      return lessonJsonList.map((json) => Lesson.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return [];
      }
      throw Exception(
        'Failed to load lessons: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }
}
