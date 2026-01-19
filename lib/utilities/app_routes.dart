import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/pages/signin_page.dart';
import 'package:chat_app/pages/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static final GoRouter router = GoRouter(
    initialLocation: FirebaseAuth.instance.currentUser != null
        ? '/'
        : '/signIn',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const ChatPage()),
      GoRoute(path: '/signIn', builder: (context, state) => const SignInPage()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
    ],
    redirect: (context, state) {
      final loggedIn = FirebaseAuth.instance.currentUser != null;
      final loggingIn =
          state.matchedLocation == '/signIn' ||
          state.matchedLocation == '/register';

      if (!loggedIn && !loggingIn) return '/signIn';
      if (loggedIn && loggingIn) return '/';
      return null;
    },
  );
}
