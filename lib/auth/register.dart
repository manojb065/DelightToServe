import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../screenRoute.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  GlobalKey<FormBuilderState> _formkey = new GlobalKey<FormBuilderState>();
  String err = "successfully created account";
  bool _showPassword = false;

  void _sigup(Map<String, dynamic> data) async {
    try {
      print("entered");
      UserCredential usr = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: data['email'], password: data['password']);
      usr.user!.updateDisplayName(data['username']);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(err),
        duration: Duration(microseconds: 40),
      ));
      Navigator.of(context).popAndPushNamed("/");
      // return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        err = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        err = 'Wrong password provided for that user.';
      }
    } catch (e) {
      err = e.toString();
    }
    // return false;
    print("exit");
  }

  void toggle() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      onGenerateRoute: screenRoute.routeScreen,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Delight to Server"),
        ),
        body: SingleChildScrollView(
          child: FormBuilder(
            key: _formkey,
            child: Column(
              children: [
                FormBuilderTextField(
                  name: "username",
                  maxLength: 13,
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    labelText: "Email *",
                    prefixIcon: Icon(Icons.account_box_outlined),
                    hintText: "example@gmail.com",
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.email(context),
                    FormBuilderValidators.required(context)
                  ]),
                ),
                FormBuilderTextField(
                  name: "password",
                  keyboardType: TextInputType.text,
                  obscureText: _showPassword,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                      labelText: "Password *",
                      prefixIcon: Icon(Icons.phone),
                      hintText: "****",
                      suffixIcon: !_showPassword
                          ? IconButton(
                              onPressed: () {
                                toggle();
                              },
                              icon: Icon(Icons.visibility_off))
                          : IconButton(
                              onPressed: () => toggle(),
                              icon: Icon(Icons.visibility))),
                  validator: FormBuilderValidators.compose([
                    (val) {
                      if (!val!.contains(RegExp(r"\d+\w+"))) {
                        return "must contain 1 digit and 1 character";
                      }
                    },
                    FormBuilderValidators.required(context)
                  ]),
                ),
                ElevatedButton.icon(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        _formkey.currentState!.save();
                      }
                      _sigup(Map<String, dynamic>.from(
                          _formkey.currentState!.value));
                    },
                    icon: Icon(Icons.send),
                    label: Text("Register")),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).popAndPushNamed("/");
                    },
                    child: Text("have a account ? signin"))
              ],
            ),
            autovalidateMode: AutovalidateMode.disabled,
          ),
        ),
      ),
    );
  }
}
