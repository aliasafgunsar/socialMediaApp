import 'package:case_tasks/repositories/post_repository.dart';

import '../models/comment_model.dart';
import '../models/post_model.dart';
import '../services/api_service.dart';

class PostRepositoryImpl implements PostRepository {
  final ApiService _apiService;

  PostRepositoryImpl(this._apiService);

  @override
  Future<List<PostModel>> getPosts() async {
    final response = await _apiService.get('/posts');
    if (response.data is List) {
      return (response.data as List).map((json) => PostModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  @override
  Future<PostModel> getPost(int id) async {
    final response = await _apiService.get('/posts/$id');
    if (response.data is Map<String, dynamic>) {
      return PostModel.fromJson(response.data);
    } else if (response.data is Map) {
      return PostModel.fromJson(Map<String, dynamic>.from(response.data));
    } else {
      throw Exception('Beklenmeyen veri tipi: ${response.data.runtimeType}');
    }
  }

  @override
  Future<List<PostModel>> getUserPosts(int userId) async {
    final response = await _apiService.get('/posts', queryParameters: {'userId': userId});
    if (response.data is List) {
      return (response.data as List).map((json) => PostModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  @override
  Future<PostModel> createPost(PostModel post) async {
    final response = await _apiService.post('/posts', data: post.toJson());
    return PostModel.fromJson(response.data);
  }

  @override
  Future<PostModel> updatePost(PostModel post) async {
    final response = await _apiService.put('/posts/${post.id}', data: post.toJson());
    return PostModel.fromJson(response.data);
  }

  @override
  Future<void> deletePost(int id) async {
    await _apiService.delete('/posts/$id');
  }

  @override
  Future<List<CommentModel>> getPostComments(int postId) async {
    final response = await _apiService.get('/posts/$postId/comments');
    if (response.data is List) {
      return (response.data as List).map((json) => CommentModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  @override
  Future<CommentModel> createComment(CommentModel comment) async {
    final response = await _apiService.post('/comments', data: comment.toJson());
    return CommentModel.fromJson(response.data);
  }
}
