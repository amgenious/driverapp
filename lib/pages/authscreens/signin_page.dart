// ignore_for_file: unused_import, avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'package:driver_app/pages/authscreens/forgetpassword_page.dart';
import 'package:driver_app/pages/widgets/logowidget.dart';
import 'package:driver_app/wrapper/wrapper.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final formKey = GlobalKey<FormState>();
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();

  Future makeSigninRequest(Uri url) async {
    try {
      final response = await http.post(url,
          body: jsonEncode(
            {
              'email': emailcontroller.text.trim(),
              'password': passwordcontroller.text.trim(),
            },
          ));
      return response.body;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  Future signin() async {
    final url = Uri.parse(
        'https://staging-bustransit-api-sfw2.encr.app/api/signin/driver');
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
    final response = await makeSigninRequest(url);
    if (response != null) {
      final sharedPreferences = await SharedPreferences.getInstance();
      final token = jsonDecode(response)['Token'];
      await sharedPreferences.setString('token', token);
      setState(() {
        loading = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const WrapperPage()),
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
                  'Sign In',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(color: Colors.black),
                  controller: emailcontroller,
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
                TextFormField(
                  textInputAction: TextInputAction.done,
                  obscureText: true,
                  controller: passwordcontroller,
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
                      hintText: 'Password',
                      hintStyle:
                          TextStyle(color: Color.fromARGB(226, 190, 190, 190))),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      child: TextButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.white)),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                              return const ForgetPasswordPage();
                            }),
                          );
                        },
                        child: const Text(
                          "Forgot Password?",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                              color: Color.fromARGB(226, 190, 190, 190)),
                        ),
                      ),
                    ),
                  ],
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
                            await signin();
                          },
                          child: const Text(
                            "Sign In",
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
