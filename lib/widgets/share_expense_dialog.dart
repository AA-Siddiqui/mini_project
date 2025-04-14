import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/user.dart';

class ShareExpenseDialog extends StatefulWidget {
  const ShareExpenseDialog({super.key});

  @override
  _ShareExpenseDialogState createState() => _ShareExpenseDialogState();
}

class _ShareExpenseDialogState extends State<ShareExpenseDialog> {
  List<User> users = [];
  Map<int, double> shared = {};

  @override
  void initState() {
    super.initState();
    DatabaseHelper().getAllUsers().then((list) => setState(() => users = list));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Share Expense'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: users.map((user) {
            return ListTile(
              title: Text(user.username),
              trailing: SizedBox(
                width: 60,
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(suffixText: '%'),
                  onChanged: (val) {
                    final parsed = double.tryParse(val);
                    if (parsed != null) {
                      shared[user.id!] = parsed;
                    } else {
                      shared.remove(user.id);
                    }
                  },
                ),
              ),
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text('Cancel')),
        ElevatedButton(
            onPressed: () => Navigator.pop(context, shared), child: Text('OK')),
      ],
    );
  }
}
