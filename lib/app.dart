import 'package:flutter/material.dart';
import 'package:provider/provider.dart';              // ← add this import
import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'config/routes.dart';
import 'features/auth/providers/auth_provider.dart';

class KrishokBondhonApp extends StatelessWidget {
  const KrishokBondhonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(                             // ← wrap MaterialApp here
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),              // ← your new line goes here
        ),
        // future providers go here too, e.g.:
        // ChangeNotifierProvider(create: (_) => DiseaseProvider()),
        // ChangeNotifierProvider(create: (_) => CommunityProvider()),
      ],
      child: MaterialApp(                             // ← MaterialApp becomes the child
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}