import 'dart:convert';

import 'package:astks/singup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'homepage.dart';

class LoginPageExample extends StatefulWidget {
  const LoginPageExample({super.key});

  @override
  State<LoginPageExample> createState() => _LoginPageExampleState();
}

class _LoginPageExampleState extends State<LoginPageExample> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final formsKey = GlobalKey<FormState>();

  bool isLoginAPiResponse = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(
          top: 43.86,
        ),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.only(
                top: 27.21,
                left: 25,
              ),
              child: const Text(
                "Sign In",
                style: TextStyle(
                  fontFamily: "poppins",
                  fontWeight: FontWeight.w600,
                  fontSize: 28,
                  color: Color(0xFF151522),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                left: 25,
              ),
              child: const Text(
                "username",
                style: TextStyle(
                  fontFamily: "poppins",
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Color(0xFF151522),
                  height: 4,
                ),
              ),
            ),
            Form(
              key: formKey,
              child: Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "enter username",
                        // labelText: "Your Email",
                        filled: true,
                        fillColor: Colors.white, border: InputBorder.none,
                      ),
                      controller: emailController,
                      validator: (v) {
                        if (v!.isEmpty) {
                          return "Please enter email";
                        } else if (!RegExp('[a-zA-Z]').hasMatch(v)) {
                          return "please enter valid email";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                left: 25,
              ),
              child: const Text(
                "Password",
                style: TextStyle(
                  fontFamily: "poppins",
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Color(0xFF151522),
                  height: 4,
                ),
              ),
            ),
            Form(
              key: formsKey,
              child: Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "•••••••••••",
                        // labelText: "Your Email",
                        filled: true,
                        fillColor: Colors.white, border: InputBorder.none,
                      ),
                      controller: passwordController,
                      validator: (v) {
                        if (v!.isEmpty) {
                          return "Please enter password";
                        } else if (!RegExp(
                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                            .hasMatch(v)) {
                          return "please enter valid password";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            isLoginAPiResponse == true
                ? const Center(child: CircularProgressIndicator())
                : Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(left: 20, right: 25, top: 20),
              //color: const Color(0xFf009CF9),
              padding: const EdgeInsets.only(left: 25, top: 1, bottom: 1),
              child: ElevatedButton(
                onPressed: () {
                  signIn();
                  /* Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePageExample(),
                    ),
                  );*/
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF009CF9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    )),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text("                                 "),
                    Text("Sign In"),
                  ],
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                print("Create Account");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreatedAccountExample(),
                  ),
                );
              },
              child: Text("Create Account"),
            ),
          ],
        ),
      ),
    );
  }

  void signIn() async {
    // isLoginAPiResponse = true;
    // setState(() {});
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    print("call api");
    print({"email": emailController.text, "password": passwordController.text});
    http.Response response = await http.post(
        Uri.parse("https://todo-list-app-kpdw.onrender.com/api/auth/signin"),
        body: {
          "username": emailController.text,
          "password": passwordController.text,
        });
    print("response statusCode-- ${response.statusCode}");
    print("response body-- ${response.body}");
    print("response message-- ${jsonDecode(response.body)['message']}");
    // isLoginAPiResponse = false;
    // setState(() {});
    Navigator.pop(context);
    if (response.statusCode == 200) {
      print("save token -- ${jsonDecode(response.body)['accessToken']}");
      prefs.setString("token", jsonDecode(response.body)['accessToken']);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Login Successfully")));
      //Navigator.push(context, MaterialPageRoute(builder: (context) => HomePageExample(),));
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomePageExample(),
          ),
              (route) => false);
      // success
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(jsonDecode(response.body)['message'])));
      // error
    }
  }
}
