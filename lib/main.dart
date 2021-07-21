//@dart=2.9
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:delightoserver/screenRoute.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences data = await SharedPreferences.getInstance();
  String usr = data.getString("usrname");
  String path = "/";
  if (usr != null) {
    path = "/home";
  }
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: path,
    theme: ThemeData.dark(),
    onGenerateRoute: screenRoute.routeScreen,
  ));
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Delight to Serve"),
        actions: [
          Tooltip(
            message: "profile",
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed("/profile");
              },
              icon: Icon(Icons.account_circle_outlined),
              // color: Theme.of(context).accentIconTheme.color,
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
                  Navigator.of(context)
                      .pushNamed("/list", arguments: ["Food", "/food"]);
                },
                icon: Icon(Icons.food_bank),
                label: Text("food Donate")),
            TextButton.icon(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed("/list", arguments: ["Book", "/book"]);
                },
                icon: Icon(Icons.book),
                label: Text("book Donate")),
            TextButton.icon(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed("/list", arguments: ["Cloth", "/cloth"]);
                },
                icon: Icon(Icons.shopping_cart),
                label: Text("cloth Donate")),
            // Text("donations")
          ],
        ),
      ),
      body: Center(
        child: Text("This is HOME PAGE"),
      ),
    );
  }
}
