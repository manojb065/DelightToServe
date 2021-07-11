import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Alist extends StatelessWidget {
  List<Widget> list = new List<Widget>.empty(growable: true);
  var db;
  Alist({required this.db});

  Widget _buildList(
      {required Map<String, dynamic> value, required BuildContext context}) {
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
              onPressed: () => Navigator.of(context).pushNamed("/book",
                      arguments: [
                        value['name'],
                        value['location']["lat"],
                        value['location']['long']
                      ]),
              icon: Icon(Icons.add_circle_outline),
              label: Text("Donate"))
        ],
      ),
      color: Colors.teal[200],
    );
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
                  padding: const EdgeInsets.all(20),
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
