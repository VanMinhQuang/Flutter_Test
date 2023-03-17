import 'package:bai4/views/fetch_view.dart';
import 'package:bai4/views/home_view.dart';
import 'package:bai4/views/login_view.dart';
import 'package:bai4/views/register_view.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      title: "Bai 4: Login and Register",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const FetchView(),
      routes: {
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
        '/home/': (context) => const HomePage(),
        '/fetch/': (context) => const FetchView()
      }));
}
