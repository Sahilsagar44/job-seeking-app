import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../Providers/AuthProvider.dart';
import '../../Themes/Themes.dart';
import '../../main.dart';

class EmployerProfile extends StatefulWidget {
  String birthdate;
  String gender;
  String country;
  String phone;
  EmployerProfile({Key? key, required this.birthdate, required this.gender, required this.country, required this.phone}) : super(key: key);

  @override
  State<EmployerProfile> createState() => _EmployerProfileState();
}

class _EmployerProfileState extends State<EmployerProfile> {
  String filepath = "";
  bool isSelected = false;
  String imageUrl = "";
  final user = FirebaseAuth.instance.currentUser;
  QuerySnapshot<Map<String, dynamic>>? userStream;

  getUser() async {
    final userCollection = FirebaseFirestore.instance.collection("Users");

    try {
      final userDoc = await userCollection.doc(user!.email).get();
      if (userDoc.exists) {
        final data = userDoc.data()!;
        setState(() {
          imageUrl = data["ProfileImage"] ?? "";
          widget.birthdate = data["birthdate"] ?? ""; // Adjust this according to the correct field name in your Firestore database.
          widget.country = data["country"] ?? ""; // Adjust this according to the correct field name in your Firestore database.
          widget.phone = data["phone"] ?? ""; // Adjust this according to the correct field name in your Firestore database.
          widget.gender = data["gender"] ?? ""; // Adjust this according to the correct field name in your Firestore database.
        });
      } else {
        // Handle the case where the user document doesn't exist
        print("User document not found");
      }
    } catch (e) {
      // Handle any errors that occur while fetching the user document
      print("Error fetching user document: $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "Your Profile",
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary, fontFamily: "Roboto-Bold"),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                        radius: 90,
                        // backgroundColor: lightColorScheme.primary,
                        backgroundImage:
                        NetworkImage(user!.photoURL.toString())),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: IconButton(
                          style: IconButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary),
                          onPressed: () async {
                            ImagePicker imagePicker = ImagePicker();
                            XFile? file = await imagePicker.pickImage(
                                source: ImageSource.gallery);
                            if (file == null) {
                              setState(() {
                                isSelected = false;
                              });
                              return;
                            }
                            setState(() {
                              filepath = file.path;
                              print(filepath);
                              isSelected = true;
                            });
                          },
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          )),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                isSelected
                    ? MaterialButton(
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () async {
                      Reference referenceImageToUpload =
                      FirebaseStorage.instance.refFromURL(imageUrl);
                      await referenceImageToUpload.putFile(File(filepath));
                      imageUrl =
                      await referenceImageToUpload.getDownloadURL();
                      print("Hii ${imageUrl}");
                      user!.updatePhotoURL(imageUrl);
                      FirebaseFirestore.instance
                          .collection("Users")
                          .doc(user!.email)
                          .update({"ProfileImage": imageUrl}).then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Profile Picture Updated...")));
                      });
                      setState(() {
                        isSelected = false;
                      });
                    },
                    child: const Text(
                      "Update Profile Image",
                      style: TextStyle(color: Colors.white),
                    ))
                    : Container(),

                Container(
                  alignment: Alignment.centerLeft,
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        const Icon(Icons.person),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          user!.displayName.toString(),
                          style: const TextStyle(
                              fontFamily: "Roboto-Bold", fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        const Icon(Icons.email),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          user!.email.toString(),
                          style: const TextStyle(
                              fontFamily: "Roboto-Bold", fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_month),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.birthdate.toString(),
                          style: const TextStyle(
                              fontFamily: "Roboto-Bold", fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        const Icon(Icons.flag_rounded),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.country.toString(),
                          style: const TextStyle(
                              fontFamily: "Roboto-Bold", fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        const Icon(Icons.phone),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.phone.toString(),
                          style: const TextStyle(
                              fontFamily: "Roboto-Bold", fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        widget.gender.toString() == "Male"
                            ? const Icon(Icons.male)
                            : const Icon(Icons.female),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.gender.toString(),
                          style: const TextStyle(
                              fontFamily: "Roboto-Bold", fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  color: Colors.redAccent,
                  height: 50,
                  minWidth: MediaQuery.of(context).size.width,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  onPressed: () {
                    final provider = Provider.of<Auth>(context, listen: false);
                    provider.signOut();
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const Main()));
                  },
                  child: const Text(
                    "Sign Out",
                    style: TextStyle(fontFamily: "Roboto-Bold", fontSize: 20),
                  ),
                )
                //  Container(
                //   alignment: Alignment.center,
                //   height: 50,
                //   width: MediaQuery.of(context).size.width,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(10),
                //     color: Colors.red
                //   ),
                //   child: Text("Sign Out",style: TextStyle(fontFamily: "Roboto-Bold",fontSize: 20),),
                //  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}