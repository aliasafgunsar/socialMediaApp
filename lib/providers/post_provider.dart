import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/comment_model.dart';
import '../models/post_model.dart';
import '../repositories/post_repository.dart';
import '../repositories/post_repository_impl.dart';
import '../services/api_service.dart';

final postRepositoryProvider = StateProvider<PostRepository>((ref) {
  return PostRepositoryImpl(ApiService());
});

final postsProvider = FutureProvider<List<PostModel>>((ref) async {
  final repository = ref.watch(postRepositoryProvider);
  return repository.getPosts();
});

final postProvider = FutureProvider.family<PostModel, int>((ref, id) async {
  final repository = ref.watch(postRepositoryProvider);
  return repository.getPost(id);
});

final userPostsProvider = FutureProvider.family<List<PostModel>, int>((ref, userId) async {
  final repository = ref.watch(postRepositoryProvider);
  return repository.getUserPosts(userId);
});

final postCommentsProvider = FutureProvider.family<List<CommentModel>, int>((ref, postId) async {
  final repository = ref.watch(postRepositoryProvider);
  return repository.getPostComments(postId);
});

final createPostProvider = FutureProvider.family<PostModel, PostModel>((ref, post) async {
  final repository = ref.watch(postRepositoryProvider);
  return repository.createPost(post);
});

final updatePostProvider = FutureProvider.family<PostModel, PostModel>((ref, post) async {
  final repository = ref.watch(postRepositoryProvider);
  return repository.updatePost(post);
});

final deletePostProvider = FutureProvider.family<void, int>((ref, id) async {
  final repository = ref.watch(postRepositoryProvider);
  await repository.deletePost(id);
});

final createCommentProvider = FutureProvider.family<CommentModel, CommentModel>((
  ref,
  comment,
) async {
  final repository = ref.watch(postRepositoryProvider);
  return repository.createComment(comment);
});
