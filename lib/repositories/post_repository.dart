import '../models/comment_model.dart';
import '../models/post_model.dart';

abstract class PostRepository {
  Future<List<PostModel>> getPosts();
  Future<PostModel> getPost(int id);
  Future<List<PostModel>> getUserPosts(int userId);
  Future<PostModel> createPost(PostModel post);
  Future<PostModel> updatePost(PostModel post);
  Future<void> deletePost(int id);
  Future<List<CommentModel>> getPostComments(int postId);
  Future<CommentModel> createComment(CommentModel comment);
}
