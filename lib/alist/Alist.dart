import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Alist extends StatelessWidget {
  List<Widget> list = new List<Widget>.empty(growable: true);
  var db;
  String path;
  Alist({required this.db, required this.path});

  Widget _buildList(
      {required Map<String, dynamic> value, required BuildContext context}) {
    return Stack(fit: StackFit.passthrough, children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/a.jpg"), fit: BoxFit.cover)),
        alignment: Alignment.bottomCenter,
        child: Card(
          child: ListTile(
              title: Text(
                value['aname'],
                style: TextStyle(fontSize: 30, color: Colors.blue[50]),
                textAlign: TextAlign.center,
              ),
              subtitle: Text(
                "${value["location"]["location"]}",
                style: TextStyle(color: ThemeData.dark().accentColor),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                maxLines: 2,
              )),
        ),
      ),
      GestureDetector(
        onTap: () => Navigator.of(context).pushNamed(path, arguments: [
          value['aname'],
          value['location']["lat"],
          value['location']['long']
        ]),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black87, Colors.transparent])),
        ),
      ),
    ]);
  }

  void _listBuild(Map<String, dynamic> data, BuildContext con) {
    data.forEach((key, value) {
      list.add(
          _buildList(value: Map<String, dynamic>.from(value), context: con));
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
              _listBuild(Map<String, dynamic>.from(data!.value), context);

              return GridView.count(
                  primary: false,
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                  children: list);
            default:
              return Text("this is List");
          }
          return Text("de;afut");
        });
  }
}
