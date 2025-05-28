import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/user_provider.dart';

class UserListPage extends ConsumerWidget {
  const UserListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Kullanıcılar')),
      body: usersAsync.when(
        data: (users) {
          print('Kullanıcılar: $users');
          if (users.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Sunucudan kullanıcı alınamadı. Lütfen internet bağlantınızı ve API erişimini kontrol edin.',
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                color: Colors.purple.shade50,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.purple,
                    child: Text(user.name[0], style: const TextStyle(color: Colors.white)),
                  ),
                  title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('@${user.username}'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => context.push('/user/${user.id}'),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          print('Kullanıcılar hata: $error');
          return Center(
            child: Text(
              'Kullanıcılar yüklenemedi. Lütfen internet bağlantınızı ve API erişimini kontrol edin.\nHata: $error',
            ),
          );
        },
      ),
    );
  }
}
