import 'package:driver_app/pages/mainscreens/bookingspage.dart';
import 'package:driver_app/pages/mainscreens/homepage.dart';
import 'package:driver_app/pages/mainscreens/triphistorypage.dart';
import 'package:flutter/material.dart';

class WrapperPage extends StatefulWidget {
  const WrapperPage({super.key});

  @override
  State<WrapperPage> createState() => _WrapperPageState();
}

class _WrapperPageState extends State<WrapperPage> {
    int _selectedIndex = 0;
  List<Widget> pages = const [
    HomePage(),
    BookingsPage(),
    TripsHistoryPage(),
  ];
  List<String> pageTitles = const ['Home','Bookings','Trip History'];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        unselectedItemColor: const Color.fromARGB(255, 161, 161, 161),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Trip History',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 0, 0, 0),
        onTap: _onItemTapped,
      ),
    );
  }
}