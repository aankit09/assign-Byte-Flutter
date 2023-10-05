import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'discovery_page.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key});

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}


class _AddUserPageState extends State<AddUserPage> {
    TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  String? token;
  @override
  void initState() {
    super.initState();
    _token();
  }

// Token GET
  _token() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('Token') ?? "";
      print("Token Value $token!");
    });
  }

// New User Added

  void addUser(String name, email, password) async {
    try {
      final response = await post(
          Uri.parse(
            'http://restapi.adequateshop.com/api/users',
          ),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${token}'
          },
          body: jsonEncode({
            'name': name,
            'email': email,
            'password': password,
          }));

      //    print(response.body);
      var data = jsonDecode(response.body);
      log("Data ${data}");
      if (response.statusCode == 201) {
        //    final String? token = data['data']['Token'];
        Get.to(DiscoveryPage());

        Get.snackbar(
          "User Added",
          "User Created Sucessfully",
          snackPosition: SnackPosition.BOTTOM,
        );
        //   data.toString());
        Get.to(const DiscoveryPage());
      } else if (response.statusCode == 400) {
        Get.snackbar(
          "",
          "Bad Request",
          snackPosition: SnackPosition.BOTTOM,
        );
        //    data.toString());
      }
    } catch (e) {
      Get.snackbar(
        "Faild",
        "Something went wrong",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

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
                padding: const EdgeInsets.only(left: 5.0, top: 10),
                child: InkWell(
                  onTap: () {},
                  child: Image.asset(
                    'assets/images/icon.png',
                    height: 40,
                    width: 40,
                  ),
                ),
              ),
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
                              left: 20.0, right: 20.0, bottom: 10),
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
                              if (value!.isEmpty) {
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

//location
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20, top: 10, bottom: 10),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: locationController,
                            obscureText: true,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                filled: true,
                                fillColor: Color(0xffd1c1e5),
                                hintText: "location",
                                hintStyle: TextStyle(color: Color(0xff8069d4))),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your location';
                              }
                              // You can add more password validation logic here if needed.
                              return null;
                            },
                          ),
                        ),
// Add button
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
                                  addUser(
                                      usernameController.text.toString(),
                                      emailController.text.toString(),
                                      locationController.text.toString());
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Add',
                                  style: TextStyle(
                                      color: Color(0xff8069d4),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22),
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
            ],
          ),
        ),
      ),
    ));

  }
}