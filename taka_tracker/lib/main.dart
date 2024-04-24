import 'package:flutter/material.dart';
import 'package:taka_tracker/screens/auth/sign_in.dart';
import 'package:taka_tracker/screens/auth/sign_up.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/sign_in',
      routes: {
        '/sign_in': (context) => SignInScreen(),
        '/sign_up': (context) => SignUpScreen(),
      },
    );
  }
}

