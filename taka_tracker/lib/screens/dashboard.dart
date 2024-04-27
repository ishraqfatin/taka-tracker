import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taka_tracker/widgets/line_chart.dart';
import 'form.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key});

  @override
  State<StatefulWidget> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<StatefulWidget> {
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          SizedBox(
            height: 250,
            child: CustomLineChart(),
          ),
          const Text("\nExpenses"),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(currentUser?.uid)
                        .collection('expenses')
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        final snap = snapshot.data!.docs;
                        return ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: snap.length,
                          itemBuilder: (context, index) {
                            return Container(
                              height: 70,
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(2, 2),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 20),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      snap[index]['name'],
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(right: 20),
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "\$${snap[index]['price']}",
                                      style: TextStyle(
                                        color: Colors.green.withOpacity(0.7),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () {
          // Show the popup screen
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) => const FormScreen(),
          );
        },
        backgroundColor: const Color.fromARGB(255, 25, 25, 25),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(onPressed: () {}, icon: Icon(Icons.home)),
            Opacity(
                opacity: 0.0,
                child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons
                        .menu))), // I want this icon button to be invisible and unclickable
            IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
          ],
        ),
      ),
    );
  }
}
