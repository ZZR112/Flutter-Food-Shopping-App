import 'package:flutter/material.dart';

import 'package:grub_go/pages/onboarding.dart';
import 'package:grub_go/service/shared_pref.dart';
import 'package:grub_go/service/widget_support.dart';
import 'package:grub_go/service/auth.dart'; // <- import your AuthMethods

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  final _authMethods = AuthMethods();
  String? name, email;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    name = await SharedpreferenceHelper().getUserName() ?? '';
    email = await SharedpreferenceHelper().getUserEmail() ?? '';
    setState(() {});
  }

  Future<void> _signOut() async {
    try {
      await _authMethods.SignOut();

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => Onboarding()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error signing out: $e')));
    }
  }

  Future<void> _deleteAccount() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Delete Account'),
            content: Text(
              'This will permanently delete your account. Continue?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Delete'),
              ),
            ],
          ),
    );

    if (confirm == true) {
      try {
        await _authMethods.deleteUser();
        // after deletion, push to onboarding
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => Onboarding()),
          (route) => false,
        );
      } catch (e) {
        // if delete fails (e.g. needs recent login), show error
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error deleting account: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 40),
          Center(
            child: Text('Profile', style: AppWidget.HeadlineTextFeildStyle()),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFFececf8),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: AssetImage('images/boy.jpg'),
                    ),
                    SizedBox(height: 30),
                    _buildCard(
                      icon: Icons.person,
                      label: 'Name',
                      value: name ?? '',
                    ),
                    SizedBox(height: 20),
                    _buildCard(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: email ?? '',
                    ),
                    SizedBox(height: 20),
                    _buildCard(
                      icon: Icons.logout,
                      label: 'Log Out',
                      onTap: _signOut,
                    ),

                    SizedBox(height: 20),
                    _buildCard(
                      icon: Icons.delete_forever,
                      label: 'Delete Account',
                      onTap: _deleteAccount,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String label,
    String? value,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.redAccent),
        title: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: value != null && value.isNotEmpty ? Text(value) : null,
        trailing:
            onTap != null ? Icon(Icons.arrow_forward_ios, size: 16) : null,
        onTap: onTap,
      ),
    );
  }
}
