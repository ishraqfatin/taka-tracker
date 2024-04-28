import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          child: Row(
            children: [
              const Icon(
                Icons.person,
                size: 18,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                'Welcome, ${currentUser?.email?.split('@')[0]}',
                style: const TextStyle(
                  fontSize: 14,
                ),
              )
            ],
          ),
        ),
        primary: true,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            iconSize: 20,
            onPressed: () async {
              final auth = FirebaseAuth.instance;

              await auth.signOut();

              // Navigate to Sing_in page
              Navigator.popAndPushNamed(context, '/sign_in');
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Column(
        children: [
          const Text('Welcome to TakaTracker'),
          SizedBox(height: 20.0), // Spacer
          // Button
          ElevatedButton(
            onPressed: () {
              // Button action
            },
            child: Text('Button'),
          ),
          Spacer(),
          IconButton(
              onPressed: () async {
                final auth = FirebaseAuth.instance;

                await auth.signOut();

                // Navigate to Sing_in page
                Navigator.popAndPushNamed(context, '/sign_in');
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        height: 58,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.popAndPushNamed(context, '/dashboard');
                },
                icon: const Icon(Icons.home)),
            Opacity(
                opacity: 0.0,
                child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons
                        .menu))), // I want this icon button to be invisible and unclickable
            IconButton(
                onPressed: () {
                  Navigator.popAndPushNamed(context, '/menu');
                },
                icon: const Icon(Icons.menu)),
          ],
        ),
      ),
    );
  }
}
