import 'package:delightoserver/auth/login.dart';
import 'package:delightoserver/auth/register.dart';
import 'package:delightoserver/cloth/ClothDonationForm.dart';
import 'package:delightoserver/food/Amain.dart';
import 'food/FoodDonationForm.dart';
import 'package:flutter/material.dart';
import 'cloth/Amain.dart';
import 'book/Amain.dart';
import 'book/BookDonationForm.dart';
import 'book/DonateRequest.dart';
import 'main.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

      case "/profile":
        return MaterialPageRoute(builder: (build) => UserProfile());
      case "/clist":
        return MaterialPageRoute(builder: (_) => ClothAshramList());
      case "/cloth":
        return MaterialPageRoute(
            builder: (build) => ClothDonateRequest(Aname: arg[0]));
      case "/blist":
        return MaterialPageRoute(builder: (_) => BookAshramList());
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
