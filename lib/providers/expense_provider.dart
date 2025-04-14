import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/expense.dart';

class ExpenseProvider extends ChangeNotifier {
  List<Expense> _expenses = [];

  List<Expense> get expenses => _expenses;

  Future<void> loadExpenses() async {
    _expenses = await DatabaseHelper().getAllExpenses();
    notifyListeners();
  }

  Future<void> addExpense(Expense exp) async {
    await DatabaseHelper().insertExpense(exp);
    await loadExpenses();
  }

  Future<void> updateExpense(Expense exp) async {
    await DatabaseHelper().updateExpense(exp);
    await loadExpenses();
  }

  Future<void> deleteExpense(int id) async {
    await DatabaseHelper().deleteExpense(id);
    await loadExpenses();
  }
}
