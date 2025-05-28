import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_model.dart';
import '../repositories/user_repository.dart';
import '../repositories/user_repository_impl.dart';
import '../services/api_service.dart';

final userRepositoryProvider = StateProvider<UserRepository>((ref) {
  return UserRepositoryImpl(ApiService());
});

final usersProvider = FutureProvider<List<UserModel>>((ref) async {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getUsers();
});

final userProvider = FutureProvider.family<UserModel, int>((ref, id) async {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getUser(id);
});
