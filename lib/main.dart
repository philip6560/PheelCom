import 'package:flutter/material.dart';
import 'package:pheel_com/splash_screen.dart';
import 'package:pheel_com/status_failed_screen.dart';
import 'package:pheel_com/home_screen.dart';
import 'package:pheel_com/status_successful_screen.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  initialRoute: '/',
  routes: {
    '/': (context) => Splash(),
    '/home': (context) => Home(),
    '/success': (context) => Successful(),
    '/failed': (context) => Failed(),
  },
));



