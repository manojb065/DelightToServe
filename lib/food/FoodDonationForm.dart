import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class foodDonateRequest extends StatelessWidget {
  final String Aname;
  final double lat, long;
  static late LocationData _locData;
  GlobalKey<FormBuilderState> _formkey = new GlobalKey<FormBuilderState>();
  foodDonateRequest(
      {required this.Aname, required this.lat, required this.long});

  void _addRequest() async {
    var location = new Location();
    var _svrenb = await location.serviceEnabled();
    if (!_svrenb) {
      _svrenb = await location.requestService();
    }
    var _permission = await location.hasPermission();
    if (_permission == PermissionStatus.denied ||
        _permission == PermissionStatus.deniedForever) {
      _permission = await location.requestPermission();
    }
    _locData = await location.getLocation();
    var db = FirebaseDatabase.instance
        .reference()
        .child("Ashram")
        .child(Aname)
        .child("Food");
    Map<String, dynamic> data =
        Map<String, dynamic>.from(_formkey.currentState!.value);

    DateTime t = data['time'];

    var l = {
      'date': t.toIso8601String(),
      'lat': _locData.latitude,
      'long': _locData.longitude
    };
    data.remove("time");
    data.remove("loc");
    data.addAll(l);
    db.child(data['name']).set(data);
    String id = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('foodrequest')
        .doc("$Aname-$id")
        .set({
      "aname": Aname,
      "time": t,
      "status": false,
      "phone": data["phone"],
      "name": data["name"],
      "lat": lat,
      "long": long
    });
  }

  static void getLocation() async {
    var location = new Location();
    var _svrenb = await location.serviceEnabled();
    if (!_svrenb) {
      _svrenb = await location.requestService();
    }
    var _permission = await location.hasPermission();
    if (_permission == PermissionStatus.denied ||
        _permission == PermissionStatus.deniedForever) {
      _permission = await location.requestPermission();
    }
    _locData = await location.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("Food"),
          actions: [
            IconButton(
              onPressed: () => print("user profile"),
              icon: Icon(Icons.account_circle_outlined),
              color: Colors.cyan[600],
            )
          ],
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
                      child: Image.asset("assets/img.jpg"),
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
                      initialTime: TimeOfDay.now(),
                      name: "time",
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        labelText: "Pick Date and Time *",
                        prefixIcon: Icon(Icons.alarm),
                      ),
                      inputType: InputType.both,
                      validator: FormBuilderValidators.required(context,
                          errorText: "Required"),
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
