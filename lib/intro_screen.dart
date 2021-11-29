import 'package:flutter/material.dart';
import 'package:fpg_family_app/helper/colors.dart';
import 'package:fpg_family_app/login.dart';
import 'package:fpg_family_app/register.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'model/theme_model.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
        backgroundColor: themeProvider.isLightTheme
            ? clr_white
            : clr_black,
        body: Column(
      children: [
        SizedBox(height: _height/6,),
        Container(
          //margin: EdgeInsets.symmetric(vertical: 40.0),
            width: _width,
            height: _height/3,

            child: Image.asset(
              "assets/logo.png",
              width: _width/1.8,
              fit: BoxFit.contain,
            )),
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 40.0),
                child: Center(child: Text("Welcome to FPG Family", style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 22, color: themeProvider.isLightTheme
                    ? clr_black87
                    : clr_white, fontWeight: FontWeight.bold)))),
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  style: TextButton.styleFrom(
                      padding:
                      EdgeInsets.symmetric(horizontal: 30, vertical: 18),
                      backgroundColor: clr_selected_icon,
                      shape: RoundedRectangleBorder(
                        //  side: BorderSide(color: Color(0xffEE95A7), width: 2),
                          borderRadius: BorderRadius.circular(6)),
                      ),
                  onPressed: () {
                  //  Navigator.pushNamed(context, 'login');
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> Login()));
                  },
                  child: Text('Login', style: GoogleFonts.poppins(textStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold) ),)),
              SizedBox(
                height: 16,
              ),
              ElevatedButton(
                  style: TextButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 18),
                      backgroundColor: clr_selected_icon,
                      shape: RoundedRectangleBorder(
                         // side: BorderSide(color: Color(0xffEE95A7), width: 2),
                          borderRadius: BorderRadius.circular(6)),
                     ),
                  onPressed: () {
                   // Navigator.pushNamed(context, 'register');

                    Navigator.push(context, MaterialPageRoute(builder: (context)=> Register()));
                  },
                  child: Text('Register',style: GoogleFonts.poppins(textStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold) ))),
            ],
          ),
        ),

      ],
    ));
  }
}
