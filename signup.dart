import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grub_go/pages/bottomnav.dart';
import 'package:grub_go/pages/login.dart';
import 'package:grub_go/service/database.dart';
import 'package:grub_go/service/shared_pref.dart';
import 'package:grub_go/service/widget_support.dart';
import 'package:random_string/random_string.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String email = '', password = '', name = '';
  final namecontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final mailcontroller = TextEditingController();
  final Connectivity _connectivity = Connectivity();
  bool _isLoading = false;

  Future<bool> _isOnline() async {
    var result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  Future<void> registration() async {
    setState(() => _isLoading = true);
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final Id = randomAlphaNumeric(10);
      final userinfoMap = {
        'Name': name,
        'Email': email,
        'Id': Id,
        'Wallet': '0',
      };
      await SharedpreferenceHelper().saveUserEmail(email);
      await SharedpreferenceHelper().saveUserName(name);
      await SharedpreferenceHelper().saveUserId(Id);
      await DatabaseMethods().adduserDetails(userinfoMap, Id);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'Registered Successfully',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Bottomnav()),
      );
    } on FirebaseAuthException catch (e) {
      String msg;
      if (e.code == 'weak-password') {
        msg = 'Password Provided is too Weak';
      } else if (e.code == 'email-already-in-use') {
        msg = 'Account Already exists';
      } else {
        msg = e.message ?? 'Registration error';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(msg, style: TextStyle(fontSize: 18.0)),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 2,
            padding: const EdgeInsets.only(top: 30.0),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xffffefbf),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Column(
              children: [
                Image.asset('images/pan.png', height: 180, fit: BoxFit.fill),
                Image.asset(
                  'images/grubgo.png',
                  width: 150,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height / 2.8,
              left: 20,
              right: 20,
            ),
            child: Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                height: MediaQuery.of(context).size.height / 1.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        'SignUp',
                        style: AppWidget.HeadlineTextFeildStyle(),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text('Name', style: AppWidget.SignUpTextFeildStyle()),
                    const SizedBox(height: 5),
                    _buildField(namecontroller, 'Enter Name', Icons.person),
                    const SizedBox(height: 20),
                    Text('Email', style: AppWidget.SignUpTextFeildStyle()),
                    const SizedBox(height: 5),
                    _buildField(
                      mailcontroller,
                      'Enter Email',
                      Icons.mail_outline,
                    ),
                    const SizedBox(height: 20),
                    Text('Password', style: AppWidget.SignUpTextFeildStyle()),
                    const SizedBox(height: 5),
                    _buildField(
                      passwordcontroller,
                      'Enter Password',
                      Icons.lock_outline,
                      obscure: true,
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child:
                          _isLoading
                              ? const CircularProgressIndicator()
                              : GestureDetector(
                                onTap: () async {
                                  if (!await _isOnline()) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text(
                                          'No internet connection.',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    );
                                    return;
                                  }
                                  if (namecontroller.text.isEmpty ||
                                      mailcontroller.text.isEmpty ||
                                      passwordcontroller.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text(
                                          'Please fill in all fields.',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    );
                                    return;
                                  }
                                  setState(() {
                                    name = namecontroller.text;
                                    email = mailcontroller.text;
                                    password = passwordcontroller.text;
                                  });
                                  await registration();
                                },
                                child: Container(
                                  width: 200,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: const Color(0xffef2b39),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Sign Up',
                                    style: AppWidget.boldWhiteTextFeildStyle(),
                                  ),
                                ),
                              ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: AppWidget.SimpleTextFeildStyle(),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap:
                              () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const Login(),
                                ),
                              ),
                          child: Text(
                            'LogIn',
                            style: AppWidget.boldTextFeildStyle(),
                          ),
                        ),
                      ],
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

  Widget _buildField(
    TextEditingController ctrl,
    String hint,
    IconData icon, {
    bool obscure = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFececf8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: ctrl,
        obscureText: obscure,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }
}
