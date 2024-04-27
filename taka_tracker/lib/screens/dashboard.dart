import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taka_tracker/widgets/line_chart.dart';
import 'package:taka_tracker/models/expense.dart';
import 'package:taka_tracker/services/database.dart';
import 'form.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key});

  @override
  State<StatefulWidget> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<StatefulWidget> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final databaseService = DatabaseService();
  final firebase = FirebaseFirestore.instance;

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

      //CRUD operations through List
      body: Column(
        children: [
          SizedBox(
            height: 250,
            child: CustomLineChart(),
          ),
          Expanded(
            child: StreamBuilder(
              stream: firebase.collection('users').doc(currentUser!.uid).collection('expenses').orderBy('time').snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  var userExpensesData = snapshot.data.docs;
                  return userExpensesData.length != 0
                    ? ListView.builder(
                      itemCount: userExpensesData.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Material(
                            elevation: 2, // Elevation for the box shadow
                            shadowColor: Colors.grey.withOpacity(0.5), // Shadow color
                            borderRadius: BorderRadius.circular(10), 
                            child: InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) => const FormScreen(),
                                );
                              },
                              onLongPress: ()
                              {databaseService.deleteExpense(userExpensesData[index].id);},
                              splashColor: Colors.yellow,
                              highlightColor: Colors.red,
                              child: Container(
                                decoration: const BoxDecoration (
                                color: Colors.white10,
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    userExpensesData[index]['name'],
                                    style: const TextStyle(color: Colors.black), // Set color to black
                                  ),
                                  Text(
                                    '${userExpensesData[index]['price']} TK',
                                    style: const TextStyle(color: Colors.green), // Set color to green
                                  ),
                                ],
                                  ),
                                ),
                              ),
                            )
                          )
                        );
                      },
                    )
                  : const Center(
                    child: Text("Add an expense!"));
          } else {
            return const Center(
              child: CircularProgressIndicator(), // Loading indicator
                );
          }
              },
            ),
          )
        ]
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () {
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
                    icon: Icon(Icons.menu))),
            IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
          ],
        ),
      ),
    );
  }
}
