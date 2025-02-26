import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:untitled2/Presentation/Screens/SignInScreens/LoginScreen.dart';

import '../../../Themes/Themes.dart';
import '../../../main.dart';

class SplaceScreen extends StatefulWidget {
  const SplaceScreen({Key? key}) : super(key: key);

  @override
  State<SplaceScreen> createState() => _SplaceScreenState();
}

class _SplaceScreenState extends State<SplaceScreen> {
  final pagecontroller = PageController(initialPage: 0, keepPage: true);

  void pageChanged(int index) {
    setState(() {
      selected = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      selected = index;
      pagecontroller.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  List<Map<String, dynamic>> item = [
    {
      "image": 'assets/icons/S1.svg',
      "title": 'Find Your Best Job Here!',
      "title1":
          'Find out Your desired job. Which is suitable \nfor your career.',
    },
    {
      "image": 'assets/icons/S2.svg',
      "title": 'Boost your dreams!',
      "title1":
          'you\'ve worked hard to achieve your goal;\nnow let us help you get there,',
    },
    {
      "image": 'assets/icons/S3.svg',
      "title": 'looking for an internship?',
      "title1":
          'Are you a student and looking for an internship?\nDon\'t worry. We have got your back',
    },
  ];
  int selected = 0;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: height * 0.015),
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.045,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ));
                        },
                        child: Text(
                          "Skip",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: height * 0.02),
                        ))
                  ],
                ),
                Stack(
                  children: [
                    Container(
                      height: height * 0.78,
                      width: double.infinity,
                      color: Colors.white,
                      child: PageView.builder(
                        itemCount: 3,
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        controller: pagecontroller,
                        onPageChanged: (value) {
                          pageChanged(value);
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              SizedBox(
                                height: height * 0.01,
                              ),
                              SvgPicture.asset(
                                item[index]['image'],
                              ),
                              Column(
                                children: [
                                  Text(
                                    item[index]['title'],
                                    style: TextStyle(
                                      fontSize: height * 0.03,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.04,
                                  ),
                                  Text(
                                    item[index]['title1'],
                                    style: TextStyle(
                                      color: Color(0xffD6D6D6),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    Positioned(
                      top: height * 0.73,
                      left: width * 0.38,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                            3,
                            (index) => Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.02),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selected = index;
                                      });
                                    },
                                    child: selected == index
                                        ? SvgPicture.asset(
                                            "assets/icons/scrooll_bullet.svg")
                                        : CircleAvatar(
                                            backgroundColor: Colors.grey,
                                            radius: height * 0.007,
                                          ),
                                  ),
                                )),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.015,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      height: 60,
                      minWidth: 350,
                      color: Theme.of(context).colorScheme.primary,
                      child: selected == 2 ? Text("Get Started") : Text("Next"),
                      onPressed: () {
                        if (selected != 2) {
                          setState(() {
                            selected++;
                            bottomTapped(selected);
                          });
                        } else {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => LoginScreen()));
                        }
                      }),
                )
              ],
            ),
          ),
        ),
      ),
      onWillPop: () => _onBackButtonPressed(context),
    );
  }

  _onBackButtonPressed(BuildContext context) async {
    bool? exitapp = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Really ??"),
          content: Text("Do You want to close the App??"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("No"),
            ),
            TextButton(
              onPressed: () {
                if (Platform.isAndroid) {
                  SystemNavigator.pop();
                } else {
                  exit(0);
                }
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
    return exitapp ?? false;
  }
}
