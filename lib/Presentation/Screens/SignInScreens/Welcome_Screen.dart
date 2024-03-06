import 'dart:async';
import 'package:flutter/material.dart';
import 'package:untitled2/main.dart';

import 'Splash_Screen.dart';


class Welcome_Screen extends StatefulWidget {
  const Welcome_Screen({Key? key}) : super(key: key);

  @override
  State<Welcome_Screen> createState() => _Welcome_ScreenState();
}
class _Welcome_ScreenState extends State<Welcome_Screen> {
  @override
  void initState() {
    Timer(
      Duration(seconds: 3),
      () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                //GetStorage().read('uid') == null ? SplaceScreen() : Register_screen(),
                Main(),
          )),
    );
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image(
          image: AssetImage("assets/avaters/app_logo.jpeg"),
        ),
      ),
    );
  }
}
