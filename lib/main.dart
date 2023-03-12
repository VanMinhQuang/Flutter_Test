import 'package:bai4/firebase_options.dart';
import 'package:bai4/views/home_view.dart';
import 'package:bai4/views/login_view.dart';
import 'package:bai4/views/register_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      title: "Bai 4: Login and Register",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginView(),
      routes: {
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
        '/home/': (context) => const HomePage()
      }));
}
