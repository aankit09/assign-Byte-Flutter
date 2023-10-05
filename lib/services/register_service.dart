import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart';

import '../auth_screen/login_page.dart';

void Registration(String name, email, password) async {
    try {
      final response = await post(
          Uri.parse(
            'http://restapi.adequateshop.com/api/authaccount/registration',
          ),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'name': name,
            'email': email,
            'password': password,
          }));

      print(response.body);
      var data = jsonDecode(response.body.toString());

      if (response.statusCode == 200) {
        Get.snackbar(
            "Registraion Sucessful",
            snackPosition: SnackPosition.BOTTOM,
            data.toString());
        Get.to(const LoginPage());
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