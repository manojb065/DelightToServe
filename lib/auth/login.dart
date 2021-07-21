import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screenRoute.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormBuilderState> _formkey = new GlobalKey<FormBuilderState>();
  String err = "Successfully logged in";

  bool _showPassword = true;

  void toggle() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  void _sigin(Map<String, dynamic> data) async {
    try {
      var usr = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: data['email'], password: data['password']);

      FirebaseFirestore.instance
          .collection("AshramUser")
          .where("uid", isEqualTo: usr.user!.uid)
          .get()
          .then((value) async {
        if (value.docs.isEmpty) {
          SharedPreferences data = await SharedPreferences.getInstance();
          data.setString("usrname", usr.user!.displayName ?? "");
          print(data.getString("usrname"));
          Navigator.of(context).popAndPushNamed("/home");
        } else {
          FirebaseAuth.instance.signOut();
        }
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        err = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        err = 'Wrong password provided for that user.';
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(err),
      duration: Duration(seconds: 5),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: screenRoute.routeScreen,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Delight to Serve"),
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.white, Colors.blue],
                      end: Alignment.topCenter,
                      begin: Alignment.bottomCenter)),
            ),
            FormBuilder(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: FormBuilderTextField(
                      name: "email",
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        enabled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(60)),
                        labelText: "Email *",
                        prefixIcon: Icon(Icons.account_box_outlined),
                        hintText: "example@gmail.com",
                      ),
                      mouseCursor: MouseCursor.defer,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.email(context),
                        FormBuilderValidators.required(context)
                      ]),
                    ),
                  ),
                  FormBuilderTextField(
                    name: "password",
                    keyboardType: TextInputType.text,
                    obscureText: _showPassword,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                        enabled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(60)),
                        labelText: "Password *",
                        prefixIcon: Icon(Icons.lock),
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
                    validator: FormBuilderValidators.required(context,
                        errorText: "Required"),
                  ),
                  ElevatedButton.icon(
                      onPressed: () {
                        if (_formkey.currentState!.validate()) {
                          _formkey.currentState!.save();
                        }

                        Map<String, dynamic>.from(_formkey.currentState!.value);
                        _sigin(Map<String, dynamic>.from(
                            _formkey.currentState!.value));
                      },
                      icon: Icon(Icons.send),
                      label: Text("Login")),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).popAndPushNamed("/reg");
                      },
                      child: Text("click here ? signup"))
                ],
              ),
              autovalidateMode: AutovalidateMode.disabled,
            )
          ],
        ),
      ),
    );
  }
}
