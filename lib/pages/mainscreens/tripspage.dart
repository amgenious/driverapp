// ignore_for_file: unused_import, avoid_print, use_build_context_synchronously

import 'package:driver_app/wrapper/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class TripsPage extends StatefulWidget {
  final String busid;
  final String driverid;
  final String routeid;
  const TripsPage(
      {super.key,
      required this.busid,
      required this.driverid,
      required this.routeid});

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  List<Map<String, dynamic>>? drivt;
  List<dynamic>? driv;
  bool _isLoading = true;
  late String busid;
  late String driverid;
  late String routeid;
  String? selectedStartPoint;
  String? sname;
  String? routes;
  double? slongitude;
  double? slatitude;

  @override
  void initState() {
    super.initState();
    routeid = widget.routeid;
    busid = widget.busid;
    driverid = widget.driverid;
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

  Future<void> _startTrip() async {
    if (selectedStartPoint == null) {
      print('Please fill in all required fields.');
      return;
    } else {
      List<String> parts = selectedStartPoint!.split(';');
      sname = parts[0];
      slatitude = double.parse(parts[1]);
      slongitude = double.parse(parts[2]);
      routes = parts[3];
    }

    Map<String, dynamic> startTripData = {
      "driverID": driverid,
      "busID": busid,
      "initial_location": {
        "name": sname,
        "geolocation": {
          "longitude": slongitude,
          "latitude": slatitude,
        },
      },
    };
    await tripStart(startTripData);
  }

  Future<void> tripStart(Map<String, dynamic> startTripData) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    const String apiUrl =
        'https://staging-bustransit-api-sfw2.encr.app/api/start/trip';
    final String? accessToken = token;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(startTripData),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Trip Started Successful'),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WrapperPage()),
        );
      } else if (response.statusCode == 400) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Trip Not Started, Check if passengers numbers are not zero'),
          ),
        );
        Navigator.pop(context);
        print('Failed to book the bus. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      Navigator.pop(context);
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
            "Start Trip",
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
                        value: selectedStartPoint,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedStartPoint = newValue;
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
                            labelText: 'Select Start Point'),
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
                                  await _startTrip();
                                },
                                child: const Text(
                                  "Start Trip",
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
