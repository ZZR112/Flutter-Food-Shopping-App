import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grub_go/pages/bottomnav.dart';
import 'package:grub_go/pages/signup.dart';
import 'package:grub_go/Admin/admin_login.dart';
import 'package:grub_go/service/widget_support.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = "", password = "";
  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController mailcontroller = TextEditingController();
  final Connectivity _connectivity = Connectivity();
  bool _isLoading = false;

  Future<bool> _isOnline() async {
    var result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  Future<void> userLogin() async {
    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Bottomnav()),
      );
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = "No user found for that Email";
      } else if (e.code == 'wrong-password') {
        message = "Wrong Password Provided By User";
      } else {
        message = e.message ?? 'Authentication error';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            message,
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
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
            padding: EdgeInsets.only(top: 30.0),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xffffefbf),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Column(
              children: [
                Image.asset("images/pan.png", height: 180, fit: BoxFit.fill),
                Image.asset(
                  "images/grubgo.png",
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
              left: 20.0,
              right: 20.0,
            ),
            child: Material(
              elevation: 3.0,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                height: MediaQuery.of(context).size.height / 1.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.0),
                    Center(
                      child: Text(
                        "Log In",
                        style: AppWidget.HeadlineTextFeildStyle(),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text("Email", style: AppWidget.SignUpTextFeildStyle()),
                    SizedBox(height: 5.0),
                    _buildTextField(
                      controller: mailcontroller,
                      hint: "Enter Email",
                      icon: Icons.mail_outline,
                    ),
                    SizedBox(height: 20.0),
                    Text("Password", style: AppWidget.SignUpTextFeildStyle()),
                    SizedBox(height: 5.0),
                    _buildTextField(
                      controller: passwordcontroller,
                      hint: "Enter Password",
                      icon: Icons.lock_outline,
                      obscure: true,
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Forgot Password",
                          style: AppWidget.SimpleTextFeildStyle(),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),

                    Center(
                      child:
                          _isLoading
                              ? CircularProgressIndicator()
                              : GestureDetector(
                                onTap: () async {
                                  if (!await _isOnline()) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text(
                                          'No internet connection. Please try again.',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    );
                                    return;
                                  }
                                  if (mailcontroller.text.isEmpty ||
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
                                    email = mailcontroller.text;
                                    password = passwordcontroller.text;
                                  });
                                  await userLogin();
                                },
                                child: Container(
                                  width: 200,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Color(0xffef2b39),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Log In",
                                      style:
                                          AppWidget.boldWhiteTextFeildStyle(),
                                    ),
                                  ),
                                ),
                              ),
                    ),

                    SizedBox(height: 10.0),
                    Center(
                      child: GestureDetector(
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => AdminLogin()),
                          );
                        },
                        child: Text(
                          "Go to Admin",
                          style: AppWidget.boldTextFeildStyle(),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: AppWidget.SimpleTextFeildStyle(),
                        ),
                        SizedBox(width: 10.0),
                        GestureDetector(
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => Signup()),
                            );
                          },
                          child: Text(
                            "Sign up",
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFececf8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
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
