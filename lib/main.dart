import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kitchen_pal/api/auth_service.dart';
import 'package:kitchen_pal/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:kitchen_pal/screens/auth_gate.dart';
import 'package:kitchen_pal/utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: MaterialApp(
        title: 'KitchenPal',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: const AuthGate(),
      ),
    );
  }
}