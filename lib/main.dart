import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'views/home_page.dart';
import 'views/login_page.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // INIT SUPABASE
  await Supabase.initialize(

    url:
    'https://ozncwqoprwqeculkpphf.supabase.co',

    anonKey:
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im96bmN3cW9wcndxZWN1bGtwcGhmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzg1ODE2MDQsImV4cCI6MjA5NDE1NzYwNH0.9y8klbgwLBvkhmEHlZoO6VTw2R7UaRYxcvge4iSP4Ug',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    final session =
        Supabase.instance.client.auth.currentSession;

    return GetMaterialApp(

      debugShowCheckedModeBanner: false,

      title: 'Fillix',

      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
      ),

      home:
      session != null
          ? const HomePage()
          : const LoginPage(),
    );
  }
}