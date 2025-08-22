import 'package:dio/dio.dart';
import '../../quiz/data/quiz_models.dart';
import '../../auth/data/secure_storage_service.dart';

class QuestionDataSource {
  final Dio _dio = Dio();
  final String _baseUrl = 'http://10.0.2.2:8000/api';
  final SecureStorageService _storageService = SecureStorageService();

  Future<List<Question>> getBrowseableQuestions(int lessonId) async {
    try {
      final token = await _storageService.getToken();
      final response = await _dio.get(
        '$_baseUrl/get/questions/options/$lessonId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      final List<dynamic> questionsJson = response.data;
      return questionsJson.map((json) => Question.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return [];
      }
      print(
        'Failed to load browseable questions: ${e.response?.data ?? e.message}',
      );
      throw Exception('Failed to load questions');
    }
  }
}
