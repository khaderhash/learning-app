import 'package:dio/dio.dart';
import 'comment_model.dart';
import '../../auth/data/secure_storage_service.dart';

class CommentDataSource {
  final Dio _dio = Dio();
  final String _baseUrl = 'http://10.0.2.2:8000/api';
  final SecureStorageService _storageService = SecureStorageService();

  Future<List<Comment>> getComments(int lessonId) async {
    try {
      final token = await _storageService.getToken();
      final response = await _dio.get(
        '$_baseUrl/get/comment/lesson/$lessonId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final List<dynamic> commentsJson = response.data;
      return commentsJson.map((json) => Comment.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load comments: $e');
    }
  }

  Future<void> addComment({
    required int lessonId,
    required String content,
    int? parentId,
  }) async {
    try {
      final token = await _storageService.getToken();
      final formData = FormData.fromMap({
        'lesson_id': lessonId,
        'content': content,
        if (parentId != null) 'parent_id': parentId,
      });

      final response = await _dio.post(
        '$_baseUrl/add/comment',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } catch (e) {
      throw Exception('Failed to add comment: $e');
    }
  }

  Future<List<Comment>> getReplies(int commentId) async {
    try {
      final token = await _storageService.getToken();
      final response = await _dio.get(
        '$_baseUrl/get/replies/comment/$commentId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final List<dynamic> repliesJson = response.data;
      return repliesJson.map((json) => Comment.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return [];
      throw Exception('Failed to load replies: ${e.message}');
    }
  }
}
