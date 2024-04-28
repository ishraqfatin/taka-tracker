import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:taka_tracker/screens/dashboard.dart';
import 'package:taka_tracker/screens/form.dart';
import 'package:taka_tracker/screens/auth/sign_in.dart';
import 'package:taka_tracker/screens/auth/sign_up.dart';
import 'package:taka_tracker/screens/menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      initialRoute: '/sign_in',
      routes: {
        '/sign_in': (context) => const SignInScreen(),
        '/sign_up': (context) => const SignUpScreen(),
        '/form': (context) => const FormScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/menu': (context) => const MenuScreen(),
      },
    );
  }
}
