import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  State<CurrencyConverterScreen> createState() =>
      _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 203, 228, 218),
      appBar: AppBar(
        primary: true,
        backgroundColor: const Color.fromARGB(
          255,
          198,
          227,
          216,
        ),
      ),
      body: const Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Taka',
                style: TextStyle(
                  color: Color.fromARGB(255, 27, 100, 61),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'Tracker\'s',
                style: TextStyle(
                  color: Color.fromARGB(255, 19, 30, 68),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Currency Converter',
            style: TextStyle(
              color: Color.fromARGB(255, 19, 30, 68),
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
            ),
            textAlign: TextAlign.center,
          ),
          Spacer(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(255, 165, 198, 187),
        elevation: 20,
        height: 55,
        shape: const CircularNotchedRectangle(),
        shadowColor: const Color.fromARGB(255, 45, 50, 48),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.popAndPushNamed(context, '/dashboard');
                },
                color: const Color.fromARGB(255, 36, 46, 41),
                icon: const Icon(Icons.home)),
            Opacity(
              opacity: .0,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.menu),
              ),
            ),
            IconButton(
                onPressed: () {
                  Navigator.popAndPushNamed(context, '/currency_converter');
                },
                color: const Color.fromARGB(255, 36, 46, 41),
                icon: const Icon(Icons.currency_exchange_outlined)),
          ],
        ),
      ),
    );
  }
}
