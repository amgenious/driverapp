import 'package:driver_app/ui/skeleton.dart';
import 'package:flutter/material.dart';

class HomePageSkeleton extends StatelessWidget {
  const HomePageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SkeletonPlaceholder(
              height: 10,
              width: 150,
            ),
            SkeletonPlaceholder(
              height: 10,
              width: 150,
            )
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          padding: const EdgeInsets.all(15),
          width: size.width,
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(10)),
          child: const Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SkeletonPlaceholder(
                    height: 80,
                    width: 80,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SkeletonPlaceholder(
                        height: 8,
                        width: 150,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SkeletonPlaceholder(
                        height: 8,
                        width: 100,
                      )
                    ],
                  )
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  SkeletonPlaceholder(
                    height: 20,
                    width: 20,
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
