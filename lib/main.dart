//@dart=2.9
import 'package:delightoserver/food/DonateRequest.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:delightoserver/screenRoute.dart';
import 'food/AshramList.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    initialRoute: "/home",
    darkTheme: ThemeData(
      primarySwatch: Colors.grey,
      primaryColor: Colors.black,
      brightness: Brightness.dark,
      backgroundColor: const Color(0xFF212121),
      accentColor: Colors.white,
      accentIconTheme: IconThemeData(color: Colors.black),
      dividerColor: Colors.black12,
    ),
    onGenerateRoute: screenRoute.routeScreen,
  ));
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Delight to Server"),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).popAndPushNamed("/");
            },
            icon: Icon(Icons.account_circle_outlined),
            color: Colors.black,
          )
        ],
      ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed("/alist");
                },
                icon: Icon(Icons.food_bank),
                label: Text("food Donate")),
            Text("clothes"),
            Text("books"),
            Text("donations")
          ],
        ),
      ),
      body: Center(
        child: Text("This is HOME PAGE"),
      ),
    );
  }
}