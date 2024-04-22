import 'package:flutter/material.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
int index = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("About & Privacy"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            ExpansionPanelList(
              expansionCallback: (int i, bool isOpen) {
                setState(() {
                  if (index == i) {
                    index = -1;
                  } else {
                    index = i;
                  }
                });
              },
              dividerColor: Colors.grey,
              animationDuration: const Duration(seconds: 1),
              elevation: 1,
              children: <ExpansionPanel>[
                ExpansionPanel(
                  backgroundColor: Colors.amberAccent,
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return const ListTile(
                      title: Text(
                        "About App",
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  },
                  canTapOnHeader: true,
                  body: const ListTile(
                    subtitle: Text("Lorem is ipium"),
                  ),
                  isExpanded: index == 0,
                ),
                ExpansionPanel(
                  backgroundColor: Colors.amberAccent,
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return const ListTile(
                      title: Text(
                        "How we use your information",
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  },
                  canTapOnHeader: true,
                  body: const ListTile(
                    subtitle: Text("Lorem is ipium"),
                  ),
                  isExpanded: index == 1,
                ),
                ExpansionPanel(
                  backgroundColor: Colors.amberAccent,
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return const ListTile(
                      title: Text(
                        "About information Security",
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  },
                  canTapOnHeader: true,
                  body: const ListTile(
                    subtitle: Text("Lorem is ipium"),
                  ),
                  isExpanded: index == 2,
                ),
                ExpansionPanel(
                  backgroundColor: Colors.amberAccent,
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return const ListTile(
                      title: Text(
                        "To Whom do we disclose your details",
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  },
                  canTapOnHeader: true,
                  body: const ListTile(
                    subtitle: Text("Lorem is ipium"),
                  ),
                  isExpanded: index == 3,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}