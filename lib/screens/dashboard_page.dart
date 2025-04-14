import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../widgets/expense_tile.dart';
import 'expense_form_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExpenseProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Expenses')),
      body: FutureBuilder(
        future: provider.loadExpenses(),
        builder: (context, snapshot) => ListView.builder(
          itemCount: provider.expenses.length,
          itemBuilder: (context, i) =>
              ExpenseTile(expense: provider.expenses[i]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => ExpenseFormPage())),
        child: Icon(Icons.add),
      ),
    );
  }
}
