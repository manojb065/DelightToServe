import 'package:delightoserver/auth/login.dart';
import 'package:delightoserver/auth/register.dart';
import 'package:delightoserver/food/AshramList.dart';
import 'package:delightoserver/food/tracking/map.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'food/FoodDonationForm.dart';
import 'auth/user.dart';

class screenRoute {
  static Route<dynamic> routeScreen(RouteSettings set) {
    List<dynamic> arg = set.arguments as List<dynamic>;
    print(set.name);
    FirebaseAuth usr = FirebaseAuth.instance;

    if (usr.currentUser != null && set.name == "/") {
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
                  Aname: arg[0],
                  lat: arg[1],
                  long: arg[2],
                ));
      case "/track":
        return MaterialPageRoute(builder: (build) => Tracking());
      case "/profile":
        return MaterialPageRoute(builder: (build) => UserProfile());
      default:
        return MaterialPageRoute(builder: (build) => Login());
    }
  }

  static Route<dynamic> _error() {
    return MaterialPageRoute(
        builder: (builder) => Scaffold(
              body: Text("page not found"),
            ));
  }
}
