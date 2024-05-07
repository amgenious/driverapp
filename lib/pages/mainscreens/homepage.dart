// ignore_for_file: avoid_print, deprecated_member_use

import 'package:driver_app/pages/mainscreens/notificationpage.dart';
import 'package:driver_app/pages/mainscreens/passengersgetoff.dart';
import 'package:driver_app/pages/widgets/drawerwidgets.dart';
import 'package:driver_app/pages/widgets/getself.dart';
import 'package:driver_app/pages/widgets/acceptpassengerbookings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  

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
          'Home',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      drawer: const DrawerWidget(),
      body: Stack(
        children: [
        Container(
          height: size.height,
          width: size.width,
          decoration: const BoxDecoration(image: DecorationImage(image:AssetImage('assets/images/bg.png'), fit: BoxFit.cover)),
        ),
        const Center(
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
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
        Container(
          margin: const EdgeInsets.all(10),
          child: FloatingActionButton.small(onPressed: (){
               Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PassengersGettingOff()),
        );
          },
          backgroundColor: Colors.amber,
          foregroundColor: Colors.white,
          child: SvgPicture.asset(
                    'assets/images/pd.svg',
                    color: Colors.black,
          ),
          ),
        )
              ],
            )
          ],
        ),
         Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
        Container(
          margin: const EdgeInsets.only(bottom: 60, right: 10),
          child: FloatingActionButton.small(onPressed: (){
              showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return const SizedBox(
                              child: Center(
                                child: AcceptPassengerBookings(),
                              ),
                            );
                          },
                        );
                        
          },
          backgroundColor: Colors.amber,
          foregroundColor: Colors.white,
          child: SvgPicture.asset(
                  'assets/images/ps.svg',
                ),
          ),
        )
              ],
            )
          ],
        ),
        ]
      ),
    );
  }
}
