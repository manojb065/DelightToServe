import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

import 'DonateRequest.dart';

class AshramList extends StatefulWidget {
  @override
  _AshramListState createState() => _AshramListState();
}

class _AshramListState extends State<AshramList> {
  List<Widget> list = new List<Widget>.empty(growable: true);
  GlobalKey _bottomNavigationKey = GlobalKey();
  int _page = 0;
  // late Future<DataSnapshot> db;
  late var db;
  @override
  void initState() {
    super.initState();

    db =
        FirebaseDatabase.instance.reference().child("Ashram/Ashraminfo").once();
  }

  _getdata() async {
    return FirebaseDatabase.instance
        .reference()
        .child("Ashram/Ashraminfo")
        .once();
  }

  Widget _buildList({required Map<String, dynamic> value}) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          ListTile(
            title: Text(
              value['name'],
              style: TextStyle(fontSize: 30),
              textAlign: TextAlign.center,
            ),
            subtitle: Column(
              children: [
                Text(
                  "Distance ${value["distance"]} kms",
                  textAlign: TextAlign.start,
                ),
                Text(
                  "${value["location"]["location"]}",
                  overflow: TextOverflow.fade,
                  maxLines: 2,
                  textAlign: TextAlign.start,
                )
              ],
            ),
          ),
          ElevatedButton.icon(
              onPressed: () => Navigator.of(context)
                  .pushNamed("/food", arguments: value['name']),
              icon: Icon(Icons.add_circle_outline),
              label: Text("Donate"))
        ],
      ),
      color: Colors.teal[200],
    );
  }

  void _listBuild(Map<String, dynamic> data) {
    data.forEach((key, value) {
      list.add(_buildList(value: Map<String, dynamic>.from(value)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Food"),
        ),
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          height: 50.0,
          items: <Widget>[
            Icon(Icons.list, size: 30),
            Icon(Icons.history_edu_outlined, size: 30),
          ],
          color: Colors.black45,
          buttonBackgroundColor: Colors.white,
          backgroundColor: Colors.blueAccent,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 600),
          onTap: (index) {
            setState(() {
              _page = index;
            });
          },
        ),
        body: Container(
            color: Colors.blueAccent,
            child: Center(
              child: _page == 0
                  ? FutureBuilder(
                      future: db,
                      builder: (build, AsyncSnapshot<DataSnapshot> snapshot) {
                        DataSnapshot? data = snapshot.data;

                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            print("error in connecting");
                            break;
                          case ConnectionState.active:
                            print("connection is active");
                            break;
                          case ConnectionState.waiting:
                            return CircularProgressIndicator(
                              color: Colors.amber[700],
                            );
                          case ConnectionState.done:
                            _listBuild(Map<String, dynamic>.from(data!.value));

                            return GridView.count(
                                primary: false,
                                padding: const EdgeInsets.all(20),
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                crossAxisCount: 2,
                                children: list);
                          default:
                            return Text("this is List");
                        }
                        return Text("de;afut");
                      })
                  : ReqList(),
            )));
  }
}
