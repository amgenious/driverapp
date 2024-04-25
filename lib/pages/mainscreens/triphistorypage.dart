import 'package:driver_app/pages/widgets/cancelledtrips.dart';
import 'package:driver_app/pages/widgets/completedtrips.dart';
import 'package:driver_app/pages/widgets/ongoingtrips.dart';
import 'package:flutter/material.dart';

class TripsHistoryPage extends StatelessWidget {
  const TripsHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.flash_on),
                text: 'Ended',
              ),
              Tab(
                icon: Icon(Icons.sync),
                text: 'Ongoing',
              ),
              Tab(
                icon: Icon(Icons.close),
                text: 'Cancelled',
              ),
            ],
          ),
          title: const Text('Trip History'),
        ),
        body: const TabBarView(
          children: [
            CompletedTrips(),
            OngoingTrips(),
            CancelledTrips(),
          ],
        ),
      ),
    );
  }
}
