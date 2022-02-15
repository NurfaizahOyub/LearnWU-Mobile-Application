// ignore_for_file: prefer_const_constructors, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learnwu3/screens/login_screen.dart';
import 'package:learnwu3/screens/tutorPUser.dart';

class ITT632Screen extends StatefulWidget {
  const ITT632Screen({Key? key}) : super(key: key);

  @override
  _ITT632ScreenState createState() => _ITT632ScreenState();
}

class _ITT632ScreenState extends State<ITT632Screen> {
  final Stream<QuerySnapshot> _userStream = FirebaseFirestore.instance
      .collection('users')
      .where('subject', isEqualTo: 'ITT632')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Tutor List"),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              onPressed: () => logout(context),
              icon: Icon(
                Icons.logout,
                size: 30,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: StreamBuilder(
            stream: _userStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text("something is wrong");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => tutorPUserScreen(
                                    uid: snapshot.data!.docs[index])));
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 4,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 3,
                              right: 3,
                            ),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              title: Text(
                                snapshot.data!.docChanges[index].doc['name'],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                ),
                              ),
                              subtitle: Text(
                                snapshot.data!.docChanges[index].doc['status'],
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }));
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
