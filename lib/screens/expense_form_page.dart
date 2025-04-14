import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mini_project/providers/user_provider.dart';
import '../models/expense.dart';
import '../providers/expense_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/share_expense_dialog.dart';

class ExpenseFormPage extends StatefulWidget {
  final Expense? expense;
  const ExpenseFormPage({super.key, this.expense});

  @override
  State<ExpenseFormPage> createState() => _ExpenseFormPageState();
}

class _ExpenseFormPageState extends State<ExpenseFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _category = 'Food';
  double _amount = 0;
  DateTime _date = DateTime.now();
  List<String> _images = [];
  Map<int, double> _sharedWith = {};

  final categories = ['Food', 'Travel', 'Bills', 'Other'];

  void _pickImages() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage();
    setState(() {
      _images.addAll(picked.map((e) => e.path));
    });
  }

  void _openShareDialog() async {
    final result = await showDialog<Map<int, double>>(
      context: context,
      builder: (_) => ShareExpenseDialog(),
    );
    if (result != null) {
      final total = result.values.fold(0.0, (sum, val) => sum + val);
      if (total != 100.0) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Percentages must add up to 100')));
        return;
      }
      setState(() {
        _sharedWith = result;
      });
    }
  }

  void _saveExpense() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final exp = Expense(
        id: widget.expense?.id,
        userId: Provider.of<UserProvider>(context, listen: false).user!.id!,
        name: _name,
        category: _category,
        amount: _amount,
        date: _date,
        imagePaths: _images,
        sharedWith: _sharedWith,
      );

      final provider = Provider.of<ExpenseProvider>(context, listen: false);
      if (widget.expense == null) {
        provider.addExpense(exp);
      } else {
        provider.updateExpense(exp);
      }

      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    if (widget.expense != null) {
      _name = widget.expense!.name;
      _category = widget.expense!.category;
      _amount = widget.expense!.amount;
      _date = widget.expense!.date;
      _images = widget.expense!.imagePaths;
      _sharedWith = widget.expense!.sharedWith;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.expense == null ? 'Add Expense' : 'Edit Expense')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                  initialValue: _name,
                  decoration: InputDecoration(labelText: 'Name'),
                  onSaved: (v) => _name = v!),
              DropdownButtonFormField(
                  value: _category,
                  items: categories
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => _category = val!),
              TextFormField(
                  initialValue: _amount.toString(),
                  decoration: InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                  onSaved: (v) => _amount = double.parse(v!)),
              ListTile(
                  title: Text('Date: ${_date.toLocal()}'.split(' ')[0]),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                        context: context,
                        initialDate: _date,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now());
                    if (picked != null) setState(() => _date = picked);
                  }),
              ElevatedButton(onPressed: _pickImages, child: Text('Add Images')),
              Wrap(
                  children: _images
                      .map((e) => Padding(
                          padding: EdgeInsets.all(4),
                          child: Image.file(File(e), height: 50)))
                      .toList()),
              ElevatedButton(
                  onPressed: _openShareDialog, child: Text('Share Expense')),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _saveExpense, child: Text('Save')),
            ],
          ),
        ),
      ),
    );
  }
}
