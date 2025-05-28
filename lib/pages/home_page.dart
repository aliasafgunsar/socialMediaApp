import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/post_provider.dart';
import '../widgets/post_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(postsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sosyal Medya'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              context.push('/users');
            },
          ),
        ],
      ),
      body: postsAsync.when(
        data: (posts) {
          print('Ana sayfa gönderiler: $posts');
          if (posts.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(9.0),
                child: Text(
                  'Sunucudan gönderi alınamadı. Lütfen internet bağlantınızı ve API erişimini kontrol edin.',
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return PostCard(post: post, onTap: () => context.push('/post/${post.id}'));
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          print('Ana sayfa gönderi hata: $error');
          return Center(
            child: Text(
              'Gönderiler yüklenemedi. Lütfen internet bağlantınızı ve API erişimini kontrol edin.\nHata: $error',
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/post/create'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
