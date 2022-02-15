// ignore_for_file: avoid_print, prefer_const_constructors, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learnwu3/model/userModel.dart';
import 'package:learnwu3/screens/login_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import 'home_screen.dart';

class tutorProfileScreen extends StatefulWidget {
  const tutorProfileScreen({Key? key}) : super(key: key);

  @override
  _tutorProfileScreenState createState() => _tutorProfileScreenState();
}

class _tutorProfileScreenState extends State<tutorProfileScreen> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
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
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 150,
                child:
                    Image.asset("assets/img/profile.png", fit: BoxFit.contain),
              ),
              // ignore: prefer_const_constructors
              SizedBox(
                height: 30,
              ),
              Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Name: ${loggedInUser.name} ",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Matrix Number: ${loggedInUser.matrixnumber}",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Email: ${loggedInUser.email}",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Role: ${loggedInUser.role}",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Status: ${loggedInUser.status}",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Subject: ${loggedInUser.subject}",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Language: ${loggedInUser.language}",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                      child: Text(
                        "Contact Me",
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                      ),
                      onTap: () => launch('${loggedInUser.contact}')),
                ],
              ),
              // ignore: prefer_const_constructors
              SizedBox(
                height: 15,
              ),
              ActionChip(
                  label: Text("Reset Role"),
                  onPressed: () {
                    resetRole();
                  }),
            ],
          ),
        ),
      ),
      // floatingActionButton: Column(
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   children: <Widget>[
      //     FloatingActionButton(
      //       heroTag: 'button1',
      //       onPressed: () {
      //         Navigator.of(context).push(
      //           MaterialPageRoute(builder: (BuildContext context) {
      //             return UpdateUserScreen();
      //           }),
      //         );
      //       },
      //       child: Icon(Icons.edit),
      //       foregroundColor: Colors.white,
      //     ),
      //     SizedBox(height: 20),
      //     // FloatingActionButton(
      //     //   heroTag: 'button2',
      //     //   onPressed: () => delete(context),
      //     //   child: Icon(Icons.delete),
      //     //   backgroundColor: Colors.red,
      //     //   foregroundColor: Colors.white,
      //     // ),
      //   ],
      // ),
    );
  }

  // the logout function
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  Future<void> delete(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .delete();
      await FirebaseAuth.instance.currentUser!.delete();

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print(
            'The user must reauthenticate before this operation can be executed.');
      }
    }
  }

  resetRole() async {
    final _auth = FirebaseAuth.instance;
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    // writing all the values
    userModel.email = loggedInUser.email;
    userModel.password = loggedInUser.password;
    userModel.role = 'Tutee';
    userModel.uid = loggedInUser.uid;
    userModel.name = loggedInUser.name;
    userModel.matrixnumber = loggedInUser.matrixnumber;
    userModel.status = null;
    userModel.subject = null;
    userModel.language = null;
    userModel.contact = null;
    // userModel.evidence = _imageFile as String?;

    await firebaseFirestore
        .collection("users")
        .doc(user!.uid)
        .update(userModel.toMap())
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
      (Route<dynamic> route) => false,
    );
  }
}
