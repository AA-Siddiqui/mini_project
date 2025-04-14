import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../db/database_helper.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import 'profile_page.dart';
import 'signup_page.dart';

class LoginPage extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginPage({super.key});

  void _login(BuildContext context) async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    final User? user = await DatabaseHelper().getUser(username, password);

    if (user != null) {
      Provider.of<UserProvider>(context, listen: false).login(user);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => ProfilePage()));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Invalid credentials")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: "Username")),
            TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true),
            ElevatedButton(
                onPressed: () => _login(context), child: Text("Login")),
            TextButton(
                onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => SignupPage())),
                child: Text("Sign Up")),
          ],
        ),
      ),
    );
  }
}
