//@dart=2.9
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:delightoserver/screenRoute.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    initialRoute: "/",
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
          Tooltip(
            message: "profile",
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed("/profile");
              },
              icon: Icon(Icons.account_circle_outlined),
              color: Colors.black,
            ),
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
