import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/user.dart';

class ShareExpenseDialog extends StatefulWidget {
  const ShareExpenseDialog({super.key});

  @override
  _ShareExpenseDialogState createState() => _ShareExpenseDialogState();
}

class _ShareExpenseDialogState extends State<ShareExpenseDialog> {
  List<User> allUsers = [];
  Map<int, double> shared = {};
  User? selectedUser;
  final _percentageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    DatabaseHelper()
        .getAllUsers()
        .then((users) => setState(() => allUsers = users));
  }

  void _addShare() {
    if (selectedUser != null && _percentageController.text.isNotEmpty) {
      final percent = double.tryParse(_percentageController.text);
      if (percent != null && percent > 0) {
        setState(() {
          shared[selectedUser!.id!] = percent;
        });
        _percentageController.clear();
        selectedUser = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Share Expense'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<User>(
                  hint: Text('Select user'),
                  value: selectedUser,
                  items: allUsers
                      .map((u) =>
                          DropdownMenuItem(value: u, child: Text(u.username)))
                      .toList(),
                  onChanged: (user) => setState(() => selectedUser = user),
                ),
              ),
              SizedBox(width: 10),
              SizedBox(
                width: 60,
                child: TextField(
                  controller: _percentageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: '%'),
                ),
              ),
              IconButton(icon: Icon(Icons.add), onPressed: _addShare),
            ],
          ),
          Divider(),
          ...shared.entries.map((entry) {
            final user = allUsers.firstWhere((u) => u.id == entry.key,
                orElse: () => User(username: 'Unknown', password: ''));
            return ListTile(
              title: Text(user.username),
              trailing: Text('${entry.value.toStringAsFixed(0)}%'),
            );
          }),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text('Cancel')),
        ElevatedButton(
            onPressed: () => Navigator.pop(context, shared),
            child: Text('Done')),
      ],
    );
  }
}
