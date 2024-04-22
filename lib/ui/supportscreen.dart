import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text('Support'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                    "assets/images/support.png",
                    width: 120,
                  ),
              const Text("How can we help you?", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
              Container(
                padding: const EdgeInsets.all(5),
                child: const Text('It looks like you need help with a problem you are facing. Get in touch with us.', style: TextStyle(fontSize: 11),),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Colors.amberAccent,
                        borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                        const Icon(Icons.chat),
                        GestureDetector(
                        onTap: (){},
                        child: const Text('Chat with us'),
                      ),
                      ],)
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Colors.amberAccent,
                        borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                        const Icon(Icons.email),
                        GestureDetector(
                        onTap: (){},
                        child: const Text('Email us'),
                      ),
                      ],)
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
