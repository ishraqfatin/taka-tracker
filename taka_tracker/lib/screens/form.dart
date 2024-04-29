import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taka_tracker/models/expense.dart';
import 'package:taka_tracker/services/database.dart';
import 'package:taka_tracker/services/utils/validators.dart';

final formatter = DateFormat.yMd();

class FormScreen extends StatefulWidget {
  const FormScreen(
      {super.key,
      this.expense,
      this.expenseIndex,
      this.onExpenseAddedOrUpdated});

  final expense;
  final expenseIndex;
  final Function()? onExpenseAddedOrUpdated;

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final DatabaseService databaseService = DatabaseService();
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  late String selectedCategory;
  Category _selectedCategory = Category.food;

  late DateTime? selectedDate;

  late String docData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text =
        widget.expense != null ? widget.expense.data()['name'] : "";

    priceController.text =
        widget.expense != null ? widget.expense.data()["price"].toString() : "";

    _selectedCategory = widget.expense != null
        ? Category.values.firstWhere((element) =>
            element.toString() ==
            'Category.${widget.expense.data()["category"].toString()}')
        : Category.food;

    selectedDate =
        widget.expense != null ? widget.expense.data()["time"].toDate() : null;
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);

    //Built-in function
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );

    setState(() {
      selectedDate = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Add Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 12,
              ),
              DropdownButtonFormField(
                value: _selectedCategory,
                items: Category.values
                    .map(
                      (el) => DropdownMenuItem(
                        value: el,
                        child: Text(
                          el.name.toUpperCase(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(
                    () {
                      _selectedCategory = value;
                    },
                  );
                },
                validator: (value) {
                  if (value == null) {
                    return 'Category required!';
                  }
                  return null;
                },
              ),
              // DropdownButtonFormField<String>(
              //   value: selectedCategory.isEmpty ? "Food" : selectedCategory,
              //   onChanged: (String? newValue) {
              //     setState(() {
              //       selectedCategory = newValue!;
              //     });
              //   },
              //   items: <String>['Food', 'Bills', 'Travel', 'Shopping']
              //       .map<DropdownMenuItem<String>>((String value) {
              //     return DropdownMenuItem<String>(
              //       value: value,
              //       child: Text(value),
              //     );
              //   }).toList(),
              //   decoration: const InputDecoration(labelText: 'Category'),
              // ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: priceController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Price'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: const ButtonStyle(
                          padding: MaterialStatePropertyAll(
                            EdgeInsets.only(
                              left: 20,
                            ),
                          ),
                          shape: MaterialStatePropertyAll(
                              ContinuousRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))))),
                      onPressed: _presentDatePicker,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            selectedDate == null
                                ? 'No date selected!'
                                : formatter.format(selectedDate!),
                            style: const TextStyle(
                              color: Color.fromARGB(255, 169, 17, 6),
                            ),
                          ),
                          IconButton(
                            onPressed: _presentDatePicker,
                            icon: const Icon(Icons.calendar_month_rounded),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              widget.expense == null
                  //ADD
                  ? ElevatedButton(
                      onPressed: () {
                        int price = int.tryParse(priceController.text) ?? 0;

                        if (ValidatorClass()
                                .validateEmptyField(nameController.text) !=
                            null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor:
                                  const Color.fromARGB(255, 144, 4, 4),
                              showCloseIcon: true,
                              content: const Text('Name required!'),
                              width: 280.0, // Width of the SnackBar.
                              padding: const EdgeInsets.symmetric(
                                horizontal:
                                    8.0, // Inner padding for SnackBar content.
                              ),
                              behavior: SnackBarBehavior.floating,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          );
                          return;
                        }
                        if (ValidatorClass()
                                .validateEmptyField(priceController.text) !=
                            null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor:
                                  const Color.fromARGB(255, 144, 4, 4),
                              showCloseIcon: true,
                              content: const Text('Price required!'),
                              width: 280.0, // Width of the SnackBar.
                              padding: const EdgeInsets.symmetric(
                                horizontal:
                                    8.0, // Inner padding for SnackBar content.
                              ),
                              behavior: SnackBarBehavior.floating,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          );
                          return;
                        }

                        if (selectedDate != null) {
                          UserExpense userExpense = UserExpense(
                              name: nameController.text,
                              category: _selectedCategory.name,
                              time: selectedDate,
                              price: price);

                          databaseService.addExpense(userExpense: userExpense);

                          Navigator.pop(context);
                          widget.onExpenseAddedOrUpdated!();
                        } else {}
                      },
                      child: const Text('Submit'),
                    )
                  //UPDATE
                  : ElevatedButton(
                      onPressed: () {
                        int price = int.tryParse(priceController.text) ?? 0;

                        UserExpense userExpense = UserExpense(
                            name: nameController.text,
                            category: _selectedCategory.name,
                            time: selectedDate,
                            price: price);

                        databaseService.updateExpense(
                            userExpense: userExpense,
                            userExpenseId: widget.expense.id);

                        Navigator.pop(context);
                        widget.onExpenseAddedOrUpdated!();
                      },
                      child: const Text('Update'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
