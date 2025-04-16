import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/expense.dart';

class ExpenseProvider extends ChangeNotifier {
  List<Expense> _expenses = [];
  int currentUserId = -1;

  List<Expense> get expenses => _expenses;

  Future<void> loadExpenses(int userId) async {
    if (userId == -1) {
      _expenses.clear();
    } else {
      currentUserId = userId;
      _expenses = await DatabaseHelper().getAllExpenses(userId);
    }
    notifyListeners();
  }

  Future<void> addExpense(Expense exp) async {
    await DatabaseHelper().insertExpense(exp);
    await loadExpenses(currentUserId);
  }

  Future<void> updateExpense(Expense exp) async {
    await DatabaseHelper().updateExpense(exp);
    await loadExpenses(currentUserId);
  }

  Future<void> deleteExpense(int id) async {
    await DatabaseHelper().deleteExpense(id);
    await loadExpenses(currentUserId);
  }
}
