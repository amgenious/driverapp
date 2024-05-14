// ignore_for_file: avoid_print, unused_import

import 'package:driver_app/ui/bookingsskeleton.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:shimmer/shimmer.dart';

class GetAllBookings extends StatefulWidget {
  const GetAllBookings({super.key});

  @override
  State<GetAllBookings> createState() => _GetAllBookingsState();
}

class _GetAllBookingsState extends State<GetAllBookings> {
  bool _isLoading = true;
  String? thumbnailUrl;
  List<Map<String, dynamic>>? pro;
  List<dynamic>? driv;
  List<Map<String, dynamic>> availablePassengers = [];
  List<Map<String, dynamic>>? drivt;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    const String apiUrl =
        'https://staging-bustransit-api-sfw2.encr.app/api/driver/bookings';
    final String? accessToken = token;
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      var bookingsData = json.decode(response.body);
      if (bookingsData['Data'] != null && bookingsData['Data'] is List) {
        availablePassengers =
            List<Map<String, dynamic>>.from(bookingsData['Data'])
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
          pro = [bookingsData];
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
  }

  @override
  Widget build(BuildContext context) {
    return 
    _isLoading
        ? Column(
          children: [
            SizedBox(
              child: Shimmer(gradient:LinearGradient(  
                colors: [
              Colors.amber.shade900,
              Colors.amber.shade700,
              Colors.amber.shade500,
              Colors.amber.shade300,
              Colors.amber.shade100,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,), child: const BookingsSkeleton()),
            )
          ],)
        : Column(
            children: [
              const Text("Passengers Booked"),
              Expanded(
                child: ListView.builder(
                  itemCount: availablePassengers.length,
                  itemBuilder: (context, index) {
                    thumbnailUrl = drivt?[index]['Thumbnail']['URL'];
                    return Card(
                      color: Colors.amber,
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.all(20),
                            leading: Visibility(
                              visible: thumbnailUrl != null,
                              replacement: Container(
                                  alignment: Alignment.center,
                                  width: 50,
                                  height: 50,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
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
                                  )),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    NetworkImage(thumbnailUrl ?? " "),
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
                                      fontSize: 20),
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
                                            'Destinaiton: ${driv![index]['Destination']['Name']}',
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
                                  color: Colors.black,
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
                                  }),
                                  Text('Status: ${driv![index]['Status']}', style: const TextStyle(fontSize: 10),)
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          );
  }
}
