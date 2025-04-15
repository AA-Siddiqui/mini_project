import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    final theme = Theme.of(context);

    return Dismissible(
      key: Key(expense.id.toString()),
      background: Container(
        color: Colors.green,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (dir) async {
        if (dir == DismissDirection.endToStart) {
          Provider.of<ExpenseProvider>(context, listen: false)
              .deleteExpense(expense.id!);
          return true;
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ExpenseFormPage(expense: expense)),
          );
          return false;
        }
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: theme.colorScheme.secondaryContainer,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 0,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ExpenseDetailPage(expense: expense),
              ),
            );
          },
          title: Text(
            expense.name,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          subtitle: expense.isShared
              ? FutureBuilder(
                  future: getUserName(expense.sharedByUserId),
                  builder: (context, name) => Text(
                    'Shared by ${name.data ?? "..."}',
                    style: theme.textTheme.bodySmall,
                  ),
                )
              : Text(
                  '${expense.category} - \$${expense.amount.toStringAsFixed(2)}',
                  style: theme.textTheme.bodySmall,
                ),
          trailing: Text(
            DateFormat('MMMM d, y').format(
                DateTime.parse('${expense.date.toLocal()}'.split(' ')[0])),
            style: theme.textTheme.labelSmall?.copyWith(color: theme.hintColor),
          ),
          leading: expense.imagePaths.isNotEmpty
              ? Image.file(
                  File(
                    expense.imagePaths[0],
                  ),
                  width: 50,
                  height: 50,
                )
              : Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(border: Border.all()),
                  child: Icon(Icons.warning),
                ),
        ),
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
