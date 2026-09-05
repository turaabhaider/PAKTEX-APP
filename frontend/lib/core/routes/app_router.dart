import 'package:flutter/material.dart';

import '../../screens/auth/login_screen.dart';
import '../../screens/main_navigation_screen.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );

      case '/home':
        return MaterialPageRoute(
          builder: (_) => const MainNavigationScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
    }
  }
}