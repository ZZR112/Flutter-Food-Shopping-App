import 'package:flutter/material.dart';
import 'package:grub_go/pages/login.dart';
import 'package:grub_go/service/widget_support.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final Connectivity _connectivity = Connectivity();

  Future<bool> _isOnline() async {
    var result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: 40.0),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("images/grubgo.png"),
              SizedBox(height: 20.0),
              Text(
                "The Fastest\nFood Delivery",
                textAlign: TextAlign.center,
                style: AppWidget.HeadlineTextFeildStyle(),
              ),
              SizedBox(height: 20.0),
              Text(
                "Craving something delicious?\nOrder now and deliver your favorite meals fast and fresh",
                textAlign: TextAlign.center,
                style: AppWidget.SimpleTextFeildStyle(),
              ),
              SizedBox(height: 40.0),

              InkWell(
                onTap: () async {
                  bool online = await _isOnline();
                  if (!online) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(
                          'No internet connection. Please check your settings.',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                    return;
                  }

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const Login()),
                  );
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width / 2,
                  decoration: BoxDecoration(
                    color: Color(0xff8c592a),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      "Get Started",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
