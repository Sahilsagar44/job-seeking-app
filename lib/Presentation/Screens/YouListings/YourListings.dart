import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../Providers/AuthProvider.dart';
import '../Themes/Themes.dart';
import '../../../main.dart';
import 'RecivedProposals.dart';

class YourLisings extends StatefulWidget {
  final String email;
  YourLisings({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<YourLisings> createState() => _YourLisingsState();
}

class _YourLisingsState extends State<YourLisings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Your Listings",
          style: TextStyle(
              color: lightColorScheme.primary, fontFamily: "Roboto-Bold"),
        ),
        actions: [
          IconButton(
              onPressed: () {
                final provider = Provider.of<Auth>(context, listen: false);
                provider.signOut();
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (_) => Main()));
              },
              icon: Icon(Icons.logout_outlined))
        ],
      ),
      body: SafeArea(
        child: Container(
          child: Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Users")
                  .doc(widget.email)
                  .collection("Listed")
                  .where("Sealed", isEqualTo: false)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData) {
                  return snapshot.data!.docs.isEmpty
                      ? Center(
                          child: Image(
                            image: AssetImage("assets/avaters/no_data.jpg"),
                          ),
                        )
                      : ListView.separated(
                          separatorBuilder: (context, index) => SizedBox(
                            height: 5,
                          ),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => RecivedProposals(
                                        Title: snapshot.data!.docs[index]
                                            ["Title"])));
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: lightColorScheme.primary),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data!.docs[index]["Title"],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Divider(
                                          color: Colors.white,
                                        ),

                                        Text(
                                            "Rs: ${snapshot.data!.docs[index]["Price"]}",
                                            style: TextStyle(
                                                color: Colors.white54)),
                                        Text(
                                            "Duration: ${snapshot.data!.docs[index]["Duration"]}",
                                            style: TextStyle(
                                                color: Colors.white54)),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                            height: 80,
                                            width: 400,
                                            child: Expanded(
                                                child: Text(
                                              snapshot.data!.docs[index]
                                                  ["Description"],
                                              style: TextStyle(
                                                  color: Colors.white),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 4,
                                            ))),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
