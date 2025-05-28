import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/post_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/post_card.dart';

class UserProfilePage extends ConsumerWidget {
  final int userId;

  const UserProfilePage({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider(userId));
    final userPostsAsync = ref.watch(userPostsProvider(userId));

    return Scaffold(
      appBar: AppBar(title: const Text('Kullanıcı Profili')),
      body: userAsync.when(
        data: (user) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            child: Text(user.name[0], style: const TextStyle(fontSize: 32)),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user.name, style: Theme.of(context).textTheme.headlineSmall),
                                Text(
                                  '@${user.username}',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        leading: const Icon(Icons.email),
                        title: const Text('Email'),
                        subtitle: Text(user.email),
                      ),
                      ListTile(
                        leading: const Icon(Icons.phone),
                        title: const Text('Telefon'),
                        subtitle: Text(user.phone),
                      ),
                      ListTile(
                        leading: const Icon(Icons.language),
                        title: const Text('Website'),
                        subtitle: Text(user.website),
                      ),
                      ListTile(
                        leading: const Icon(Icons.business),
                        title: const Text('Şirket'),
                        subtitle: Text(user.company.name),
                      ),
                      ListTile(
                        leading: const Icon(Icons.location_on),
                        title: const Text('Adres'),
                        subtitle: Text(
                          '${user.address.street}, ${user.address.suite}\n'
                          '${user.address.city}, ${user.address.zipcode}',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text('Gönderiler', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              userPostsAsync.when(
                data: (posts) => ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return PostCard(post: post, onTap: () => context.push('/post/${post.id}'));
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => Text('Hata: $error'),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Hata: $error')),
      ),
    );
  }
}
