import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:password_genarator/models/password.dart';
import 'package:password_genarator/screens/splash_screen.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PasswordAdapter());
  await Hive.openBox<Password>('passwords');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      title: 'Password Genarator',
      home: const SplashPage(),
    );
  }
}
