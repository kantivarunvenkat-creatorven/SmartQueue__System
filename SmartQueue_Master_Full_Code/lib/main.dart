import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'theme/app_theme.dart';
import 'screens/gmail_login_screen.dart';
import 'screens/user/user_home_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase init error: $e');
  }
  runApp(const SmartQueueApp());
}

class SmartQueueApp extends StatelessWidget {
  const SmartQueueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartQueue',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const GmailLoginScreen(),
      routes: {
        '/login': (context) => const GmailLoginScreen(),
        '/user_home': (context) => const UserHomeScreen(),
        '/admin_dashboard': (context) => const AdminDashboardScreen(),
      },
    );
  }
}
