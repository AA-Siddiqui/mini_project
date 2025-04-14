import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../db/database_helper.dart';
import '../providers/user_provider.dart';
import 'dart:io';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: user == null
          ? Center(child: Text("No user logged in"))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => _pickImage(context),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: user.avatarPath != null
                          ? FileImage(File(user.avatarPath!))
                          : null,
                      child: user.avatarPath == null
                          ? Icon(Icons.person, size: 50)
                          : null,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Username: ${user.username}"),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Provider.of<UserProvider>(context, listen: false)
                          .logout();
                      Navigator.pop(context);
                    },
                    child: Text("Logout"),
                  ),
                ],
              ),
            ),
    );
  }
}
