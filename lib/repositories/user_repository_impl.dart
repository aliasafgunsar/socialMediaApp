import 'package:case_tasks/repositories/user_repository.dart';

import '../models/user_model.dart';
import '../services/api_service.dart';

class UserRepositoryImpl implements UserRepository {
  final ApiService _apiService;

  UserRepositoryImpl(this._apiService);

  @override
  Future<List<UserModel>> getUsers() async {
    final response = await _apiService.get('/users');
    if (response.data is List) {
      return (response.data as List).map((json) => UserModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  @override
  Future<UserModel> getUser(int id) async {
    final response = await _apiService.get('/users/$id');
    return UserModel.fromJson(response.data);
  }
}
