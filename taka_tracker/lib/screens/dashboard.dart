import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:taka_tracker/models/expense.dart';
import 'package:taka_tracker/widgets/bar_chart.dart';
import 'package:taka_tracker/services/database.dart';
import 'form.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:skeletonizer/skeletonizer.dart';

final formatter = DateFormat.yMd();

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<StatefulWidget> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<StatefulWidget> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final databaseService = DatabaseService();
  final firebase = FirebaseFirestore.instance;
  String _selectedBarChartFilter = 'week';
  String _selectedExpenseListCategory = 'categories';
  String _selectedCurrency = 'bdt';

  String jsonData = '';

  @override
  void initState() {
    super.initState();
    getChartData();
    getConvertedCurrency(1);
  }

  Query buildExpenseQuery(String selectedCategory) {
    Query<Map<String, dynamic>> query = firebase
        .collection('users')
        .doc(currentUser!.uid)
        .collection('expenses');

    if (selectedCategory != 'categories') {
      // Filter by category if a category is selected
      query = query.where('category', isEqualTo: _selectedExpenseListCategory);
    } else {
      // Order by time (you can adjust this as needed)
      query = query.orderBy('time', descending: true);
    }

    return query;
  }

  void getChartData() async {
    try {
      String fetchedData = await DatabaseService()
          .mapUserExpenseSnapshotToChartJson(
              timeRange: _selectedBarChartFilter);

      setState(
        () {
          jsonData = fetchedData;
        },
      );
    } catch (error) {
      print(error);
    }
  }

  final _barCharItems = [
    'week',
    'month',
    'year',
  ];

  final _expenseListItems = [
    'categories',
    'food',
    'travel',
    'bills',
    'shopping',
  ];

  final _currencyListItems = [
    'bdt',
    'usd',
    'eur',
    'gbp',
    'cad',
  ];

  Future<String> getConvertedCurrency(int inputCurrency) async {
    if (_selectedCurrency == 'bdt') {
      return '$inputCurrency ৳';
    }
    // API endpoint for currency conversion
    String apiUrl = 'https://api.exchangerate-api.com/v4/latest/BDT';

    // Make API request to get currency exchange rates
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // Parse response body
      Map<String, dynamic> data = json.decode(response.body);

      // Get conversion rate for selected currency
      double conversionRate = _selectedCurrency == 'usd'
          ? data['rates']['USD']
          : _selectedCurrency == 'cad'
              ? data['rates']['CAD']
              : _selectedCurrency == 'gbp'
                  ? data['rates']['GBP']
                  : _selectedCurrency == 'eur'
                      ? data['rates']['EUR']
                      : 1.0; // Default to 1:1 conversion if selected currency is not supported

      // Convert input currency to selected currency
      double convertedValue = inputCurrency * conversionRate;

      String formattedValue = convertedValue.toStringAsFixed(2);

      // currency symbol
      String currencySymbol = '';

      if (_selectedCurrency == 'usd' || _selectedCurrency == 'cad') {
        currencySymbol = '\$ ';
      } else if (_selectedCurrency == 'gbp') {
        currencySymbol = '£ ';
      } else if (_selectedCurrency == 'eur') {
        currencySymbol = '€ ';
      }

      return currencySymbol + formattedValue;
    } else {
      // If API request fails, return an empty string
      return '';
    }
  }

  String _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning, ';
    } else if (hour < 17) {
      return 'Good afternoon, ';
    } else {
      return 'Good evening, ';
    }
  }

  Category getCategoryFromString(String categoryString) {
    try {
      return Category.values.firstWhere(
        (e) => e.toString() == 'Category.$categoryString',
      );
    } catch (_) {
      return Category.food;
    }
  }

  @override
  Widget build(BuildContext context) {
    String greeting = _getGreeting();

    return Scaffold(
      backgroundColor: const Color.fromARGB(170, 198, 227, 216),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              greeting,
              style: const TextStyle(fontSize: 20.0, color: Colors.white),
            ),
            Text(
              currentUser!.displayName.toString(),
              maxLines: 1,
              overflow: TextOverflow.fade,
              style: const TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        primary: true,
        backgroundColor: const Color.fromARGB(255, 17, 25, 19),
      ),

      //CRUD operations through List
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 17, 25, 19),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
          ),
          child: Column(children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        const Text(
                          'You have spent',
                          style: TextStyle(fontSize: 16.0, color: Colors.white),
                        ),
                        Text(
                          jsonData != ''
                              ? jsonDecode(jsonData)['totalAmount']
                                      .toStringAsFixed(0) +
                                  ' ৳'
                              : "NA",
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          style: const TextStyle(
                            fontSize: 32.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const VerticalDivider(
                      thickness: 3,
                      indent: 8,
                      endIndent: 8,
                      color: Color.fromARGB(255, 38, 75, 54),
                    ),

                    // DROP DOWN MENU
                    Container(
                      width: 120,
                      height: 40,
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(254, 72, 89, 78),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 14.0,
                        ),
                        child: DropdownButton(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          dropdownColor: const Color.fromARGB(254, 72, 89, 78),
                          items: _barCharItems.map((String item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text("This " + item),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedBarChartFilter = value!;
                              getChartData();
                            });
                          },
                          icon: const Icon(Icons.keyboard_arrow_down),
                          value: _selectedBarChartFilter,
                          style: const TextStyle(color: Colors.white),
                          underline: Container(),
                          iconEnabledColor:
                              const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 70,
            ),
            SizedBox(
              height: 220,
              child: jsonData != ""
                  ? CustomBarChart(
                      jsonData: jsonData,
                    )
                  : const Column(
                      children: [
                        Text(
                          "Nothing to show for now :'(",
                          style: TextStyle(
                            color: Color.fromARGB(255, 106, 171, 123),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Icon(
                          Icons.not_interested_sharp,
                          color: Color.fromARGB(255, 106, 171, 123),
                        )
                      ],
                    ),
            )
          ]),
        ),
        DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.4,
            maxChildSize: 0.8,
            builder: (context, scrollController) => ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)),
                  child: Container(
                    color: const Color.fromARGB(
                      255,
                      198,
                      227,
                      216,
                    ), // EITA hocche draggable container er bg color
                    child: ListView(
                      controller: scrollController,
                      children: <Widget>[expenseListDrawer()],
                    ),
                  ),
                ))
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        //ADD
        onPressed: () {
          // Show the popup screen
          showModalBottomSheet(
            scrollControlDisabledMaxHeightRatio: 0.8,
            enableDrag: true,
            showDragHandle: false,
            elevation: 10,
            context: context,
            builder: (BuildContext context) =>
                FormScreen(onExpenseAddedOrUpdated: () {
              setState(() {
                getChartData();
              });
            }),
          );
        },
        backgroundColor: const Color.fromARGB(255, 25, 25, 25),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
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
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Singing out?'),
                  content: const Text('Are you sure you want to leave?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('No'),
                    ),
                    TextButton(
                      onPressed: () async {
                        final auth = FirebaseAuth.instance;

                        await auth.signOut();

                        // Navigate to Sign_in page
                        Navigator.popAndPushNamed(context, '/sign_in');
                      },
                      child: const Text(
                        'YES',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
              icon: const Icon(Icons.logout),
              color: const Color.fromARGB(255, 36, 46, 41),
            )
          ],
        ),
      ),
    );
  }

  Widget expenseListDrawer() {
    return Column(
      children: [
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
              Row(
                children: [
// CATEGORIES DROP DOWN MENU
                  Container(
                      width: 120,
                      height: 40,
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(251, 23, 65, 46),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 14.0,
                        ),
                        // Filter Expense List
                        child: DropdownButton(
                          dropdownColor: const Color.fromARGB(251, 23, 65, 46),
                          items: _expenseListItems.map((String item) {
                            return DropdownMenuItem(
                                value: item, child: Text(item.toUpperCase()));
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedExpenseListCategory = value!;
                            });
                          },
                          icon: const Icon(Icons.keyboard_arrow_down),
                          value: _selectedExpenseListCategory,
                          style: const TextStyle(color: Colors.white),
                          underline: Container(),
                          iconEnabledColor:
                              const Color.fromARGB(255, 255, 255, 255),
                        ),
                      )),
                  const SizedBox(
                    width: 6,
                  ),
                  // CURRENCY DROPDOWN
                  Container(
                      width: 70,
                      height: 40,
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(251, 23, 65, 46),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 14.0,
                        ),
                        // Filter Expense List
                        child: DropdownButton(
                          dropdownColor: const Color.fromARGB(251, 23, 65, 46),
                          items: _currencyListItems.map((String item) {
                            return DropdownMenuItem(
                                value: item, child: Text(item.toUpperCase()));
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCurrency = value!;
                            });
                          },
                          icon: const Icon(Icons.keyboard_arrow_down),
                          value: _selectedCurrency,
                          style: const TextStyle(color: Colors.white),
                          underline: Container(),
                          iconEnabledColor:
                              const Color.fromARGB(255, 255, 255, 255),
                        ),
                      )),
                ],
              ),
            ],
          ),
        ),
        StreamBuilder(
          stream: buildExpenseQuery(_selectedExpenseListCategory).snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              var userExpensesData = snapshot.data.docs;
              return userExpensesData.length != 0
                  ? ListView.builder(
                      shrinkWrap: true, // ! EITA ONEK JORURI BAKKO
                      physics:
                          const NeverScrollableScrollPhysics(), // ! EITAO ONEK JORURI
                      itemCount: userExpensesData.length,
                      itemBuilder: (context, index) {
                        return Slidable(
                          key: ValueKey(index),
                          endActionPane: ActionPane(
                            // extentRatio: 0.25,
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
                                    const Color.fromARGB(252, 66, 124, 86),
                                icon: Icons.edit,
                              ),

                              //DELETE
                              SlidableAction(
                                onPressed: (context) {
                                  UserExpense userExpense = UserExpense(
                                    name: userExpensesData[index]['name'],
                                    category: userExpensesData[index]
                                        ['category'],
                                    time: userExpensesData[index]['time']
                                        .toDate(),
                                    price: userExpensesData[index]['price'],
                                  );

                                  databaseService
                                      .deleteExpense(userExpensesData[index].id)
                                      .then((value) {
                                    // Update the jsonData
                                    getChartData();
                                  });

                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars(); // removes existing snackbars

                                  // Show Undo Snackbar
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor:
                                          const Color.fromARGB(255, 21, 21, 21),
                                      duration: const Duration(seconds: 5),
                                      content: const Text(
                                        "Expense Deleted",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      width: 300.0, // Width of the SnackBar.
                                      padding: const EdgeInsets.symmetric(
                                        horizontal:
                                            15.0, // Inner padding for SnackBar content.
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      action: SnackBarAction(
                                          textColor:
                                              Colors.lightGreenAccent[400],
                                          label: 'Undo',
                                          onPressed: () {
                                            setState(
                                              () {
                                                databaseService.addExpense(
                                                    userExpense: userExpense);

                                                // Update the jsonData
                                                getChartData();
                                              },
                                            );
                                          }),
                                    ),
                                  );
                                },
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.red,
                                icon: Icons.delete,
                              )
                            ],
                          ),
                          // EXPENSE CARD
                          child: Card(
                            margin: const EdgeInsets.all(10),
                            elevation: 20,
                            color: const Color.fromARGB(255, 36, 46, 41),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 12),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(
                                        categoryIcons[getCategoryFromString(
                                          userExpensesData[index]['category']
                                              .toString(),
                                        )],
                                        // size: 40,
                                        color: const Color.fromARGB(
                                            255, 216, 216, 216),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      SizedBox(
                                        width: 210,
                                        child: Text(
                                          userExpensesData[index]['name'],
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          softWrap: false,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Color.fromARGB(
                                                255, 216, 216, 216),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            // Handle Future String for the currency converter
                                            FutureBuilder<String>(
                                              future: getConvertedCurrency(
                                                  userExpensesData[index]
                                                      ['price']),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const Text(
                                                    'Loading...',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                      color: Color.fromARGB(
                                                        255,
                                                        198,
                                                        227,
                                                        216,
                                                      ),
                                                    ),
                                                  ); // Show loading indicator while fetching data
                                                } else if (snapshot.hasError) {
                                                  return Text(
                                                      'Error: ${snapshot.error}');
                                                } else {
                                                  String convertedCurrency =
                                                      snapshot.data ??
                                                          ''; // Get converted currency value
                                                  return Text(
                                                    convertedCurrency, // Display converted currency value
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                      color: Color.fromARGB(
                                                        255,
                                                        198,
                                                        227,
                                                        216,
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                            Text(
                                              formatter.format(
                                                  userExpensesData[index]
                                                          ['time']
                                                      .toDate()),
                                              style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 232, 232, 232)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
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
        )
      ],
    );
  }
}
