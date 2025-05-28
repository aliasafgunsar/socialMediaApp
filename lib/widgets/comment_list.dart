import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/comment_model.dart';
import '../providers/post_provider.dart';

class CommentList extends ConsumerStatefulWidget {
  final int postId;

  const CommentList({super.key, required this.postId});

  @override
  ConsumerState<CommentList> createState() => _CommentListState();
}

class _CommentListState extends ConsumerState<CommentList> {
  final _commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commentsAsync = ref.watch(postCommentsProvider(widget.postId));

    return Column(
      children: [
        commentsAsync.when(
          data: (comments) => ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: comments.length,
            itemBuilder: (context, index) {
              final comment = comments[index];
              return CommentCard(comment: comment);
            },
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Text('Hata: $error'),
        ),
        const SizedBox(height: 16),
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _commentController,
                decoration: const InputDecoration(
                  labelText: 'Yorumunuz',
                  hintText: 'Yorumunuzu yazın...',
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir yorum yazın';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _submitComment, child: const Text('Yorum Yap')),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _submitComment() async {
    if (_formKey.currentState?.validate() ?? false) {
      final comment = CommentModel(
        id: 0, // API otomatik ID atayacak
        postId: widget.postId,
        name: 'Anonim', // Gerçek uygulamada kullanıcı adı kullanılır
        email: 'anonim@example.com', // Gerçek uygulamada kullanıcı email'i kullanılır
        body: _commentController.text,
      );
      try {
        await ref.read(createCommentProvider(comment).future);
        _commentController.clear();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text('Yorum başarıyla eklendi!', style: TextStyle(color: Colors.white)),
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text('Yorum eklenirken hata oluştu: $e', style: const TextStyle(color: Colors.white)),
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }
}

class CommentCard extends StatelessWidget {
  final CommentModel comment;

  const CommentCard({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(child: Text(comment.name[0])),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        comment.email,
                        style: Theme.of(context).textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(comment.body),
          ],
        ),
      ),
    );
  }
}
