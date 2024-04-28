import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taka_tracker/models/expense.dart';
import 'package:taka_tracker/services/database.dart';

final formatter = DateFormat.yMd();

class FormScreen extends StatefulWidget {
  const FormScreen({super.key, this.expense, this.expenseIndex, this.onExpenseAddedOrUpdated});

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

    selectedCategory = widget.expense != null
        ? widget.expense.data()["category"].toString()
        : "";

    selectedDate = widget.expense != null
        ? widget.expense.data()["time"].toDate()
        : DateTime.now();
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
        title: const Text('Add Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
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
              DropdownButtonFormField<String>(
                value: selectedCategory.isEmpty ? "Food" : selectedCategory,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue!;
                  });
                },
                items: <String>['Food', 'Bills', 'Travel', 'Shopping']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(labelText: 'Category'),
              ),
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
                          Text(selectedDate == null
                              ? 'No date selected'
                              : formatter.format(selectedDate!)),
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

                        UserExpense userExpense = UserExpense(
                            name: nameController.text,
                            category: selectedCategory,
                            time: selectedDate,
                            price: price);

                        databaseService.addExpense(userExpense: userExpense);

                        Navigator.pop(context);
                        widget.onExpenseAddedOrUpdated!();
                      },
                      child: const Text('Submit'),
                    )
                    //UPDATE
                  : ElevatedButton(
                      onPressed: () {
                        int price = int.tryParse(priceController.text) ?? 0;

                        UserExpense userExpense = UserExpense(
                            name: nameController.text,
                            category: selectedCategory,
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
