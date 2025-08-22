import 'package:dio/dio.dart';
import '../../auth/data/secure_storage_service.dart';
import '../../quiz/data/quiz_models.dart';
import '../../teachers/data/teacher_model.dart';

class FavoritesDataSource {
  final Dio _dio = Dio();
  final String _baseUrl = 'http://10.0.2.2:8000/api';
  final SecureStorageService _storageService = SecureStorageService();

  Future<List<Teacher>> getFavoriteTeachers() async {
    try {
      final token = await _storageService.getToken();
      final response = await _dio.get(
        '$_baseUrl/get/teachers/favorite/student',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final List<dynamic> teachersJson = response.data['teachers'];
      return teachersJson.map((json) => Teacher.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return [];
      throw Exception('Failed to load favorite teachers: ${e.message}');
    }
  }

  Future<List<TestSession>> getFavoriteTests(int teacherId) async {
    try {
      final token = await _storageService.getToken();
      final response = await _dio.get(
        '$_baseUrl/get/tests/from/favorite/$teacherId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final List<dynamic> testsJson = response.data['test '];

      return testsJson.map((json) {
        final questionsData = json['questions'] as List;
        return TestSession(
          testId: json['id'],
          questions: questionsData.map((q) => Question.fromJson(q)).toList(),
        );
      }).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return [];
      throw Exception('Failed to load favorite tests: ${e.message}');
    }
  }
}
