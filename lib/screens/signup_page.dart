import 'package:flutter/material.dart';
import 'package:mini_project/providers/user_provider.dart';
import 'package:mini_project/screens/dashboard_page.dart';
import 'package:provider/provider.dart';
import '../db/database_helper.dart';
import '../models/user.dart';

class SignupPage extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  SignupPage({super.key});

  void _signup(BuildContext context) async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    final newUser = User(username: username, password: password);
    await DatabaseHelper().insertUser(newUser);
    final User? user = await DatabaseHelper().getUser(username, password);

    if (user != null) {
      Provider.of<UserProvider>(context, listen: false).login(user);
      Navigator.popUntil(context, (route) => false);
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => DashboardPage()));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Something went wrong!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: "Username"),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () => _signup(context),
              child: Text("Create Account"),
            ),
          ],
        ),
      ),
    );
  }
}
