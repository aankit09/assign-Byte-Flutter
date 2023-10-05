import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_byte/auth_screen/login_page.dart';

import '../services/register_service.dart';

class RegisteredPage extends StatefulWidget {
  const RegisteredPage({super.key});

  @override
  State<RegisteredPage> createState() => _RegisteredPageState();
}

class _RegisteredPageState extends State<RegisteredPage> {
  bool isLoading = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.maxFinite,
      height: double.maxFinite,
//background color
      decoration: const BoxDecoration(
          gradient: LinearGradient(colors: <Color>[
        Color(0xff9B69D4),
        Color(0xffC685B0),
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),

      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Center(
                  child: Image.asset(
                    'assets/images/signlogo.png',
                    height: 200,
                    width: 200,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),

// Headline Sign Text

              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 15),
                    child: Stack(
                      children: const [
                        Text(
                          "Sign Up",
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
                height: 20,
              ),

// Login TextField

              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Form(
                    autovalidateMode: AutovalidateMode.always,
                    key: _formkey,
                    child: Column(
                      children: [
//userName

                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20.0, bottom: 5),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: usernameController,
                            showCursor: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              filled: true,
                              fillColor: Color(0xffd1c1e5),
                              hintText: "Enter Your Name",
                              hintStyle: TextStyle(
                                color: Color(0xff8069d4),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                        ),

//Email
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
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
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  !value.contains('@') ||
                                  !value.contains('.')) {
                                return 'Enter Vaild Email';
                              }
                              return null;
                            },
                          ),
                        ),

//Password
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20, top: 5, bottom: 5),
                          child: TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            controller: passwordController,
                            obscureText: true,
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
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return 'Enter the password';
                              } else
                                return null;
                            },
                          ),
                        ),
// Submit button
                        const SizedBox(height: 10),

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

                                  Registration(
                                      usernameController.text.toString(),
                                      emailController.text.toString(),
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
                                            'Submit',
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
                                        'Submit',
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
                height: 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already Have an account?',
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(LoginPage());
                    },
// Sign Up Button
                    child: const Text(
                      ' Sign In',
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
