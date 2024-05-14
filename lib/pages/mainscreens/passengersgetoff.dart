// ignore_for_file: avoid_print, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, unused_import, unused_field

import 'package:driver_app/pages/mainscreens/notificationpage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart' as geo;

class PassengersGettingOff extends StatefulWidget {
  const PassengersGettingOff({super.key});

  @override
  State<PassengersGettingOff> createState() => _PassengersGettingOffState();
}

class _PassengersGettingOffState extends State<PassengersGettingOff> {
  double? slongitude;
  double? slatitude;
  String? sname;
  List<Map<String, dynamic>>? pro;
  List<dynamic>? driv;
  List<Map<String, dynamic>> availablePassengers = [];
  List<Map<String, dynamic>>? drivt;
  bool _isLoading = false;

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
      String locationName = placemarks[0].name ?? 'Unknown';
      setState(() {
        sname = locationName;
      });
    } else {
      print('Location Name: Unknown');
    }
  }

  Future<void> _bookBus() async {
    Map<String, dynamic> locationData = {
      "longitude": slongitude,
      "latitude": slatitude,
    };
    print(locationData);
    await offloadPassengers(locationData);
  }

  Future<void> offloadPassengers(Map<String, dynamic> locationData) async {
    _isLoading = true;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    const String apiUrl =
        'https://staging-bustransit-api-sfw2.encr.app/api/passengers/offload';
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
        body: jsonEncode(locationData),
      );
      Navigator.of(context).pop();
        final Map<String, dynamic> responseData = jsonDecode(response.body);

    if (responseData['Data'].isEmpty) {
      _showMessage(context, 'No passenger stopping.');
    } else {
      // _showMessage(context, 'Passengers stopping: ${responseData['Data']}');
      if (responseData['Data'] != null && responseData['Data'] is List) {
          availablePassengers =
              List<Map<String, dynamic>>.from(responseData['Data'])
                  .where((passenger) =>
                      passenger['PasengerID'] != null &&
                      passenger['PasengerID'].isNotEmpty)
                  .toList();
          final passengerIds =
              availablePassengers.map((passenger) => passenger['PasengerID']);
          final List<Map<String, dynamic>> tempDriv = [];
          for (var passengerId in passengerIds) {
            var passengerResponse = await http.get(
              Uri.parse(
                  'https://staging-bustransit-api-sfw2.encr.app/api/get/passenger/$passengerId'),
              headers: {
                'Authorization': 'Bearer $accessToken',
              },
            );
            if (passengerResponse.statusCode >= 200 &&
                passengerResponse.statusCode < 300) {
              final passengerNameResponse = json.decode(passengerResponse.body);
              tempDriv.add(passengerNameResponse);
            }
          }
          setState(() {
            pro = [responseData];
            List<dynamic> extractedValues = [];
            for (var item in pro!) {
              extractedValues.addAll(item['Data']);
              driv = extractedValues;
            }
            drivt = tempDriv;
            _isLoading = false;
          });
        }  
    }
    } catch (e) {
      _isLoading = false;
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
          'Passengers Getting Off',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
                if (sname != null)
                  SizedBox(
                    width: size.width * 0.7,
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.amberAccent),
                      ),
                      onPressed: () async {
                        await _bookBus();
                      },
                      child: const Text(
                        "Get Passengers Stoping",
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: Column(
                children: [
                  for (var index = 0;
                      index < availablePassengers.length;
                      index++)
                    Card(
                      color: Colors.amber,
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.all(20),
                            leading: Container(
                              alignment: Alignment.center,
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    drivt![index]['FirstName']
                                        .toString()
                                        .substring(0, 1),
                                    style: const TextStyle(fontSize: 25),
                                  ),
                                  Text(
                                    drivt![index]['LastName']
                                        .toString()
                                        .substring(0, 1),
                                    style: const TextStyle(fontSize: 25),
                                  )
                                ],
                              ),
                            ),
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${drivt![index]['FirstName']} ${drivt![index]['LastName']}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                if (driv != null)
                                  ...driv!.map((passenger) {
                                    String doref =
                                        drivt![index]['DocRefID'].toString();
                                    String pass =
                                        driv![index]['PasengerID'].toString();
                                    if (doref == pass) {
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Pick Up: ${driv![index]['PickUpPoint']['Name']}',
                                            style:
                                                const TextStyle(fontSize: 13),
                                          ),
                                          Text(
                                            'Destination: ${driv![index]['Destination']['Name']}',
                                            style:
                                                const TextStyle(fontSize: 13),
                                          ),
                                        ],
                                      );
                                    }
                                    return const Text("NO");
                                  })
                              ],
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.book,
                                  color: Colors.white,
                                ),
                                if (driv != null)
                                  ...driv!.map((passenger) {
                                    String doref =
                                        drivt![index]['DocRefID'].toString();
                                    String pass =
                                        driv![index]['PasengerID'].toString();
                                    if (doref == pass) {
                                      return Text(
                                        'Seat Booked: ${driv![index]['Passengers']}',
                                        style: const TextStyle(fontSize: 12),
                                      );
                                    }
                                    return const Text("NO");
                                  })
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
  void _showMessage(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Information'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
}
