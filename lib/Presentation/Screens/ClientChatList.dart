import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';


import '../../Themes/Themes.dart';
import '../../main.dart';
import 'ClientChatScreen.dart';

class ClientChatList extends StatefulWidget {
  ClientChatList({Key? key}) : super(key: key);

  @override
  State<ClientChatList> createState() => _ClientChatListState();
}

class _ClientChatListState extends State<ClientChatList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text("Your Chats",style: TextStyle(color: Theme.of(context).colorScheme.primary,fontFamily: "Roboto-Bold"),),
        
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Chats")
              .where("ClientEmail",
                  isEqualTo: FirebaseAuth.instance.currentUser!.email)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

            if (snapshot.hasData) {
              return snapshot.data!.docs.isEmpty
                  ? Center(
                child: Image(
                  image: AssetImage(
                      "assets/avaters/no_data.jpg"),
                ),
              ):
                ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    subtitle: Text(snapshot.data!.docs[index]["Applier"]),
                    onTap: () {
                      Get.to(
                        ClientChatScreen(
                          title: snapshot.data!.docs[index]["Title"],
                          applieremail: snapshot.data!.docs[index]
                              ["ApplierEmail"],
                          clientemail: snapshot.data!.docs[index]["ClientEmail"],
                          ApplierName: snapshot.data!.docs[index]["Applier"],
                          Clientname: snapshot.data!.docs[index]["Client"],
                        ),
                        transition: Transition.downToUp,
                        duration: Duration(milliseconds: 600));

                    },
                    
                    
                    title: Text("${snapshot.data!.docs[index]["Title"]}",),
                  );
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
