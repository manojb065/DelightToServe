import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookDonateRequest extends StatelessWidget {
  final String Aname;
  GlobalKey<FormBuilderState> _formkey = new GlobalKey<FormBuilderState>();
  BookDonateRequest({required this.Aname});

  void _addRequest() async {
    var db = FirebaseDatabase.instance
        .reference()
        .child("Ashram")
        .child(Aname)
        .child("Book");
    Map<String, dynamic> data =
        Map<String, dynamic>.from(_formkey.currentState!.value);
    DateTime t = data["time"];
    data.remove("time");
    data.addAll({"time": t.toString()});
    db.child(data['name']).set(data);
    String id = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('bookrequest')
        .doc("$Aname-$id")
        .set({
      "aname": Aname,
      "time": t,
      "status": false,
      "phone": data["phone"],
      "name": data["name"],
      "address": data["address"],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Book"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 250,
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: 250,
                      width: MediaQueryData.fromWindow(window).size.width,
                      child: Image.asset("assets/a.jpg", fit: BoxFit.fill),
                    ),
                    Container(
                      padding: const EdgeInsets.all(5.0),
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        '$Aname',
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    ),
                  ],
                ),
              ),
              //To-do:add here
              FormBuilder(
                key: _formkey,
                child: Column(
                  children: [
                    FormBuilderTextField(
                      name: "name",
                      initialValue:
                          FirebaseAuth.instance.currentUser!.displayName,
                      enabled: false,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        labelText: "Name *",
                        prefixIcon: Icon(Icons.account_box_outlined),
                        hintText: "User name",
                      ),
                      maxLength: 13,
                      mouseCursor: MouseCursor.defer,
                      validator: FormBuilderValidators.compose([
                        (usr) {
                          if (usr!.contains("@") ||
                              usr.contains(RegExp(r'[0-9]'))) {
                            return "invlaid name";
                          } else {
                            return null;
                          }
                        },
                        FormBuilderValidators.required(context)
                      ]),
                    ),
                    FormBuilderTextField(
                      name: "phone",
                      keyboardType: TextInputType.phone,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        labelText: "Phone *",
                        prefixIcon: Icon(Icons.phone),
                        hintText: "xxx-xxx-xxxx",
                      ),
                      maxLength: 10,
                      validator: FormBuilderValidators.required(context,
                          errorText: "Required"),
                    ),
                    FormBuilderDateTimePicker(
                      firstDate: DateTime.now(),
                      name: "time",
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        labelText: "Pick Date  *",
                        prefixIcon: Icon(Icons.alarm),
                      ),
                      inputType: InputType.date,
                      validator: FormBuilderValidators.required(context,
                          errorText: "Required"),
                    ),
                    FormBuilderTextField(
                      name: "address",
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        labelText: "address *",
                        prefixIcon: Icon(Icons.location_city_sharp),
                        hintText: "address",
                      ),
                      maxLines: 4,
                      mouseCursor: MouseCursor.defer,
                      validator: FormBuilderValidators.required(context),
                    ),
                    ElevatedButton.icon(
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            _formkey.currentState!.save();
                          }
                          _addRequest();
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.send),
                        label: Text("submit"))
                  ],
                ),
                autovalidateMode: AutovalidateMode.disabled,
              )
            ],
          ),
        ));
  }
}
