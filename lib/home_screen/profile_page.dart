import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/image_model.dart';
import '../widget/imageList.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? profileImage;
  String? name;
  String? email;
  String? location;

  @override
  void initState() {
    super.initState();
    _userData();
  }

// UserData GET
  _userData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      profileImage = prefs.getString('profilepicture') ?? "";
      name = prefs.getString('name') ?? "";
      email = prefs.getString('email') ?? "";
      location = prefs.getString('location') ?? "";
    });
  }

  Future<List<Photo>> fetchImages() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Photo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load images');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsets.all(20.0),
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: Image.asset(
                'assets/images/back.png',
              ),
            ),
          ),
          title: const Center(
              child: Text(
            'Profile Details',
            style: TextStyle(color: Colors.black),
          )),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 15.0,
                right: 15.0,
                top: 15.0,
              ),
              child: Image.asset('assets/images/pic.png'),
            ),
            SizedBox(
              height: 150,
              width: double.maxFinite,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
                child: Card(
                  elevation: 2, // adds a shadow effect
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15.0), // adds rounded corners
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$name',
                          //  'Richa Pawar',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff616163)),
                        ),
                        SizedBox(
                            height:
                                10), // adds spacing between the text and image
                        Text(
                          '$email',
                          style:
                              TextStyle(fontSize: 14, color: Color(0xff616163)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            '$location',
                            //  'Location',
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10, left: 20),
              child: Text(
                'Gallery',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff616163)),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Photo>>(
                future: fetchImages(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final photos = snapshot.data ?? [];
                    return ImageList(photos: photos);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
