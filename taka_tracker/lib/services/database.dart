
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taka_tracker/models/expense.dart';

class DatabaseService {
  final auth = FirebaseAuth.instance;
  final firebase = FirebaseFirestore.instance;

  Future<void> addExpense({required UserExpense userExpense}) async {
    String? userId = auth.currentUser?.uid;
    {
      await firebase
          .collection('users')
          .doc(userId)
          .collection('expenses')
          .add(userExpense.toMap());
    }
  }

  Future<UserExpense> getExpenseById(String userExpenseId) async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    DocumentSnapshot expenseSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .doc(userExpenseId)
        .get();

    Map<String, dynamic> jsonData =
        expenseSnapshot.data() as Map<String, dynamic>;

    UserExpense userExpense = UserExpense.fromMap(jsonData);

    return userExpense;
  }

  Future<void> updateExpense(
      {required UserExpense userExpense, required userExpenseId}) async {
    String? userId = auth.currentUser?.uid;

    try {
      await firebase
          .collection('users')
          .doc(userId)
          .collection('expenses')
          .doc(userExpenseId)
          .update(userExpense.toMap())
          .then((value) => value);
    } catch (error) {}

  }

  Future<void> deleteExpense(String userExpenseId) async {
    String? userId = auth.currentUser?.uid;
    {
      await firebase
          .collection('users')
          .doc(userId)
          .collection('expenses')
          .doc(userExpenseId)
          .delete();
    }
  }
}
