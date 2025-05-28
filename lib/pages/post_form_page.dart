import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/post_model.dart';
import '../providers/post_provider.dart';

class PostFormPage extends ConsumerStatefulWidget {
  final int? postId;

  const PostFormPage({super.key, this.postId});

  @override
  ConsumerState<PostFormPage> createState() => _PostFormPageState();
}

class _PostFormPageState extends ConsumerState<PostFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.postId != null) {
      _loadPost();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _loadPost() async {
    final post = await ref.read(postProvider(widget.postId!).future);
    _titleController.text = post.title;
    _bodyController.text = post.body;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.postId == null ? 'Yeni Gönderi' : 'Gönderiyi Düzenle')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Başlık',
                hintText: 'Gönderi başlığını yazın...',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Lütfen bir başlık girin';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _bodyController,
              decoration: const InputDecoration(
                labelText: 'İçerik',
                hintText: 'Gönderi içeriğini yazın...',
              ),
              maxLines: 10,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Lütfen bir içerik girin';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text(widget.postId == null ? 'Gönderi Oluştur' : 'Gönderiyi Güncelle'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final post = PostModel(
        id: widget.postId ?? 0,
        userId: 1, // Gerçek uygulamada giriş yapan kullanıcının ID'si kullanılır
        title: _titleController.text,
        body: _bodyController.text,
      );
      try {
        if (widget.postId == null) {
          await ref.read(createPostProvider(post).future);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Gönderi başarıyla oluşturuldu!'),
                backgroundColor: Colors.green,
              ),
            );
            context.pop();
          }
        } else {
          await ref.read(updatePostProvider(post).future);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Gönderi başarıyla güncellendi!'),
                backgroundColor: Colors.orange,
              ),
            );
            context.pop();
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Hata: $e'), backgroundColor: Colors.red));
        }
      }
    }
  }
}
