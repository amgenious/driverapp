// ignore_for_file: avoid_print, unused_import, use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'package:driver_app/pages/mainscreens/notificationpage.dart';
import 'package:driver_app/wrapper/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:location/location.dart';
// import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart' as geo;

class GoOnlinePage extends StatefulWidget {
  final String routeid;
  const GoOnlinePage({super.key, required this.routeid});

  @override
  State<GoOnlinePage> createState() => _GoOnlinePageState();
}

class _GoOnlinePageState extends State<GoOnlinePage> {
  late String currentLocation;
  List<Map<String, dynamic>>? drivt;
  List<dynamic>? driv;
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
  }

  void _getCurrentLocation() async {
    bool _serviceEnabled;
    LocationPermission _permissionGranted;

    Position _position;

    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await Geolocator.openLocationSettings();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await Geolocator.checkPermission();
    if (_permissionGranted == LocationPermission.denied) {
      _permissionGranted = await Geolocator.requestPermission();
      if (_permissionGranted != LocationPermission.whileInUse &&
          _permissionGranted != LocationPermission.always) {
        return;
      }
    }

    _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.high);
    print('Latitude: ${_position.latitude}, Longitude: ${_position.longitude}');
    setState(() {
      slongitude = _position.longitude;
      slatitude = _position.latitude;
    });

    // Reverse geocoding to get the location name
    List<Placemark> placemarks = await placemarkFromCoordinates(
      _position.latitude,
      _position.longitude,
    );

    if (placemarks.isNotEmpty) {
      String locationName = placemarks[0].street ?? 'Unknown';
      setState(() {
        sname = locationName;
      });
      print('Location Name: $locationName');
    } else {
      print('Location Name: Unknown');
    }
  }

  Future<void> _bookBus() async {
    Map<String, dynamic> goOnlineData = {
      "routes": [routeid],
      "location": {
        "name": sname,
        "geolocation": {
          "longitude": slongitude,
          "latitude": slatitude,
        },
      },
    };
    print(goOnlineData);
    await goOnline(goOnlineData);
  }

  Future<void> goOnline(Map<String, dynamic> goOnlineData) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    const String apiUrl =
        'https://staging-bustransit-api-sfw2.encr.app/api/driver/online';
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
        body: jsonEncode(goOnlineData),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Online Successful'),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WrapperPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Going Online not successful'),
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
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
          child: Column(
        children: [
          TextButton(
            onPressed: () {
              _getCurrentLocation();
            },
            child: const Text("Get current location"),
          ),
          const SizedBox(
            height: 10,
          ),
          Text("Your current location: $sname"),
          Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    if (sname != null ) 
      SizedBox(
        width: size.width * 0.7,
        height: 50,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.amberAccent),
          ),
          onPressed: () async {
            await _bookBus();
          },
          child: const Text(
            "Go Online",
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
        ),
      ),
  ],
),
        ],
      )),
    );
  }
}
