import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:location/location.dart';

class ReqList extends StatefulWidget {
  @override
  _ReqListState createState() => _ReqListState();
}

class _ReqListState extends State<ReqList> {
  List<Widget> list = new List<Widget>.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('bookrequest')
        .where("name",
            isEqualTo: FirebaseAuth.instance.currentUser!.displayName)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(
            color: Colors.amber[700],
          );
        }

        return new ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          var d = DateTime.fromMicrosecondsSinceEpoch(
              data['time'].microsecondsSinceEpoch);

          String formattedDate = DateFormat('yyyy-MM-dd').format(d);
          return new ListTile(
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                data["status"] == false
                    ? const Tooltip(
                        message: "pending",
                        child: SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            strokeWidth: 3.5,
                            color: Colors.blueGrey,
                          ),
                        ))
                    : const Tooltip(
                        message: "accepted",
                        child: Icon(Icons.check_circle),
                      ),
              ],
            ),
            tileColor: Colors.deepOrangeAccent[600],
            selectedTileColor: Colors.cyanAccent,
            title: new Text("${data.values.elementAt(2)}"),
            subtitle: new Text("Date $formattedDate "),
          );
        }).toList());
      },
    );
  }
}
