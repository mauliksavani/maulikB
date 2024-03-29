import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'homepage.dart';
import 'login.dart';

class SplashScreenExample extends StatefulWidget {
  const SplashScreenExample({super.key});

  @override
  State<SplashScreenExample> createState() => _SplashScreenExampleState();
}

class _SplashScreenExampleState extends State<SplashScreenExample> {
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 3),
          () async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        var token = prefs.getString("token");
        if (token == null) {
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginPageExample()));
        } else {
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePageExample()));
        }
      },
    );

    // MaterialPageRoute(builder: (context) => LoginPageExample())));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: FlutterLogo(size: MediaQuery.of(context).size.height));
  }
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Center(
        child: Text(
          "SplashScreen",
          textScaleFactor: 2,
        )),
  );
}
