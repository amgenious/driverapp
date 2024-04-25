// ignore_for_file: unused_import, avoid_print, use_build_context_synchronously

import 'package:driver_app/pages/authscreens/resetpassword_page.dart';
import 'package:driver_app/pages/widgets/logowidget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailcontroller = TextEditingController();

  Future makeEmailRequest(Uri url) async {
    print(emailcontroller.text.trim());
    try {
      final response = await http.post(url,
          body: jsonEncode(
            {
              'email': emailcontroller.text.trim(),
            },
          ));
      print(response);
      return response.body;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  Future getemail() async {
    final url = Uri.parse(
        'https://staging-bustransit-api-sfw2.encr.app/api/driver/forgot-password');
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    bool loading = true;
    if (loading) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
                child: CircularProgressIndicator(),
              ));
    }
    final response = await makeEmailRequest(url);
    print(response);
    if (response != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email Received. Please check your mail'),
        ),
      );
      setState(() {
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const LogoWidget(),
      ),
      body: Form(
        key: formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Forget Password',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: emailcontroller,
                  style: const TextStyle(color: Colors.black),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 255, 255, 255),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(
                              color: Color.fromARGB(226, 190, 190, 190),
                              width: 1.0,
                              style: BorderStyle.solid)),
                      hintText: 'Email',
                      hintStyle:
                          TextStyle(color: Color.fromARGB(226, 190, 190, 190))),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: size.width * 0.7,
                      height: 50,
                      child: ElevatedButton(
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.amberAccent)),
                          onPressed: () async {
                            await getemail();
                          },
                          child: const Text(
                            "Send Mail",
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
