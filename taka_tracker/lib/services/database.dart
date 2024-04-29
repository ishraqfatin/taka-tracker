import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taka_tracker/models/expense.dart';
import 'dart:convert';

class DatabaseService {
  final auth = FirebaseAuth.instance;
  final firebase = FirebaseFirestore.instance;
  String? userId = FirebaseAuth.instance.currentUser?.uid;

  Future<void> addExpense({required UserExpense userExpense}) async {
    // String? userId = auth.currentUser?.uid;
    try {
      await firebase
          .collection('users')
          .doc(userId)
          .collection('expenses')
          .add(userExpense.toMap());
    } catch (error) {
      print(error);
    }
  }

  Future<UserExpense> getExpenseById(String userExpenseId) async {
    // String? userId = FirebaseAuth.instance.currentUser?.uid;
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
    // String? userId = auth.currentUser?.uid;

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
    // String? userId = auth.currentUser?.uid;

    try {
      await firebase
          .collection('users')
          .doc(userId)
          .collection('expenses')
          .doc(userExpenseId)
          .delete();
    } catch (error) {}
  }

  Future<String> mapUserExpenseSnapshotToChartJson({
    required String? timeRange,
  }) async {
    // String? userId = auth.currentUser?.uid;

    final expensesCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('expenses');

    DateTime start;
    DateTime end;
    double sum = 0;

    if (timeRange == 'week') {
      final now = DateTime.now();
      final sundayStart = now.subtract(Duration(days: now.weekday));
      start = DateTime(sundayStart.year, sundayStart.month, sundayStart.day);
      end = start.add(const Duration(days: 7));
    } else if (timeRange == 'year') {
      final now = DateTime.now();
      start = DateTime(now.year, 1, 1);
      end = DateTime(now.year + 1, 1, 1);
    } else if (timeRange == 'month') {
      final now = DateTime.now();
      start = DateTime(now.year, now.month, 1);
      end = DateTime(now.year, now.month + 1, 1);
    } else {
      start = DateTime.now();
      end = DateTime.now();
    }

// Query expenses within the specified time range
    final querySnapshot = await expensesCollection
        .where('time', isGreaterThanOrEqualTo: start)
        .where('time', isLessThan: end)
        .get();

    // QuerySnapshot snapshot = await firebase
    //     .collection('users')
    //     .doc(userId)
    //     .collection('expenses')
    //     .get();

    if (querySnapshot.docs.isNotEmpty) {
      List<Map<String, dynamic>> dataList = [];

      for (var doc in querySnapshot.docs) {
        dataList.add({
          "category": doc['category'],
          "price": doc['price'],
        });
      }

      for (var doc in querySnapshot.docs) {
        sum += doc['price'];
      }

      Map<String, dynamic> jsonData = {
        "data": dataList,
        "totalAmount": sum
      };
      return json.encode(jsonData);
    }
    return '';
  }
}
