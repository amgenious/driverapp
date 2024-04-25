// ignore_for_file: unused_import, avoid_print, use_build_context_synchronously

import 'package:driver_app/pages/authscreens/signin_page.dart';
import 'package:driver_app/pages/widgets/logowidget.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final passwordcontroller = TextEditingController();

  Future updatePasswordRequest(Uri url) async {
    try {
      final response = await http.post(url,
          body: jsonEncode(
            {
              'password': passwordcontroller.text.trim(),
            },
          ));
      return response.body;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  Future updatePassword() async {
    final url = Uri.parse(
        'https://staging-bustransit-api-sfw2.encr.app/api/reset/driver/:resetToken');
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
    final response = await updatePasswordRequest(url);
    if (response != null) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email Received. '),
        ),
      );
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
                  'Reset Password',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                   controller: passwordcontroller,
                  textInputAction: TextInputAction.next,
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
                      hintText: 'New Password',
                      hintStyle:
                          TextStyle(color: Color.fromARGB(226, 190, 190, 190))),
                ),
                const SizedBox(
                  height: 10,
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
                            await updatePassword();
                          },
                          child: const Text(
                            "Reset Password",
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
