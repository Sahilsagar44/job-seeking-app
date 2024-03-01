import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'HomeScreen.dart';
import 'Themes/Themes.dart';

class ApplyScreen extends StatefulWidget {
  final String title;
  final String budget;
  final String description;
  final String duration;
  final String experience;
  final String listedBy;
  final String country;
  final String time;
  final String date;
  final String ListedEmail;
  const ApplyScreen(
      {Key? key,
        required this.title,
        required this.budget,
        required this.description,
        required this.duration,
        required this.experience,
        required this.listedBy,
        required this.country,
        required this.time,
        required this.date,
        required this.ListedEmail})
      : super(key: key);

  @override
  State<ApplyScreen> createState() => _ApplyScreenState();
}

class _ApplyScreenState extends State<ApplyScreen> {
  final user = FirebaseAuth.instance.currentUser;
  String? name;

  Future<void> getUser() async {
    final userStream = await FirebaseFirestore.instance.collection("Users").where("email",isEqualTo: user!.email).get();

    if (userStream.docs.isNotEmpty) {
      setState(() {
        name = userStream.docs[0]["name"].toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  final key = GlobalKey<FormState>();
  TextEditingController coverController = TextEditingController();
  TextEditingController link1Controller = TextEditingController();
  TextEditingController link2Controller = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController link3Controller = TextEditingController();
  TextEditingController moreController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColorScheme.background,
      appBar: AppBar(
        elevation: 0,
        foregroundColor: lightColorScheme.primary,
        backgroundColor: lightColorScheme.background,
        title: const Text("Apply For This Job"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                    color: lightColorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              Row(
                children: [
                  const Text("Budget: "),
                  const Icon(
                    Icons.currency_rupee_sharp,
                    size: 15,
                  ),
                  Text(widget.budget),
                ],
              ),
              Text("Duration: ${widget.duration}"),
              const Divider(),

              Form(
                  key: key,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Cover Letter:",
                            style: TextStyle(
                                color: lightColorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          TextFormField(
                            controller: coverController,
                            maxLines: 5,
                            validator: (value) {
                              if(value!.isEmpty){
                                return "Please type cover letter";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: lightColorScheme.primary))),
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            children: [
                              Text("Proposed Price: ",
                                  style: TextStyle(
                                      color: lightColorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: priceController,
                            validator: (value) {
                              if(value!.isEmpty){
                                return "Please Enter";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: lightColorScheme.primary))),
                          ),
                          const Divider(),
                          Row(
                            children: [
                              Text("Links: ",
                                  style: TextStyle(
                                      color: lightColorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                            ],
                          ),
                          TextFormField(controller: link1Controller,
                            decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: lightColorScheme.primary))),
                          ),
                          const SizedBox(height: 10,),
                          TextFormField(
                            controller: link2Controller,
                            decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: lightColorScheme.primary))),
                          ),
                          const SizedBox(height: 10,),
                          TextFormField(
                            controller: link3Controller,
                            decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: lightColorScheme.primary))),
                          ),
                          const SizedBox(height: 10,),
                          const Divider(),
                          Text(
                            "More About You:",
                            style: TextStyle(
                                color: lightColorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          TextFormField(
                            maxLength: 100,
                            maxLines: 3,
                            controller: moreController,
                            validator: (value) {
                              return null;
                            },
                            decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: lightColorScheme.primary))),
                          ),
                          const SizedBox(height: 30,),
                          const Text("")
                        ],
                      ),
                      MaterialButton(onPressed: () async {
                        if(key.currentState!.validate()) {
                          final userId = user!.uid;
                          final jobTitle = widget.title;
                          final userAppliedRef = FirebaseFirestore.instance.collection("Users").doc(userId).collection("Proposels").doc(jobTitle);

                          final userAppliedSnap = await userAppliedRef.get();

                          if (userAppliedSnap.exists) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Application Error'),
                                  content: Text('You have already applied for this job.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            // Continue with applying for the job
                            final format = DateFormat('dd-MM-y').format(DateTime.now());
                            final proposalsRef = FirebaseFirestore.instance.collection("Jobs").doc(widget.title).collection("Proposels").doc(user!.email);

                            await proposalsRef.set({
                              "Name": name,
                              "Date": format,
                              "Client": widget.listedBy,
                              "ClientCountry": widget.country,
                              "Time": TimeOfDay.now().toString(),
                              "CoverLetter": coverController.text,
                              "Link 1": link1Controller.text,
                              "Link 2": link2Controller.text,
                              "Link 3": link3Controller.text,
                              "More": moreController.text,
                              "Title": widget.title,
                              "Price": widget.budget,
                              "Duration": widget.duration,
                              "Status": false,
                              "ListedBy": widget.listedBy,
                              "ProposedPrice": priceController.text,
                              "ListedEmail": widget.ListedEmail,
                              "PaymentStatus": "Request",
                            });

                            final userProposalsRef = FirebaseFirestore.instance.collection("Users").doc(user!.email).collection("Proposels").doc(widget.title);

                            await userProposalsRef.set({
                              "Name": name,
                              "Date": format,
                              "Client": widget.listedBy,
                              "ClientCountry": widget.country,
                              "Time": TimeOfDay.now().toString(),
                              "CoverLetter": coverController.text,
                              "Link 1": link1Controller.text,
                              "Link 2": link2Controller.text,
                              "Link 3": link3Controller.text,
                              "More": moreController.text,
                              "Title": widget.title,
                              "Price": widget.budget,
                              "Duration": widget.duration,
                              "Status": false,
                              "ListedBy": widget.listedBy,
                              "ProposedPrice": priceController.text,
                              "ListedEmail": widget.ListedEmail,
                              "PaymentStatus": "Request",
                            });

                            Navigator.pushReplacement((context), MaterialPageRoute(builder: (_) => HomeScreen()));
                          }
                        }
                      },
                        color: lightColorScheme.primary,
                        minWidth: MediaQuery.of(context).size.width,
                        height: 50,
                        child: const Text("Apply",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
