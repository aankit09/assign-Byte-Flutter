import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_byte/auth_screen/register_page.dart';
import 'package:test_byte/home_screen/discovery_page.dart';
import 'package:test_byte/services/login_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: <Color>[
            Color(0xff9B69D4),
            Color(0xffC685B0),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 200,
                    width: 200,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),

// Headline Sign Text

              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 15),
                    child: Stack(
                      children: <Widget>[
                        Text(
                          "Sign In",
                          style: TextStyle(
                            fontSize: 30,
                            //color: Colors.blue – will not work
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 4
                              ..color = Colors.black,
                          ),
                        ),
                        const Text(
                          "Sign In",
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 12.0,
                                color: Colors.black,
                                offset: Offset(1.0, 5.0),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'with your phone number',
                  style: TextStyle(
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 12.0,
                        color: Colors.black,
                        offset: Offset(1.0, 3.0),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),

// Email TextField

              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Form(
                    autovalidateMode: AutovalidateMode.always,
                    key: _formkey,
                    child: Column(
                      children: [
                        //Email
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  !value.contains('@') ||
                                  !value.contains('.')) {
                                return 'Enter Vaild Email';
                              }
                              return null;
                            },
                            showCursor: true,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                filled: true,
                                fillColor: Color(0xffd1c1e5),
                                hintText: "Email-id",
                                hintStyle: TextStyle(color: Color(0xff8069d4))),
                          ),
                        ),

                        const SizedBox(
                          height: 5,
                        ),
//Password
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20, top: 5, bottom: 10),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: passwordController,
                            obscureText: true,
                            validator: (PassCurrentValue) {
                              RegExp regex = RegExp(
                                  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                              var passNonNullValue = PassCurrentValue ?? "";
                              if (passNonNullValue.isEmpty) {
                                return ("Password is required");
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                filled: true,
                                fillColor: Color(0xffd1c1e5),
                                hintText: "password",
                                hintStyle: TextStyle(color: Color(0xff8069d4))),
                          ),
                        ),
// Login button
                        const SizedBox(height: 20),

                        Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: SizedBox(
                              height: 60,
                              width: double.maxFinite,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  login(emailController.text.toString(),
                                      passwordController.text.toString());
                                  Future.delayed(Duration(seconds: 3), () {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: isLoading
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Text(
                                            'Login',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Color(0xff8069d4),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              color: Color(0xff9B69D4),
                                            ),
                                          ),
                                        ],
                                      )
                                    : const Text(
                                        'Login',
                                        style: TextStyle(
                                            color: Color(0xff8069d4),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 110,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Have not any account?',
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(RegisteredPage());
                    },
// Sign Up Button
                    child: const Text(
                      ' Sign Up',
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )),
      ),
    );
  }

  void login(String email, password) async {
    try {
      final response = await post(
          Uri.parse(
            'http://restapi.adequateshop.com/api/authaccount/login',
          ),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'email': email,
            'password': password,
          }));

      var data = jsonDecode(response.body);
  //    log("Data ${data}");
      if (response.statusCode == 200) {
        final String? token = data['data']['Token'];
      //  final int? id = data['data']['Id'];
        log("Token: $token");
        //       log("Id: $id");
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('Token', token!);
      //  await prefs.setInt('Id', id!);

        Get.snackbar(
            "Login Sucessful",
            snackPosition: SnackPosition.BOTTOM,
            data.toString());
        Get.to(const DiscoveryPage());
      } else if (response.statusCode == 400) {
        Get.snackbar(
            "Email or password is not correct",
            snackPosition: SnackPosition.BOTTOM,
            data.toString());
      } else {
        Get.snackbar(
          "Login Faild",
          "Something went wrong",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Exception",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
