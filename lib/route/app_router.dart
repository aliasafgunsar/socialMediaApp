import 'package:case_tasks/pages/home_page.dart';
import 'package:case_tasks/pages/post_detail_page.dart';
import 'package:case_tasks/pages/post_form_page.dart';
import 'package:case_tasks/pages/user_list_page.dart';
import 'package:case_tasks/pages/user_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomePage()),
    GoRoute(path: '/users', builder: (context, state) => const UserListPage()),
    GoRoute(path: '/post/create', builder: (context, state) => const PostFormPage()),
    GoRoute(
      path: '/post/edit/:id',
      builder: (context, state) {
        final postId = int.parse(state.pathParameters['id']!);
        return PostFormPage(postId: postId);
      },
    ),
    GoRoute(
      path: '/post/:id',
      builder: (context, state) {
        final postId = int.parse(state.pathParameters['id']!);
        return PostDetailPage(postId: postId);
      },
    ),
    GoRoute(
      path: '/user/:id',
      builder: (context, state) {
        final userId = int.parse(state.pathParameters['id']!);
        return UserProfilePage(userId: userId);
      },
    ),
  ],
);
