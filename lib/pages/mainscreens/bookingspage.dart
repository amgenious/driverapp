import 'package:driver_app/pages/mainscreens/notificationpage.dart';
import 'package:driver_app/pages/widgets/drawerwidgets.dart';
import 'package:driver_app/pages/widgets/getallbookings.dart';
import 'package:flutter/material.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
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
          'Bookings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      drawer: const DrawerWidget(),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: GetAllBookings(),
        ),
      ),
    );
  }
}