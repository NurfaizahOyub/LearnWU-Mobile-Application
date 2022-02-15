// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learnwu3/model/userModel.dart';
import 'package:learnwu3/screens/home_screen.dart';
import 'package:learnwu3/screens/tutorform_screen.dart';

import 'login_screen.dart';

class ConsentScreen extends StatefulWidget {
  const ConsentScreen({Key? key}) : super(key: key);

  @override
  _ConsentScreenState createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final agreeButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.green,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TutorFormScreen(),
                ));
          },
          child: Text(
            "I Agree",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );
    final cancelButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.red[400],
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ));
          },
          child: Text(
            "Cancel",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );
    return Scaffold(
        appBar: AppBar(
          title: const Text("Consent"),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              onPressed: () => logout(context),
              icon: const Icon(
                Icons.logout,
                size: 30,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(children: [
                  Text("User Consent Form",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      )),
                  SizedBox(height: 15),
                  Text(
                    "I gave my consent towards this LearnWU application to use and publish my information such as:",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 10),
                  Text("1. Name",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      )),
                  Text("2. Contact Information",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      )),
                  Text("3. Subject",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      )),
                  Text("4. Matrix number",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      )),
                  SizedBox(height: 15),
                  Text(
                    "I fully understand all the consequences that may arise from sharing my information. I will take all the responsibilities of all the problems that may arise. This is all at my own risk",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 25),
                  agreeButton,
                  SizedBox(height: 15),
                  cancelButton,
                ])
              ],
            ),
          ),
        ));
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
