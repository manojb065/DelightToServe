import 'package:delightoserver/auth/login.dart';
import 'package:delightoserver/auth/register.dart';
import 'package:delightoserver/food/AshramList.dart';
import 'package:flutter/material.dart';
import 'package:delightoserver/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'food/FoodDonationForm.dart';

class screenRoute {
  static Route<dynamic> routeScreen(RouteSettings set) {
    final arg = set.arguments;
    print(set.name);
    FirebaseAuth usr = FirebaseAuth.instance;
    if (usr.currentUser == null && set.name == "/") {
      print("enter login");
      return MaterialPageRoute(builder: (build) => Login());
    }
    if (usr.currentUser != null && set.name == "/home") {
      print("enter home");
      return MaterialPageRoute(builder: (build) => Home());
    }
    switch (set.name) {
      case "/reg":
        return MaterialPageRoute(builder: (_) => Signup());
      case "/alist":
        return MaterialPageRoute(builder: (_) => AshramList());
      case "/food":
        return MaterialPageRoute(
            builder: (build) => foodDonateRequest(
                  Aname: arg.toString(),
                ));

      default:
        return _error();
    }
  }

  static Route<dynamic> _error() {
    return MaterialPageRoute(
        builder: (builder) => Scaffold(
              body: Text("page not found"),
            ));
  }
}
