import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_byte/home_screen/addUser_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'profile_page.dart';

class DiscoveryPage extends StatefulWidget {
  const DiscoveryPage({super.key});

  @override
  State<DiscoveryPage> createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage> {
  String? token;
  int? id;

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
      id = prefs.getInt('Id');
      //    print("Token Value $token!");
      print("Id $id!");
    });
  }

// Discovery Get Profiles Data
  Future<Map> getDiscovery() async {
    try {
      print('Token :$token');
      var discoveryresponse = await http.get(
          Uri.parse(
            "http://restapi.adequateshop.com/api/users?page=1",
          ),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          });

      print('Discovery Data ' + discoveryresponse.body);
      var data = jsonDecode(discoveryresponse.body);
      if (discoveryresponse.statusCode == 200) {
        return jsonDecode(discoveryresponse.body);
      } else {
        return Future.error("Server Error!");
      }
    } catch (e) {
      return Future.error("Error Fetching Data");
    }
  }

// View Profile Api Integration

  Future<Map> getProileDetails({required int id}) async {
    try {
      var response = await http.get(
          Uri.parse(
            "http://restapi.adequateshop.com/api/users/$id",
          ),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          });
      print('Id $id');

      print('Get Profile User ' + response.body);

      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print(response.body);
        final String? profileimg = data['profilepicture'];
        final String? name = data['name'];
        final String? email = data['email'];
        final String? location = data['location'];

        log('profileImage: $profileimg');
        log('name: $name');
        log('message: $email');
        log('location: $location');

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('profileImage', profileimg!);
        await prefs.setString('name', name!);
        await prefs.setString('email', email!);
        await prefs.setString('location', location!);

        log(response.body);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const ProfilePage()));
        Get.snackbar(
          "Profile User Data",
          response.body,
          snackPosition: SnackPosition.BOTTOM,
        );

        return jsonDecode(response.body);
      } else {
        return Future.error("Server Error!");
      }
    } catch (e) {
      return Future.error("Error Fetching Data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Center(
            child: Text(
          'Hire The Art',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        )),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AddUserPage()));
              },
              child: Image.asset(
                'assets/images/plus.png',
                height: 30,
                width: 30,
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<Map>(
        future: getDiscovery(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!['data'].length,
              itemBuilder: (context, index) {
                Map<String, dynamic> obj = snapshot.data!['data'][index];

                return SizedBox(
                  height: 450,
                  child: Card(
                    color: const Color(0xffF2F2F2),
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Stack(
                          //  alignment: Alignment.bottomCenter,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0,
                                  right: 15.0,
                                  top: 5.0,
                                  bottom: 40),
                              child: Center(
                                  child: Image.network(
                                obj['profilepicture'],
                                fit: BoxFit.scaleDown,
                              )),
                            ),
                            Positioned(
                              top: 200,
                              left: 10,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                  left: 20.0,
                                ),
                                child: Image.asset(
                                  'assets/images/Play.png',
                                  height: 40,
                                  width: 40,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10, bottom: 10),
                          child: Center(
                              child: Text(
                            obj['name'],
                            //                                'Richa Pawar',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Center(
                              child: Text(
                            obj['email'],

                            // 'Email',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Center(
                              child: Text(
                            obj['location'],
                            //   'Location',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          )),
                        ),
                        Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: SizedBox(
                              height: 40,
                              width: 150,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                      colors: <Color>[
                                        Color(0xff9B69D4),
                                        Color(0xffC685B0),
                                      ],
                                      begin: Alignment.topRight,
                                      end: Alignment.topLeft),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    getProileDetails(id: obj['id']);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    'View Profile',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
