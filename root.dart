import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grub_go/pages/onboarding.dart';
import 'package:grub_go/pages/bottomnav.dart';
import 'package:grub_go/pages/splashscreen.dart';

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          // user is signed in
          return Bottomnav();
        }
        // not signed in
        return SplashScreen();
      },
    );
  }
}
