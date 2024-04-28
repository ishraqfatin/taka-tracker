import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:taka_tracker/widgets/bar_chart.dart';
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
  String jsonData = '';

  @override
  void initState() {
    super.initState();
    getChartData();
  }

  void getChartData() async {
  try {
    String fetchedData = await DatabaseService().mapUserExpenseSnapshotToChartJson();
    setState(() {
      jsonData = fetchedData;
    });
  } catch (error) {}
}


  var _barCharItems = [
    'This week',
    'This month',
    'This year',
  ];

  var _expenseListItems = [
    'Categories',
    'Food',
    'Transport',
    'Bills',
    'Movies',
  ];

  String _selectedBarChartFilter = 'This month';
  String _selectedExpenseListItem = 'Categories';

  String _getGreeting() {
    var hour = DateTime.now().hour;
    String? userName = currentUser?.email?.split('@')[0];
    if (hour < 12) {
      return 'Good morning, $userName';
    } else if (hour < 17) {
      return 'Good afternoon, $userName';
    } else {
      return 'Good evening, $userName';
    }
  }

  @override
  Widget build(BuildContext context) {
    String greeting = _getGreeting();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Taka',
              style: TextStyle(
                color: Color.fromARGB(255, 79, 211, 127),
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'Tracker',
              style: TextStyle(
                color: Color.fromARGB(255, 97, 167, 236),
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        // SizedBox(
        //   child: Row(
        //     children: [
        //       const Icon(
        //         Icons.person,
        //         size: 18,
        //       ),
        //       const SizedBox(
        //         width: 10,
        //       ),
        //       Text(
        //         'Welcome, ${currentUser?.email?.split('@')[0]}',
        //         style: const TextStyle(
        //           fontSize: 14,
        //         ),
        //       )
        //     ],
        //   ),
        // ),
        primary: true,
        backgroundColor: Color.fromARGB(255, 0, 22, 8),
        // actions: [
        //   IconButton(
        //     iconSize: 20,
        //     onPressed: () async {
        //       final auth = FirebaseAuth.instance;
        //
        //       await auth.signOut();
        //
        //       // Navigate to Sing_in page
        //       Navigator.popAndPushNamed(context, '/sign_in');
        //     },
        //     icon: const Icon(Icons.logout),
        //   )
        // ],
      ),

      //CRUD operations through List
      body: Container(
        color: Color.fromARGB(255, 169, 219, 187),
        child: Column(children: [
          Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 0, 22, 8),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
            ),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  greeting,
                  style: TextStyle(fontSize: 24.0, color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'You have spent',
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
              const Text(
                '2500 Tk',
                style: TextStyle(
                    fontSize: 40.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              // DROP DOWN MENU
              Container(
                  width: 120,
                  height: 40,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(254, 72, 89, 78),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 14.0,
                    ),
                    child: DropdownButton(
                      dropdownColor: const Color.fromARGB(254, 72, 89, 78),
                      items: _barCharItems.map((String item) {
                        return DropdownMenuItem(value: item, child: Text(item));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedBarChartFilter = value!;
                        });
                      },
                      icon: const Icon(Icons.keyboard_arrow_down),
                      value: _selectedBarChartFilter,
                      style: const TextStyle(color: Colors.white),
                      underline: Container(),
                      iconEnabledColor:
                          const Color.fromARGB(255, 255, 255, 255),
                    ),
                  )),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                height: 170,
                child: CustomBarChart(jsonData: jsonData),
              ),
              const SizedBox(
                height: 20,
              ),
            ]),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Expenses",
                  style: TextStyle(
                    color: Color.fromARGB(255, 4, 73, 3),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                  ),
                ),
                // DROP DOWN MENU
                Container(
                    width: 120,
                    height: 40,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(252, 66, 124, 86),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 14.0,
                      ),
                      child: DropdownButton(
                        dropdownColor: Color.fromARGB(252, 66, 124, 86),
                        items: _expenseListItems.map((String item) {
                          return DropdownMenuItem(
                              value: item, child: Text(item));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedExpenseListItem = value!;
                          });
                        },
                        icon: const Icon(Icons.keyboard_arrow_down),
                        value: _selectedExpenseListItem,
                        style: const TextStyle(color: Colors.white),
                        underline: Container(),
                        iconEnabledColor:
                            const Color.fromARGB(255, 255, 255, 255),
                      ),
                    )),
              ],
            ),
          ),
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
                                                onExpenseAddedOrUpdated: () {
                                                  // setState updates the chart data
                                                  setState(() {
                                                    getChartData();
                                                  });
                                                },
                                              ),
                                        );
                                      },
                                      backgroundColor: Colors.transparent,
                                      foregroundColor:
                                          Color.fromARGB(252, 66, 124, 86),
                                      icon: Icons.edit,
                                    ),

                                    //DELETE
                                    SlidableAction(
                                      onPressed: (context) {
                                        databaseService.deleteExpense(
                                            userExpensesData[index].id).then((value) {
                                              // Update the jsonData
                                              getChartData();
                                            }
                                          );

                                        SnackBar(
                                          duration: const Duration(seconds: 3),
                                          content:
                                              const Text("Expense Deleted"),
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
                                      backgroundColor: Colors.transparent,
                                      foregroundColor: Colors.red,
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
                                                  userExpensesData[index]
                                                          ['time']
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        //ADD
        onPressed: () {
          // Show the popup screen
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) => FormScreen(onExpenseAddedOrUpdated: () {setState(() {
              getChartData();
            });}),
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
