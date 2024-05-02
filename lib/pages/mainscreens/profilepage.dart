// ignore_for_file: prefer_final_fields, unused_import

import 'package:driver_app/pages/mainscreens/addprofilepicture.dart';
import 'package:driver_app/pages/mainscreens/notificationpage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Map<String, dynamic>>? pro;
  bool _isLoading = true;
  late String drivervalue = '';
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    const String apiUrl =
        'https://staging-bustransit-api-sfw2.encr.app/api/driver/profile';
    final String? accessToken = token;
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      var driversData = json.decode(response.body);
      setState(() {
        pro = [driversData];
        _isLoading = false;
      });
      drivervalue = pro![0]['DocRefID'];
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    String thumbnailUrl = pro![0]['Thumbnail']['URL'];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) {
                    return const NotificationsPage();
                  }),
                );
              },
              icon: const Icon(Icons.notifications))
        ],
        title: const Text(
          'Profile Page',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: FloatingActionButton.small(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return SizedBox(
                              child: Center(
                                child: ListView(
                                  children: [
                                    AddProfilePicture(
                                      driverid: drivervalue,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.white,
                      child: const Icon(Icons.update),
                    ),
                  )
                ],
              )
            ],
          ),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     Visibility(
                        visible: thumbnailUrl.isNotEmpty,
                      replacement: Container(
                        alignment: Alignment.center,
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          "${pro?[0]['FirstName'].toString().substring(0, 1)}${pro?[0]['LastName'].toString().substring(0, 1)}",
                          style: const TextStyle(
                              fontSize: 30,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                        child:  CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(thumbnailUrl),
                      ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "${pro?[0]['FirstName']} ${pro?[0]['LastName']}",
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.phone),
                                Text(pro?[0]['PhoneNumber']),
                              ],
                            ),
                          ),
                          SizedBox(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.email),
                                Text(pro?[0]['Email']),
                              ],
                            ),
                          ),
                          SizedBox(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.person),
                                Text(pro?[0]['DriverID']),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
        ],
      ),
    );
  }
}
