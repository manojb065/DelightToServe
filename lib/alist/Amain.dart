// ignore: import_of_legacy_library_into_null_safe
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:delightoserver/book/DonateRequest.dart';
import 'package:delightoserver/cloth/DonateRequest.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import './Alist.dart';
import '../food/DonateRequest.dart';

class AshramList extends StatefulWidget {
  String path;
  String title;
  AshramList({required this.title, required this.path});
  @override
  _AshramListState createState() => _AshramListState(title, path);
}

class error extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text("ERROR"),
    );
  }
}

class _AshramListState extends State<AshramList> {
  String path;
  String title;
  _AshramListState(this.title, this.path);
  Widget _reqList() {
    switch (title) {
      case "Food":
        return FoodReqList();
      case "Cloth":
        return ClothReqList();
      default:
        return ReqList();
    }
  }

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
          title: Text(title),
        ),
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          height: 50.0,
          items: <Widget>[
            Icon(Icons.list, size: 30),
            Icon(Icons.history_edu_outlined, size: 30),
          ],
          color: Colors.black45,
          // buttonBackgroundColor: Colors.white,
          backgroundColor: ThemeData.dark().bottomAppBarColor,
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
          child: _page == 0
              ? Alist(
                  db: db,
                  path: path,
                )
              : _reqList(),
        )));
  }
}
