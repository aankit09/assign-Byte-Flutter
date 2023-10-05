import 'dart:developer';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home_screen/discovery_page.dart';

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
    log("Data ${data}");
    if (response.statusCode == 200) {
      final String? token = data['data']['Token'];
      final int? id = data['data']['Id'];
      log("Token: $token");
      //     log("Id: $id");
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('Token', token!);

      Get.snackbar(
          "Login Sucessful",
          snackPosition: SnackPosition.BOTTOM,
          //data.toString()
          data['message']
          );
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
