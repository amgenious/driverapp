// ignore_for_file: avoid_print, use_build_context_synchronously, unused_import

import 'package:driver_app/wrapper/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class EndTripPage extends StatefulWidget {
  final String routeid;
  final String tripid;
  const EndTripPage({super.key, required this.routeid, required this.tripid});

  @override
  State<EndTripPage> createState() => _EndTripPageState();
}

class _EndTripPageState extends State<EndTripPage> {
  List<Map<String, dynamic>>? drivt;
  List<dynamic>? driv;
  bool _isLoading = true;
  late String routeid;
  late String tripid;
  String? selectedEndPoint;
  String? dname;
  String? routes;
  double? dlongitude;
  double? dlatitude;

  @override
  void initState() {
    super.initState();
    routeid = widget.routeid;
    tripid = widget.tripid;
    fetchData();
  }

  Future<void> fetchData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    String apiUrl =
        'https://staging-bustransit-api-sfw2.encr.app/api/get/route/$routeid';
    final String? accessToken = token;
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      var routesData = json.decode(response.body);
      List<Map<String, dynamic>> tempDriv = [];
      tempDriv.add(routesData);
      setState(() {
        drivt = tempDriv;
        driv = tempDriv.isNotEmpty ? tempDriv[0]['Data'] : [];
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _endTrip() async {
    if (selectedEndPoint == null) {
      print('Please fill in all required fields.');
      return;
    } else {
      List<String> parts = selectedEndPoint!.split(';');
      dname = parts[0];
      dlatitude = double.parse(parts[1]);
      dlongitude = double.parse(parts[2]);
      routes = parts[3];
    }

    Map<String, dynamic> endTripData = {
      "last_location": {
        "name": dname,
        "geolocation": {
          "longitude": dlongitude,
          "latitude": dlatitude,
        },
      },
    };
    await tripEnd(endTripData);
  }

  Future<void> tripEnd(Map<String, dynamic> endTripData) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    String apiUrl =
        'https://staging-bustransit-api-sfw2.encr.app/api/end/trip/$tripid';
    final String? accessToken = token;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      print("try has started");
      final http.Response response = await http.patch(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(endTripData),
      );
      print("This is the response below");
      print(response.body);
      if (response.statusCode == 200) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Trip Ended Successful'),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WrapperPage()),
        );
      } else if (response.statusCode == 400) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Trip Not Ended: ${response.body}'),
          ),
        );
        Navigator.pop(context);
        print('Failed to book the bus. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          const Text(
            "End Trip",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                      child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: selectedEndPoint,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedEndPoint = newValue;
                          });
                        },
                        items: (driv![0]['Route'] as List)
                            .map<DropdownMenuItem<String>>((routeItem) {
                          String locationName = routeItem['routes'];
                          var longitude =
                              routeItem['location']['geolocation']['Longitude'];
                          var latitude =
                              routeItem['location']['geolocation']['Latitude'];
                          var routes = driv![0]['Description'];
                          String key =
                              '$locationName;$longitude;$latitude;$routes';
                          return DropdownMenuItem<String>(
                            value: key,
                            child: Text(locationName),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                            labelText: 'Select End Point'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: size.width * 0.7,
                            height: 50,
                            child: ElevatedButton(
                                style: const ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        Colors.amberAccent)),
                                onPressed: () async {
                                  await _endTrip();
                                },
                                child: const Text(
                                  "End Trip",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white),
                                )),
                          ),
                        ],
                      ),
                    ],
                  )),
                ),
        ],
      ),
    );
  }
}
