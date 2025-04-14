import 'dart:io';
import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../db/database_helper.dart';
import '../models/user.dart';

class ExpenseDetailPage extends StatefulWidget {
  final Expense expense;
  const ExpenseDetailPage({super.key, required this.expense});

  @override
  State<ExpenseDetailPage> createState() => _ExpenseDetailPageState();
}

class _ExpenseDetailPageState extends State<ExpenseDetailPage> {
  Map<int, String> userIdToName = {};

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final List<User> users = await DatabaseHelper().getAllUsers();
    setState(() {
      userIdToName = {for (var u in users) u.id!: u.username};
    });
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.expense;

    return Scaffold(
      appBar: AppBar(title: Text('Expense Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            ListTile(
              title: Text('Name'),
              subtitle: Text(e.name),
            ),
            ListTile(
              title: Text('Category'),
              subtitle: Text(e.category),
            ),
            ListTile(
              title: Text('Amount'),
              subtitle: Text('\$${e.amount.toStringAsFixed(2)}'),
            ),
            ListTile(
              title: Text('Date'),
              subtitle: Text('${e.date.toLocal()}'.split(' ')[0]),
            ),
            if (e.imagePaths.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text('Images',
                    style: Theme.of(context).textTheme.titleMedium),
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: e.imagePaths
                    .map((path) => Image.file(File(path), height: 100))
                    .toList(),
              ),
              Divider(),
            ],
            if (e.sharedWith.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text('Shared With',
                    style: Theme.of(context).textTheme.titleMedium),
              ),
              ...e.sharedWith.entries.map((entry) {
                final name = userIdToName[entry.key] ?? 'User ${entry.key}';
                return ListTile(
                  title: Text(name),
                  trailing: Text('${entry.value.toStringAsFixed(0)}%'),
                );
              })
            ],
          ],
        ),
      ),
    );
  }
}
