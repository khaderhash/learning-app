import 'package:dio/dio.dart';
import 'subject_model.dart';
import '../../auth/data/secure_storage_service.dart';

class SubjectDataSource {
  final Dio _dio = Dio();
  final String _baseUrl = 'http://10.0.2.2:8000/api';
  final SecureStorageService _storageService = SecureStorageService();

  Future<List<Subject>> getSubjects() async {
    try {
      final token = await _storageService.getToken();
      if (token == null) {
        throw Exception('User not authenticated');
      }

      final response = await _dio.get(
        '$_baseUrl/get/subjects',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final List<dynamic> subjectJsonList = response.data['subjects'];
      return subjectJsonList.map((json) => Subject.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to load subjects: ${e.message}');
    }
  }

  Future<String> requestToJoinSubject(int subjectId, int teacherId) async {
    try {
      final token = await _storageService.getToken();
      final formData = FormData.fromMap({
        'subject_id': subjectId,
        'teacher_id': teacherId,
      });

      final response = await _dio.post(
        '$_baseUrl/student/request-subject',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return response.data['message'];
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to submit request',
      );
    }
  }
}
