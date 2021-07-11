import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import './Alist.dart';

import 'DonateRequest.dart';

class ClothAshramList extends StatefulWidget {
  @override
  _AshramListState createState() => _AshramListState();
}

class _AshramListState extends State<ClothAshramList> {
  List<Widget> list = new List<Widget>.empty(growable: true);
  GlobalKey _bottomNavigationKey = GlobalKey();
  int _page = 0;
  late var db;
  @override
  void initState() {
    super.initState();
    db =
        FirebaseDatabase.instance.reference().child("Ashram/Ashraminfo").once();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Cloth"),
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
            // color: Colors.blueAccent,
            child: Center(
          child: _page == 0 ? Alist(db: db) : ReqList(),
        )));
  }
}
