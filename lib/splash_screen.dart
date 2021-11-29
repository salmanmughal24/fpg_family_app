import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fpg_family_app/home_page_screen.dart';
import 'package:fpg_family_app/intro_screen.dart';
import 'package:fpg_family_app/login.dart';
import 'package:fpg_family_app/model/theme_model.dart';
import 'package:provider/provider.dart';

import 'helper/colors.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      Future.delayed(Duration(seconds: 2)).then((value) => getData(FirebaseAuth.instance.currentUser));
    });

  }
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      color: themeProvider.isLightTheme
          ? clr_white
          : clr_black,
        child: Center(
            child: Image.asset(

      "assets/logo.png",
              width: MediaQuery.of(context).size.width/1.5,
      fit: BoxFit.cover,
    )));
  }

  getData(User? currentUser) async {
    if (currentUser == null) {
     // Navigator.pushReplacementNamed(context, 'intro');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Login()));
    } else {
      print("else");
       FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser!.uid)
          .get()
          .then((value)
      {
        print("value${value.data()}");
        /*FUser fUser = FUser.fromJson(value.data()!);
        print("value${fUser.profileImage}");
        GlobalUser.fUser = fUser;*/

        setState(() {

        });
      });

     // Navigator.pushReplacementNamed(context, 'navigation');
     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomePageScreen()));

    }
  }
}
