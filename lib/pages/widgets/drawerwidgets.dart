import 'package:driver_app/pages/authscreens/signin_page.dart';
import 'package:driver_app/pages/widgets/logowidget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
    Future<void> simpleDialog() async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Do you want to logout',textAlign: TextAlign.center,),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
              SimpleDialogOption(
                onPressed: () async {
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      preferences.clear();
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                          return const SignInPage();
                        }),
                      );
                    },
                child: const Text('Yes'),
              ),
              GestureDetector(onTap: (){
                  Navigator.of(context).pop();
              },
              child: const Text("No"),
              )
              ],)

            ],
          );
        })) {}
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const LogoWidget(),
          ListTile(
            title: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('/profile');
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(3.0),
                  ),
                  Icon(
                    Icons.person,
                    color: Color.fromARGB(255, 133, 130, 130),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                  ),
                  Text(
                    "Profile",
                    style: TextStyle(
                        fontSize: 17,
                        color: Color.fromARGB(255, 133, 130, 130)),
                  )
                ],
              ),
            ),
          ),
          ListTile(
            title: GestureDetector(
              onTap: () {},
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(3.0),
                  ),
                  Icon(
                    Icons.language,
                    color: Color.fromARGB(255, 133, 130, 130),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                  ),
                  Text(
                    "Language",
                    style: TextStyle(
                        fontSize: 17,
                        color: Color.fromARGB(255, 133, 130, 130)),
                  )
                ],
              ),
            ),
          ),
          ListTile(
            title: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('/support');
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(3.0),
                  ),
                  Icon(
                    Icons.support,
                    color: Color.fromARGB(255, 133, 130, 130),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                  ),
                  Text(
                    "Support",
                    style: TextStyle(
                        fontSize: 17,
                        color: Color.fromARGB(255, 133, 130, 130)),
                  )
                ],
              ),
            ),
          ),
          ListTile(
            title: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('/privacy');
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(3.0),
                  ),
                  Icon(
                    Icons.privacy_tip,
                    color: Color.fromARGB(255, 133, 130, 130),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                  ),
                  Text(
                    "About & Privacy",
                    style: TextStyle(
                        fontSize: 17,
                        color: Color.fromARGB(255, 133, 130, 130)),
                  )
                ],
              ),
            ),
          ),
          ListTile(
            title: GestureDetector(
              onTap:  simpleDialog,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(3.0),
                  ),
                  Icon(
                    Icons.logout,
                    color: Color.fromARGB(255, 133, 130, 130),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                  ),
                  Text(
                    "Logout",
                    style: TextStyle(
                        fontSize: 17,
                        color: Color.fromARGB(255, 133, 130, 130)),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
