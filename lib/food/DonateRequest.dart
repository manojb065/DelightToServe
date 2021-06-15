import 'package:flutter/material.dart';

class ReqList extends StatelessWidget {
  // Map<String, dynamic> list = new Map<String, dynamic>();
  var list = {"orphange": "Ashram1", "location": "banglore"};
  // ReqList({required this.list});

  @override
  Widget build(BuildContext context) {
    print("entered");
    return SingleChildScrollView(
      child: list.forEach((key, value) {
        Card(
          child: ListTile(
            autofocus: true,
            title: Text("hi"),
            subtitle: Text("yes"),
            trailing: Text("status"),
            onTap: () => print(list),
          ),
        );
      }) as Widget,
    );
  }
}
