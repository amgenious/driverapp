import 'package:driver_app/pages/authscreens/resetpassword_page.dart';
import 'package:driver_app/pages/widgets/logowidget.dart';
import 'package:flutter/material.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const LogoWidget(),
      ),
      body: Center(
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
                textInputAction: TextInputAction.next,
                style: const TextStyle(color: Colors.black),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(255, 255, 255, 255),
                    enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                            color: Color.fromARGB(226, 190, 190, 190),
                            width: 1.0,
                            style: BorderStyle.solid)),
                    hintText: 'Email',
                    hintStyle: TextStyle(
                        color: Color.fromARGB(226, 190, 190, 190))),
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
                                        MaterialStatePropertyAll(
                                            Colors.amberAccent)),
                                onPressed: () {
                                  Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return const ResetPasswordPage();
                                  }),
                                );
                                },
                                child: const Text(
                                  "Send Mail",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white),
                                )),
                          ),
                        ],
                      ),
            ],
          ),
        ),
      ),
    );
  }
}