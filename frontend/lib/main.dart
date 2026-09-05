import 'package:flutter/material.dart';

import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const PaktexApp());
}

class PaktexApp extends StatelessWidget {
  const PaktexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Paktex',

      theme: AppTheme.lightTheme,

      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: '/login',
    );
  }
}