import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:taka_tracker/widgets/line_chart.dart';
import 'package:taka_tracker/services/database.dart';
import 'form.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();
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
      body: Column(children: [
        const SizedBox(
          height: 250,
          child: CustomLineChart(),
        ),
        const Text("Expenses"),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: StreamBuilder(
              stream: firebase
                  .collection('users')
                  .doc(currentUser!.uid)
                  .collection('expenses')
                  .orderBy('time')
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  var userExpensesData = snapshot.data.docs;
                  return userExpensesData.length != 0
                      ? ListView.builder(
                          itemCount: userExpensesData.length,
                          itemBuilder: (context, index) {
                            return Slidable(
                              key: ValueKey(index),
                              endActionPane: ActionPane(
                                extentRatio: 0.25,
                                motion: const StretchMotion(),
                                children: [
                                  //UPDATE
                                  SlidableAction(
                                    onPressed: (context) {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            FormScreen(
                                          expense: userExpensesData[index],
                                          expenseIndex: index,
                                        ),
                                      );
                                    },
                                    icon: Icons.edit,
                                  ),

                                  //DELETE
                                  SlidableAction(
                                    onPressed: (context) {
                                      databaseService.deleteExpense(
                                          userExpensesData[index].id);

                                      SnackBar(
                                        duration: const Duration(seconds: 3),
                                        content: const Text("Expense Deleted"),
                                        action: SnackBarAction(
                                            label: 'Undo',
                                            onPressed: () {
                                              setState(
                                                () {
                                                  databaseService.addExpense(
                                                      userExpense:
                                                          userExpensesData[
                                                                  index]
                                                              .id);
                                                },
                                              );
                                            }),
                                      );
                                    },
                                    icon: Icons.delete,
                                  )
                                ],
                              ),
                              child: Card(
                                margin: const EdgeInsets.all(10),
                                elevation: 6,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 20),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: 250,
                                            child: Text(
                                              userExpensesData[index]['name'],
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              softWrap: false,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: Colors
                                                      .black), // Set color to black
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              textAlign: TextAlign.end,
                                              '${userExpensesData[index]['price']} TK',
                                              style: const TextStyle(
                                                
                                                  color: Colors
                                                      .green), // Set color to green
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            formatter.format(
                                                userExpensesData[index]['time']
                                                    .toDate()),
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255,
                                                    114,
                                                    115,
                                                    114)), // Set color to green
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : const Center(child: Text("Add an expense!"));
                } else {
                  return const Center(
                    child: CircularProgressIndicator(), // Loading indicator
                  );
                }
              },
            ),
          ),
        )
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          // Show the popup screen
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) => FormScreen(),
          );
        },
        backgroundColor: const Color.fromARGB(255, 25, 25, 25),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 58,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.home)),
            Opacity(
                opacity: 0.0,
                child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons
                        .menu))), // I want this icon button to be invisible and unclickable
            IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
          ],
        ),
      ),
    );
  }
}
