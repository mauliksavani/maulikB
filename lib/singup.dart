import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'login.dart';

class CreatedAccountExample extends StatefulWidget {
  const CreatedAccountExample({super.key});

  @override
  State<CreatedAccountExample> createState() => _CreatedAccountExampleState();
}

class _CreatedAccountExampleState extends State<CreatedAccountExample> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final formsKey = GlobalKey<FormState>();
  final formEmailKey = GlobalKey<FormState>();
  final formPasswordKey = GlobalKey<FormState>();
  final formPhoneKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.only(
                top: 62,
                left: 25,
              ),
              child: const Text(
                "Create Account",
                style: TextStyle(
                  fontFamily: "poppins",
                  fontWeight: FontWeight.w600,
                  fontSize: 28,
                  color: Color(0xFF151522),
                  height: 0,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                left: 25,
                top: 37.55,
              ),
              child: const Text(
                "user Name",
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
                        hintText: "enter name",
                        // labelText: "Your Email",
                        filled: true,
                        fillColor: Colors.white, border: InputBorder.none,
                      ),
                      validator: (v) {
                        if (v!.isEmpty) {
                          return "Please enter name";
                        } else if (!RegExp('[a-zA-Z]').hasMatch(v)) {
                          return "please enter valid name";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.name,
                      controller: usernameController,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20.45),
              padding: const EdgeInsets.only(
                left: 25,
              ),
              child: const Text(
                "Email Address",
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
              key: formEmailKey,
              child: Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "enter email",
                        // labelText: "Your Email",
                        filled: true,
                        fillColor: Colors.white, border: InputBorder.none,
                      ),
                      validator: (v) {
                        if (v!.isEmpty) {
                          return "Please enter email";
                        } else if (!RegExp(
                            r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                            .hasMatch(v)) {
                          return "please enter valid email";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20.45),
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
              key: formPasswordKey,
              child: Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "enter password",
                        // labelText: "Your Email",
                        filled: true,
                        fillColor: Colors.white, border: InputBorder.none,
                      ),
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
                      controller: passwordController,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20.45),
              padding: const EdgeInsets.only(
                left: 25,
              ),
              child: const Text(
                "Confirm Password",
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
                        hintText: "enter Confirm Password",
                        // labelText: "Your Email",
                        filled: true,
                        fillColor: Colors.white, border: InputBorder.none,
                      ),
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
                      controller: confirmController,
                    ),
                  ],
                ),
              ),
            ),
            Container(
                alignment: Alignment.bottomRight,
                margin: EdgeInsets.only(left: 230, right: 0),
                //color: Color(0xFf009CF9),
                padding:
                EdgeInsets.only(left: 37, top: 37, bottom: 2, right: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  // color: Color(0xFf009CF9),
                ),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        print("Submit");
                        signup();
                        if (formKey.currentState!.validate()) {
                          print("-=-==-=-=-  success");
                        } else {
                          print("Submit");
                        }
                        if (formEmailKey.currentState!.validate()) {
                          print("-=-==-=-=-  success");
                        } else {
                          print("Submit");
                        }
                        if (formPasswordKey.currentState!.validate()) {
                          print("-=-==-=-=-  success");
                        } else {
                          print("Submit");
                        }
                        if (formsKey.currentState!.validate()) {
                          print("-=-==-=-=-  success");
                        } else {
                          print("Submit");
                        }
                        /*Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePageExample(),
                          ),
                        );*/
                      },
                      child: Row(
                        children: [
                          Text("Submit"),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF009CF9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    // Icon(Icons.chevron_right),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  void signup() async {
    print("call api");
    http.Response response = await http.post(
        Uri.parse("https://todo-list-app-kpdw.onrender.com/api/auth/signup"),
        body: {
          "username": usernameController.text,
          "email": emailController.text,
          "password": passwordController.text,
          "confirmPassword": confirmController.text
        });
    print("response statusCode-- ${response.statusCode}");
    print("response body-- ${response.body}");
    print("response message-- ${jsonDecode(response.body)['message']}");
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(jsonDecode(response.body)['message'])));
    if (response.statusCode == 200) {
      // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePageExample(),));
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPageExample(),
          ),
              (route) => false); // success
    } else {
      // error
    }
  }
}