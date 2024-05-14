// ignore_for_file: unused_import, avoid_print

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';

class CompletedTrips extends StatefulWidget {
  const CompletedTrips({super.key});

  @override
  State<CompletedTrips> createState() => _CompletedTripsState();
}

class _CompletedTripsState extends State<CompletedTrips> {
  bool _isLoading = true;
  List<Map<String, dynamic>>? pro;
  List<Map<String, dynamic>> completedTrips = [];
  late String driverid;
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
      });
      driverid = pro![0]['DocRefID'];
      const String apiUrl1 =
          'https://staging-bustransit-api-sfw2.encr.app/api/return/trips';
      final response1 = await http.get(
        Uri.parse(apiUrl1),
      );
      if (response1.statusCode == 200) {
        var tripsData = json.decode(response1.body);
        if (tripsData['data'] != null && tripsData['data'] is List) {
          completedTrips = List<Map<String, dynamic>>.from(tripsData['data'])
              .where((trip) =>
                  trip['status'] == 'ended' && trip['driver_id'] == driverid)
              .toList();
        }
        print(completedTrips);

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:       
      _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: ListView.builder(
                        itemCount: completedTrips.length,
                        itemBuilder: (context, index) {
                          return Card(
                            color: Colors.green,
                            child: Column(
                              children: [
                                ListTile(
                                  contentPadding: const EdgeInsets.all(15),
                                  textColor: Colors.black,
                                  iconColor: Colors.black,
                                  leading: Text(
                                    'From: ${completedTrips[index]['initial_location']['name']} to ${completedTrips[index]['last_location']['name']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.flash_on),
                                      Text(
                                          "Status: ${completedTrips[index]['status']}")
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        }))
              ],
            ),
    );
  }
}
