import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserProfile extends StatefulWidget {
  late User usr;
  UserProfile() {
    usr = FirebaseAuth.instance.currentUser!;
  }

  @override
  _UserProfileState createState() => _UserProfileState(usr: usr);
}

class _UserProfileState extends State<UserProfile> {
  GlobalKey<FormBuilderState> _formkey = new GlobalKey<FormBuilderState>();

  User usr;
  _UserProfileState({required this.usr});
  void saveUpdate() {
    SnackBar(
      content: Text("updated"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Delight to Server"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                // User? usr = FirebaseAuth.instance.currentUser;
                // String? url = usr!.photoURL;
                setState(() {
                  ImagePicker()
                      .getImage(source: ImageSource.gallery)
                      .then((value) {
                    var path = FirebaseStorage.instance
                        .ref()
                        .child("user/profile/${usr.uid}")
                        .putFile(File(value!.path));
                    path.then((value) {
                      value.ref.getDownloadURL().then((value) {
                        usr.updatePhotoURL(value);
                      });
                    });
                  });
                });
              },
              child: Center(
                child: usr.photoURL == null
                    ? CircleAvatar(
                        radius: 50.0,
                        child: Icon(Icons.photo_camera),
                      )
                    : CircleAvatar(
                        radius: 50.0,
                        backgroundImage: NetworkImage(usr.photoURL.toString()),
                      ),
              ),
            ),
            FormBuilder(
              key: _formkey,
              child: Column(
                children: [
                  FormBuilderTextField(
                    name: "username",
                    initialValue: widget.usr.displayName,
                    maxLength: 13,
                    onSubmitted: (val) {
                      usr.updateDisplayName(val);
                      saveUpdate();
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText: "useranme *",
                      prefixIcon: Icon(Icons.account_box_outlined),
                      hintText: "user name",
                    ),
                    validator: FormBuilderValidators.compose([
                      (val) {
                        if (val!.contains(RegExp(r"[@#%]"))) {
                          return "should not contain special charcter";
                        }
                      },
                      FormBuilderValidators.required(context)
                    ]),
                  ),
                  FormBuilderTextField(
                    name: "email",
                    initialValue: widget.usr.email,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Email *",
                      prefixIcon: Icon(Icons.account_box_outlined),
                      hintText: "example@gmail.com",
                    ),
                  ),
                  ElevatedButton.icon(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.of(context).popAndPushNamed("/");
                      },
                      icon: Icon(Icons.send),
                      label: Text("Log out")),
                ],
              ),
              autovalidateMode: AutovalidateMode.disabled,
            ),
          ],
        ),
      ),
    );
  }
}
