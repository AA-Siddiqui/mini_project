import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Details'),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildInfoCard('Name', e.name, theme),
            _buildInfoCard('Category', e.category, theme),
            _buildInfoCard('Amount', '\$${e.amount.toStringAsFixed(2)}', theme),
            _buildInfoCard(
                'Date',
                DateFormat('MMMM d, y').format(
                    DateTime.parse('${e.date.toLocal()}'.split(' ')[0])),
                theme),
            if (e.imagePaths.isNotEmpty) ...[
              Card(
                elevation: 1,
                color: theme.colorScheme.secondaryContainer,
                margin: const EdgeInsets.symmetric(vertical: 2),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Receipts",
                        style: theme.textTheme.labelLarge,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: e.imagePaths
                            .map(
                              (path) => GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => Scaffold(
                                      backgroundColor: Colors.black,
                                      appBar: AppBar(
                                        backgroundColor: Colors.black,
                                        iconTheme:
                                            IconThemeData(color: Colors.white),
                                      ),
                                      body: Center(
                                        child: Hero(
                                          tag: path,
                                          child: Image.file(
                                            File(path),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Hero(
                                    tag: path,
                                    child: Image.file(
                                      File(path),
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            if (e.sharedWith.isNotEmpty) ...[
              Card(
                elevation: 1,
                color: theme.colorScheme.secondaryContainer,
                margin: const EdgeInsets.symmetric(vertical: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Shared With",
                        style: theme.textTheme.labelLarge,
                      ),
                      DataTable(
                        columns: [
                          DataColumn(label: Text("Person")),
                          DataColumn(label: Text("%age")),
                        ],
                        rows: e.sharedWith.entries
                            .map(
                              (item) => DataRow(
                                cells: [
                                  DataCell(
                                      Text(userIdToName[item.key] ?? "Person")),
                                  DataCell(Text(
                                      '${item.value.toStringAsFixed(0)}%')),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, ThemeData theme) {
    return Card(
      elevation: 1,
      color: theme.colorScheme.secondaryContainer,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        title: Text(title, style: theme.textTheme.labelLarge),
        subtitle: Text(value, style: theme.textTheme.bodyMedium),
      ),
    );
  }
}
