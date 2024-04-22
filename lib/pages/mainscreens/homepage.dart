// ignore_for_file: avoid_print

import 'package:driver_app/pages/mainscreens/notificationpage.dart';
import 'package:driver_app/pages/widgets/drawerwidgets.dart';
import 'package:driver_app/pages/widgets/getself.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  

  @override
  Widget build(BuildContext context) {
    
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
          'Home',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      drawer: const DrawerWidget(),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  GetProfilePage()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
