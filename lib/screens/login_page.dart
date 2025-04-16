import 'package:flutter/material.dart';
import 'package:mini_project/screens/dashboard_page.dart';
import 'package:provider/provider.dart';
import '../db/database_helper.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
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
          context, MaterialPageRoute(builder: (_) => DashboardPage()));
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
        child: Center(
          child: Column(
            spacing: 16,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/logo.png',
                height: 100,
              ),
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
                onPressed: () => _login(context),
                child: Text("Login"),
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SignupPage(),
                  ),
                ),
                child: Text("Don't have an accout? Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
