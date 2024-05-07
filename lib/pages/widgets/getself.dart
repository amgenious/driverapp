// ignore_for_file: avoid_print, unused_import, unrelated_type_equality_checks, use_build_context_synchronously

import 'package:driver_app/pages/mainscreens/endtrippage.dart';
import 'package:driver_app/pages/mainscreens/goonline.dart';
import 'package:driver_app/pages/mainscreens/tripspage.dart';
import 'package:driver_app/utilis/constant.dart';
import 'package:driver_app/wrapper/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class GetProfilePage extends StatefulWidget {
  const GetProfilePage({super.key});

  @override
  State<GetProfilePage> createState() => _GetProfilePageState();
}

class _GetProfilePageState extends State<GetProfilePage> {
  List<Map<String, dynamic>>? drivt;
  List<Map<String, dynamic>>? pro;
  List<dynamic>? driv;
  List<dynamic>? profile;
  String? thumbnailUrl;
  bool _isLoading = true;
  // ignore: prefer_typing_uninitialized_variables
  late String routes;
  late String busValue;
  late String drivervalue;
  late String noofpassengers;
  late String tripid;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> simpleDialog() async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text(
              'Go Online',
              textAlign: TextAlign.center,
            ),
            children: [GoOnlinePage(routeid: routes)],
          );
        })) {}
  }

  Future<void> endTripDialog() async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: [EndTripPage(routeid: routes, tripid: tripid)],
          );
        })) {}
  }

  Future<void> offline() async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text(
              'Do you want to go Offline',
              textAlign: TextAlign.center,
            ),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SimpleDialogOption(
                    onPressed: () async {
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      var token = preferences.getString('token');
                      const String apiUrl =
                          'https://staging-bustransit-api-sfw2.encr.app/api/driver/offline';
                      final String? accessToken = token;
                      final response = await http.post(
                        Uri.parse(apiUrl),
                        headers: {
                          'Authorization': 'Bearer $accessToken',
                          'Content-Type': 'application/json',
                        },
                      );
                      if (response.statusCode == 200) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WrapperPage()),
                        );
                        print("Gone offline");
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Gone offline'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(response.body),
                          ),
                        );
                        print(response.body);
                      }
                      Navigator.of(context).pop();
                    },
                    child: const Text('Yes'),
                  ),
                  SimpleDialogOption(
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    child: const Text('No'),
                  ),
                ],
              )
            ],
          );
        })) {}
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
      });
      print(pro);
      tripid = pro![0]['CurrentTrip'];
      if (driversData != null && driversData.containsKey('Bus')) {
        busValue = driversData['Bus'];
        drivervalue = driversData['DocRefID'];
        List<Map<String, dynamic>> tempDriv = [];
        if (busValue.isNotEmpty) {
          final driverResponse = await http.get(
            Uri.parse(
                'https://staging-bustransit-api-sfw2.encr.app/api/get/bus/$busValue'),
            headers: {
              'Authorization': 'Bearer $userToken',
            },
          );
          if (driverResponse.statusCode >= 200 &&
              driverResponse.statusCode < 300) {
            final driverNameResponse = json.decode(driverResponse.body);
            tempDriv.add(driverNameResponse);
            setState(() {
              drivt = tempDriv;
              driv = tempDriv.isNotEmpty ? tempDriv[0]['Data'] : [];
              print("This is the data: $driv");
              var diff = driverNameResponse['Data'][0];
              if (diff != null && diff['Routes'] != null) {
                routes = diff['Routes'].join(', ');
                noofpassengers = diff['NumberOfPassengers'].toString();
              }
            });
          } else {
            print('Request error for $busValue: ${driverResponse.statusCode}');
            print('Response body: ${driverResponse.body}');
          }
        }
      }
      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    thumbnailUrl = pro?[0]['Thumbnail']['URL'];
    var size = MediaQuery.of(context).size;
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Seats Booked: ${driv?[0]['NumberOfPassengers'].toString()}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  'Seats Available: ${driv?[0]['Seats'] - driv?[0]['NumberOfPassengers']}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              width: size.width,
              decoration: BoxDecoration(
                  color: Colors.amber, borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Visibility(
                        visible: thumbnailUrl!.isNotEmpty,
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
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(thumbnailUrl ?? ""),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "${pro?[0]['FirstName'].toString()} ${pro?[0]['LastName'].toString()}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Text(
                            "${pro?[0]['Email'].toString()}",
                            style: const TextStyle(fontSize: 15),
                          )
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (pro != null && pro!.isNotEmpty) {
                            if (pro![0]['Status'].toString() != 'offline') {
                              offline();
                              print('Go offline');
                              setState(() {});
                            } else {
                              simpleDialog();
                              print('Go online');
                            }
                          }
                        },
                        child: Column(
                          children: [
                            Icon(
                              pro != null &&
                                      pro!.isNotEmpty &&
                                      pro![0]['Status'].toString() != 'offline'
                                  ? Icons.location_disabled
                                  : Icons.online_prediction,
                              color: Colors.white,
                              size: 30,
                            ),
                            Text(
                              pro != null &&
                                      pro!.isNotEmpty &&
                                      pro![0]['Status'].toString() != 'offline'
                                  ? 'Go offline'
                                  : 'Go online',
                              style: const TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Visibility(
              visible: pro != null &&
                  pro!.isNotEmpty &&
                  pro![0]['Status'].toString() != 'offline',
              child: GestureDetector(
                onTap: () {
                  if (pro != null && pro!.isNotEmpty) {
                    if (pro![0]['OnTrip'].toString() != 'true') {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return SizedBox(
                            child: Center(
                              child: ListView(
                                children: [
                                  TripsPage(
                                    busid: busValue,
                                    driverid: drivervalue,
                                    routeid: routes,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      endTripDialog();
                    }
                  }
                },
                child: Column(
                  children: [
                    Icon(
                      pro != null &&
                              pro!.isNotEmpty &&
                              pro![0]['OnTrip'].toString() != 'true'
                          ? Icons.track_changes
                          : Icons.disabled_by_default,
                      color: Colors.amber,
                      size: 30,
                    ),
                    Text(
                      pro != null &&
                              pro!.isNotEmpty &&
                              pro![0]['OnTrip'].toString() != 'true'
                          ? 'Start Trip'
                          : 'End Trip',
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
          ]);
  }
}
