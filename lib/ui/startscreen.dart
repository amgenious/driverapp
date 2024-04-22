import 'package:driver_app/pages/authscreens/signin_page.dart';
import 'package:driver_app/pages/widgets/logowidget.dart';
import 'package:flutter/material.dart';

class SplashScreenPage extends StatelessWidget {
  const SplashScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const LogoWidget(),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      child: Image.asset(
                        'assets/images/bus.png',
                        width: size.width,
                      ),
                    ),
                    const Text(
                      "Take your passengers on a trip",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(0, 0, 0, 1)),
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                     SizedBox(
                      width: size.width *0.5,
                      height: 50,
                      child: ElevatedButton(
                          style:ButtonStyle(
                              backgroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                                  side: MaterialStateProperty.all(const BorderSide(
                                    color: Colors.amberAccent,
                                    width: 2,
                                  )),
                                  ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (BuildContext context) {
                                return const SignInPage();
                              }),
                            );
                          },
                          child: const Text(
                            "SignIn",
                            style: TextStyle(fontSize: 15,color: Colors.amberAccent),
                          )),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}