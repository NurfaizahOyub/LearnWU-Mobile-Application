// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learnwu3/model/userModel.dart';
import 'package:learnwu3/screens/login_screen.dart';
import 'home_screen.dart';

class TutorFormScreen extends StatefulWidget {
  const TutorFormScreen({Key? key}) : super(key: key);

  @override
  _TutorFormScreenState createState() => _TutorFormScreenState();
}

class _TutorFormScreenState extends State<TutorFormScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  String? errorMessage;

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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final contactEditingController = TextEditingController();

  String ddStatusValue = 'Status';
  String ddSubjectValue = 'Subject';
  String ddLanguageValue = 'Language';

  @override
  Widget build(BuildContext context) {
    //contact field
    final contactField = TextFormField(
        autofocus: false,
        controller: contactEditingController,
        keyboardType: TextInputType.url,
        validator: (value) {
          String pattern =
              r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';
          RegExp regex = new RegExp(pattern);
          if (value!.isEmpty) {
            return ("Contact cannot be Empty");
          }
          if (!regex.hasMatch(value)) {
            return ('Please enter valid url');
          }
          return null;
        },
        onSaved: (value) {
          contactEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.contact_phone_rounded),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Contact URL (WS / Tele)",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    final saveButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.teal,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            updateUser();
          },
          child: Text(
            "Save",
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
        title: const Text("Tutor Form"),
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
        child: SingleChildScrollView(
          child: Container(
              child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Tutor Form',
                        style: TextStyle(fontSize: 35.0),
                      ),
                      SizedBox(height: 30),

                      //dropdown Status
                      Container(
                        width: 250,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(3.0)),
                        child: Align(
                          alignment: Alignment.center,
                          // padding: EdgeInsets.only(left: 5.0, right: 5.0),

                          child: DropdownButton<String>(
                            value: ddStatusValue,
                            icon: Icon(Icons.keyboard_arrow_down, size: 30),
                            elevation: 16,
                            underline: SizedBox(),
                            onChanged: (String? newValue) {
                              setState(() {
                                ddStatusValue = newValue!;
                              });
                            },
                            items: <String>['Status', 'Lecturer', 'Student']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(fontSize: 20.0),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      SizedBox(height: 25),

                      //dropdown Subject
                      Container(
                        width: 250,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(3.0)),
                        child: Align(
                          alignment: Alignment.center,
                          // padding: EdgeInsets.only(left: 5.0, right: 5.0),

                          child: DropdownButton<String>(
                            value: ddSubjectValue,
                            icon: Icon(Icons.keyboard_arrow_down, size: 30),
                            elevation: 16,
                            underline: SizedBox(),
                            onChanged: (String? newValue) {
                              setState(() {
                                ddSubjectValue = newValue!;
                              });
                            },
                            items: <String>[
                              'Subject',
                              'ITT632',
                              'ITT420',
                              'ICT652',
                              'ITT626'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(fontSize: 20.0),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),

                      SizedBox(height: 25),

                      //dropdown language
                      Container(
                        width: 250,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(3.0)),
                        child: Align(
                          alignment: Alignment.center,
                          // padding: EdgeInsets.only(left: 5.0, right: 5.0),

                          child: DropdownButton<String>(
                            value: ddLanguageValue,
                            icon: Icon(Icons.keyboard_arrow_down, size: 30),
                            elevation: 16,
                            underline: SizedBox(),
                            onChanged: (String? newValue) {
                              setState(() {
                                ddLanguageValue = newValue!;
                              });
                            },
                            items: <String>[
                              'Language',
                              'Bahasa Melayu',
                              'English',
                              'Both'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(fontSize: 20.0),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      SizedBox(height: 25),
                      contactField,

                      // SizedBox(height: 25),
                      //select file
                      // TextButton.icon(
                      //     style: TextButton.styleFrom(
                      //       primary: Colors.white,
                      //       onSurface: Colors.black,
                      //       backgroundColor: Colors.blue,
                      //     ),
                      //     icon: Icon(Icons.attach_file),
                      //     label: Text('Select File',
                      //         style: TextStyle(fontSize: 20.0)),
                      //     onPressed: () async {
                      //       final results = await ImagePicker()
                      //           .pickImage(source: ImageSource.gallery);

                      //       if (results == null) {
                      //         ScaffoldMessenger.of(context).showSnackBar(
                      //           const SnackBar(
                      //             content: Text('No image picked.'),
                      //           ),
                      //         );
                      //         return null;
                      //       }
                      //       final path = results.files.single.path!;
                      //     }),

                      SizedBox(height: 20),
                      saveButton,
                      SizedBox(height: 20),
                      cancelButton,
                      SizedBox(height: 20),
                    ])),
          )),
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  updateUser() async {
    if (_formKey.currentState!.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing Data')),
      );

      final _auth = FirebaseAuth.instance;
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      User? user = _auth.currentUser;
      UserModel userModel = UserModel();

      // writing all the values
      userModel.email = loggedInUser.email;
      userModel.password = loggedInUser.password;
      userModel.role = 'Tutor';
      userModel.uid = loggedInUser.uid;
      userModel.name = loggedInUser.name;
      userModel.matrixnumber = loggedInUser.matrixnumber;
      userModel.status = ddStatusValue;
      userModel.subject = ddSubjectValue;
      userModel.language = ddLanguageValue;
      userModel.contact = contactEditingController.text;
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
}
