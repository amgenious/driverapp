// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:driver_app/pages/authscreens/forgetpassword_page.dart';
import 'package:driver_app/pages/authscreens/resetpassword_page.dart';
import 'package:driver_app/pages/mainscreens/bookingspage.dart';
import 'package:driver_app/pages/mainscreens/notificationpage.dart';
import 'package:driver_app/pages/mainscreens/profilepage.dart';
import 'package:driver_app/ui/privacyscreen.dart';
import 'package:driver_app/ui/startscreen.dart';
import 'package:driver_app/ui/supportscreen.dart';
import 'package:driver_app/wrapper/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
   WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var token = preferences.getString('token');
  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
   final token;
  const MyApp({super.key, required this.token});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  token == null ? const SplashScreenPage() : const WrapperPage(),
      routes:{
        '/homepage':(context) => const WrapperPage(),
        '/forgotpassword':(context) => const ForgetPasswordPage(),
        '/resetpassword':(context) => const ResetPasswordPage(),
        '/bookingspage':(context) => const BookingsPage(),
        '/notifications':(context) => const NotificationsPage(),
        '/support':(context) => const SupportScreen(),
        '/privacy':(context) => const PrivacyScreen(),
        '/profile':(context) => const ProfilePage()
      }
    );
  }
}


