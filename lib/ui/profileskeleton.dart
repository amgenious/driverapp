import 'package:driver_app/ui/skeleton.dart';
import 'package:flutter/material.dart';

class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SkeletonPlaceholder(
          width: 80,
          height: 80,
        ),
        SizedBox(
          height: 10,
        ),
        SkeletonPlaceholder(
          height: 10,
          width: 150,
        ),
        SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SkeletonPlaceholder(
                    height: 15,
                    width: 15,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SkeletonPlaceholder(
                    height: 8,
                    width: 100,
                  ),
                ],
              ),
            ),
             SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SkeletonPlaceholder(
                    height: 15,
                    width: 15,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SkeletonPlaceholder(
                    height: 8,
                    width: 100,
                  ),
                ],
              ),
            ),
              SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SkeletonPlaceholder(
                    height: 15,
                    width: 15,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SkeletonPlaceholder(
                    height: 8,
                    width: 100,
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
