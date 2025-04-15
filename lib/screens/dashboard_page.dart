import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mini_project/db/database_helper.dart';
import 'package:mini_project/providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../widgets/expense_tile.dart';
import 'expense_form_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.updateAvatar(image.path);
      await DatabaseHelper().updateUser(userProvider.user!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExpenseProvider>(context);
    final user = Provider.of<UserProvider>(context).user;

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Expenses'),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 1,
      ),
      body: FutureBuilder(
        future: provider.loadExpenses(user!.id!),
        builder: (context, snapshot) {
          if (provider.expenses.isEmpty) {
            return Center(
              child: Text(
                'No expenses yet!',
                style: theme.textTheme.bodyLarge,
              ),
            );
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 36,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  spacing: 16,
                  children: [
                    GestureDetector(
                      onTap: () => _pickImage(context),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: user.avatarPath != null
                            ? FileImage(File(user.avatarPath!))
                            : null,
                        child: user.avatarPath == null
                            ? Icon(Icons.person, size: 40)
                            : null,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello,",
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        ),
                        Text(
                          user.username,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        "My Expenses",
                        style: theme.textTheme.labelLarge,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        itemCount: provider.expenses.length,
                        itemBuilder: (context, i) => ExpenseTile(
                          expense: provider.expenses[i],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ExpenseFormPage()),
        ),
        backgroundColor: theme.colorScheme.secondary,
        child: Icon(Icons.add, color: theme.colorScheme.onSecondary),
      ),
    );
  }
}
