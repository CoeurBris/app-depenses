import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'repositories/auth_repository.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'utils/date_utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation des dates
  await AppDateUtils.init();

  // On passe par le Repository pour vérifier la connexion
  final authRepository = AuthRepository();
  final bool isLoggedIn = await authRepository.isAuthenticated();

  runApp(MainApp(isLoggedIn: isLoggedIn));
}

class MainApp extends StatelessWidget {
  final bool isLoggedIn;

  const MainApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SenaTrack',
      theme: appTheme,
      home: isLoggedIn ? const DashboardScreen() : const LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}