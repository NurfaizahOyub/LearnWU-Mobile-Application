// ignore_for_file: file_names

class UserModel {
  String? uid;
  String? email;
  String? password;
  String? name;
  String? matrixnumber;
  String? role;
  String? status;
  String? subject;
  String? language;
  String? evidence;
  String? contact;

  UserModel(
      {this.uid,
      this.email,
      this.password,
      this.name,
      this.matrixnumber,
      this.role,
      this.status,
      this.subject,
      this.language,
      this.evidence,
      this.contact});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      password: map['password'],
      name: map['name'],
      matrixnumber: map['matrixnumber'],
      role: map['role'],
      status: map['status'],
      subject: map['subject'],
      language: map['language'],
      evidence: map['evidence'],
      contact: map['contact'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'password': password,
      'name': name,
      'matrixnumber': matrixnumber,
      'role': role,
      'status': status,
      'subject': subject,
      'language': language,
      'evidence': evidence,
      'contact': contact,
    };
  }
}
