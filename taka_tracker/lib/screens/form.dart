import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String _selectedCategory = "Food"; // Initial category value
  DateTime _selectedDate = DateTime.now(); // Initial date value

  // Function to submit the form and add the document to Firestore
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed to add document
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        FirebaseFirestore.instance.collection('users').doc(currentUser.uid).collection('expenses').add({
          'name': _nameController.text,
          'category': _selectedCategory,
          'price': double.parse(_priceController.text),
          'timestamp': Timestamp.fromDate(_selectedDate),
          'userId': currentUser.uid,
        }).then((_) {
          // Document added successfully
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Expense added successfully'),
          ));
          // Clear form fields after submission
          _nameController.clear();
          _priceController.clear();
          setState(() {
            _selectedCategory = "Food"; // Reset category value
            _selectedDate = DateTime.now(); // Reset date value
          });
        }).catchError((error) {
          // Handle error
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error adding document: $error'),
          ));
        });
      }
    }
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
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
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
              TextFormField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
              Text('Date: ${_selectedDate.toString()}'),
              ElevatedButton(
                onPressed: () {
                  showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  ).then((date) {
                    if (date != null) {
                      setState(() {
                        _selectedDate = date;
                      });
                    }
                  });
                },
                child: const Text('Select Date'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
