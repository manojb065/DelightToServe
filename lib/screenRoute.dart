import 'package:delightoserver/auth/login.dart';
import 'package:delightoserver/auth/register.dart';
import 'package:delightoserver/cloth/ClothDonationForm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'food/FoodDonationForm.dart';
import 'package:flutter/material.dart';
import 'book/BookDonationForm.dart';
import 'main.dart';
import 'alist/Amain.dart';
import 'auth/user.dart';

class screenRoute {
  static Route routeScreen(RouteSettings set) {
    List<dynamic> arg = set.arguments as List<dynamic>;

    if (set.name == "/home") {
      return MaterialPageRoute(builder: (build) => Home());
    }
    switch (set.name) {
      case "/reg":
        return MaterialPageRoute(builder: (_) => Signup());
      case "/list":
        return MaterialPageRoute(
            builder: (_) => AshramList(title: arg[0], path: arg[1]));
      case "/food":
        return MaterialPageRoute(
            builder: (build) => foodDonateRequest(
                  Aname: arg[0],
                  lat: arg[1],
                  long: arg[2],
                ));

      case "/profile":
        return MaterialPageRoute(builder: (build) => UserProfile());
      case "/cloth":
        return MaterialPageRoute(
            builder: (build) => ClothDonateRequest(Aname: arg[0]));
      case "/book":
        return MaterialPageRoute(
            builder: (build) => BookDonateRequest(Aname: arg[0]));
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
