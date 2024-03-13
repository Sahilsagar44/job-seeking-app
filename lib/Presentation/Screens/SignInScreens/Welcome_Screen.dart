import 'dart:async';
import 'package:flutter/material.dart';
import 'package:text_neon_widget/text_neon_widget.dart';
import 'package:untitled2/main.dart';

import '../../../Themes/Themes.dart';
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
                Main(),
          )),
    );
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage("assets/Backgrounds/img.png"),height: 200,
            ),
            SizedBox(height: 10,),
           Text("JOB HUNT",style: TextStyle(fontSize: 30,color:  Theme.of(context).colorScheme.primary,fontWeight: FontWeight.bold),),]
        ),
      ),
    );
  }
}
