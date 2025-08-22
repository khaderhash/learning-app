import 'package:dio/dio.dart';
import 'package:student_app/quiz/data/test_history_model.dart';
import 'quiz_models.dart';
import '../../auth/data/secure_storage_service.dart';

class QuizDataSource {
  final Dio _dio = Dio();
  final String _baseUrl = 'http://10.0.2.2:8000/api';
  final SecureStorageService _storageService = SecureStorageService();

  Future<TestSession> createTest(int lessonId, int questionsCount) async {
    try {
      final token = await _storageService.getToken();
      final formData = FormData.fromMap({
        'lesson_ids': '[$lessonId]',
        'questions_count': questionsCount,
      });

      final response = await _dio.post(
        '$_baseUrl/create/test/student',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final testData = response.data['test'];
      final questionsData = response.data['questions'] as List;

      return TestSession(
        testId: testData['id'],
        questions: questionsData.map((q) => Question.fromJson(q)).toList(),
      );
    } catch (e) {
      throw Exception('Failed to create test: $e');
    }
  }

  Future<Map<String, int>> submitAnswers(
    int testId,
    Map<int, int> answers,
  ) async {
    try {
      final token = await _storageService.getToken();
      final Map<String, String> formattedAnswers = {};
      answers.forEach((key, value) {
        formattedAnswers['answers[$key]'] = value.toString();
      });

      final formData = FormData.fromMap(formattedAnswers);

      final response = await _dio.post(
        '$_baseUrl/tests/$testId/submit',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return {
        'correct': response.data['correct_answers_count'],
        'incorrect': response.data['incorrect_answers_count'],
      };
    } catch (e) {
      throw Exception('Failed to submit answers: $e');
    }
  }

  Future<List<TestHistory>> getUserTests() async {
    try {
      final token = await _storageService.getToken();
      final response = await _dio.get(
        '$_baseUrl/get/tests/user',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final List<dynamic> testsJson = response.data['tests'];
      return testsJson.map((json) => TestHistory.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return [];
      }
      throw Exception('Failed to get user tests: ${e.message}');
    }
  }

  Future<Map<String, int>> getTestResult(int testId) async {
    try {
      final token = await _storageService.getToken();
      final response = await _dio.get(
        '$_baseUrl/tests/$testId/result',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final resultData = response.data['result'];
      return {
        'correct': resultData['correct_answers_count'],
        'incorrect': resultData['incorrect_answers_count'],
      };
    } catch (e) {
      throw Exception('Failed to get test result: $e');
    }
  }
}
