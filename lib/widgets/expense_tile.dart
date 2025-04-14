import 'package:flutter/material.dart';
import 'package:mini_project/models/user.dart';
import 'package:mini_project/screens/expense_detail_page.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../providers/expense_provider.dart';
import '../db/database_helper.dart';
import '../screens/expense_form_page.dart';

class ExpenseTile extends StatelessWidget {
  final Expense expense;
  const ExpenseTile({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(expense.id.toString()),
      background: Container(
          color: Colors.green,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 20),
          child: Icon(Icons.edit, color: Colors.white)),
      secondaryBackground: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20),
          child: Icon(Icons.delete, color: Colors.white)),
      confirmDismiss: (dir) async {
        if (dir == DismissDirection.endToStart) {
          Provider.of<ExpenseProvider>(context, listen: false)
              .deleteExpense(expense.id!);
          return true;
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ExpenseFormPage(expense: expense)));
          return false;
        }
      },
      child: ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ExpenseDetailPage(expense: expense)));
        },
        title: Text(expense.name),
        subtitle: !expense.isShared
            ? Text(
                '${expense.category} - \$${expense.amount.toStringAsFixed(2)}')
            : FutureBuilder(
                future: getUserName(expense.sharedByUserId),
                builder: (context, name) => Text('Shared by ${name.data}'),
              ),
        trailing: Text('${expense.date.toLocal()}'.split(' ')[0]),
      ),
    );
  }
}

Future<String> getUserName(int? userId) async {
  if (userId == null) return 'Unknown';

  final users = await DatabaseHelper().getAllUsers();
  final user = users.firstWhere(
    (u) => u.id == userId,
    orElse: () => User(
      username: "Unknown",
      password: "lol",
    ),
  );

  return user.username == 'Unknown' ? "Unknown" : user.username;
}
