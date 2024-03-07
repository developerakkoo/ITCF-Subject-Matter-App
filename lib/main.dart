import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subjectmatter/providers/auth_provider.dart';
import 'package:subjectmatter/screens/login_screen.dart';
import 'package:subjectmatter/screens/register_screen.dart';
import 'package:subjectmatter/screens/splash_screen.dart';
import 'package:subjectmatter/screens/upload_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: MaterialApp(
        title: 'Subject Matter',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': ((context) => const UploadFilesScreen()),
          '/login': ((context) => const LoginScreen()),
          '/register': ((context) => const RegisterScreen()),
          '/upload': ((context) => const UploadFilesScreen())
        },
      ),
    );
  }
}
