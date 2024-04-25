// ignore_for_file: unused_import, avoid_print

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class CancelledTrips extends StatefulWidget {
  const CancelledTrips({super.key});

  @override
  State<CancelledTrips> createState() => _CancelledTripsState();
}

class _CancelledTripsState extends State<CancelledTrips> {
     bool _isLoading = true;
  List<Map<String, dynamic>>? pro;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    const String apiUrl =
        'https://staging-bustransit-api-sfw2.encr.app/api/return/trips';
    final response = await http.get(
      Uri.parse(apiUrl),
    );
    if (response.statusCode == 200) {
      var driversData = json.decode(response.body);
      setState(() {
        pro = [driversData];
      });
      print(pro);
     
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
    return Scaffold(
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : const Center(child: 
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Text("No cancelled Trips")
      ],),),
    );
  }
}