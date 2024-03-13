// ignore: file_names
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../Themes/Themes.dart';
import 'ClientChatList.dart';
import 'EmployerProfile.dart';
import 'ListProject.dart';
import 'YouListings/OnGoingProjects.dart';
import 'YouListings/YourListings.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final user = FirebaseAuth.instance.currentUser;
  QuerySnapshot<Map<String, dynamic>>? userStream;
  String? name;
  String? email;
  String? country;
  String? gender;
  String? phone;
  String? birthdate;
  String? imageUrl;
  getUser() {
    setState(() {
      FirebaseFirestore.instance
          .collection("Users")
          .where("email", isEqualTo: user!.email)
          .get()
          .then((value) {
        userStream = value;
        name = userStream!.docs[0]["name"].toString();
        email = userStream!.docs[0]["email"].toString();
        imageUrl = userStream!.docs[0]["ProfileImage"].toString();
        country = userStream!.docs[0]["country"].toString();
        phone = userStream!.docs[0]["phone"].toString();
        gender = userStream!.docs[0]["gender"].toString();
        birthdate = userStream!.docs[0]["birthdate"].toString();
      });
    });
  }

  @override
  void initState() {

    super.initState();
    getUser();
  }
  int index = 0;
  final PageController _myPage = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).colorScheme.background,
        elevation: 00,
        // shape: CircularNotchedRectangle(),
        child: SizedBox(
          // color: lightColorScheme.primary,
          height: 65,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              // mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[

                GestureDetector(

                  child: Icon(Icons.home,size: 35,color: index == 0 ? Theme.of(context).colorScheme.primary: Theme.of(context).colorScheme.onBackground,),
                  onTap: () {
                    setState(() {
                      _myPage.animateToPage(
                          0,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut
                      );
                      index = 0;
                    });
                  },
                ),
                GestureDetector(

                  child: Icon(Icons.change_circle_outlined,size: 35,color: index == 1 ? Theme.of(context).colorScheme.primary: Theme.of(context).colorScheme.onBackground),
                  onTap: () {
                    setState(() {
                      _myPage.animateToPage(
                          1,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut
                      );
                      index = 1;
                    });
                  },
                ),
                const SizedBox(width: 25,),
                GestureDetector(

                  child: Icon(Icons.chat,size: 35,color: index == 2 ? Theme.of(context).colorScheme.primary: Theme.of(context).colorScheme.onBackground),
                  onTap: () {
                    setState(() {
                      _myPage.animateToPage(
                          2,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut
                      );
                      index = 2;
                    });
                  },
                ),
                GestureDetector(

                  child: Icon(Icons.settings,size: 35,color: index == 3 ? Theme.of(context).colorScheme.primary: Theme.of(context).colorScheme.onBackground),
                  onTap: () {
                    setState(() {
                      _myPage.animateToPage(
                          3,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut
                      );
                      index = 3;
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
      body: PageView(
        controller: _myPage,
        onPageChanged: (int) {
        },
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          YourLisings(email: FirebaseAuth.instance.currentUser!.email.toString()),
          const OnGoingProjects(),
          ClientChatList(),
          EmployerProfile(
            gender: gender.toString(),
            birthdate: birthdate.toString(),
            country: country.toString(),
            phone: phone.toString(),
          )
        ], // Comment this if you need to use Swipe.
      ),
      floatingActionButton: SizedBox(
        height: 65.0,
        width: 65.0,
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.primary,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_)=>const ListProjectScreen()));
            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            // elevation: 5.0,
          ),
        ),
      ),
    ), onWillPop: () => _onBackButtonPressed(context),);
      
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