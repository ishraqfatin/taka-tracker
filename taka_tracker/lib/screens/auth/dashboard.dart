import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'form.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key});

  @override
  State<StatefulWidget> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<StatefulWidget> {
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text("\nExpenses"),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('users').doc(currentUser?.uid).collection('expenses').snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if(snapshot.hasData) {
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
      
      floatingActionButton: FloatingActionButton(
        onPressed: () {
            // Show the popup screen
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) => const FormScreen(),
            );
          },
        backgroundColor: const Color.fromARGB(255, 25, 25, 25),
        child: const Icon(Icons.add, color: Colors.white,),
      ),
    );
  }
}
