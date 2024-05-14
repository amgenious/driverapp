import 'package:driver_app/ui/skeleton.dart';
import 'package:flutter/material.dart';

class BookingsSkeleton extends StatelessWidget {
  const BookingsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return  const SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SkeletonPlaceholder(
            height: 8, width: 150,
          ),
          SizedBox(
            height: 10,
          ),
            Card(
              child: SkeletonPlaceholder(
                height: 150,
                width: 500,
              ),
            ),
            SizedBox(
            height: 10,
          ),
           Card(
              child: SkeletonPlaceholder(
                height: 150,
                width: 500,
              ),
            ),
             SizedBox(
            height: 10,
          ),
           Card(
              child: SkeletonPlaceholder(
                height: 150,
                width: 500,
              ),
            ),
             SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}