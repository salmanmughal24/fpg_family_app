import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fpg_family_app/about.dart';
import 'package:fpg_family_app/helper/colors.dart';
import 'package:fpg_family_app/login.dart';
import 'package:fpg_family_app/request_prayer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import 'model/theme_model.dart';


class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool lockInBackground = true;
  bool notificationsEnabled = true;
  late bool isSwitched = false ;
  _launchURL() async {
    const url = 'https://tithe.ly/give_new/www/#/tithely/give-one-time/3317107?widget=1&action=Give%20Online%20Now';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  changeThemeMode(bool theme) {
    if (!theme) {
      // _animationController.forward(from: 0.0);
    } else {
      // _animationController.reverse(from: 1.0);
    }
  }
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    isSwitched = !(themeProvider.isLightTheme);
    return Scaffold(
      backgroundColor: themeProvider.isLightTheme
          ? clr_white
          : clr_black,
      appBar: AppBar(
        backgroundColor:  clr_selected_icon,
        /*   backgroundColor: themeProvider.isLightTheme
            ? Colors.white
            : clr_black,*/
        title: Text(
          'FPG Family',
          style: TextStyle(
              color: Colors.white,
              /*  color: themeProvider.isLightTheme
              ? Colors.black87
              : Colors.white,*/
              fontSize: 17,
              fontWeight: FontWeight.w700
          ),
        ),
        actions: [
          GestureDetector(

            onTap: ()  {
              _launchURL();
            },
            child: Center(child: Container(margin: EdgeInsets.symmetric(horizontal: 10.0),
                padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    border: Border.all(color: Colors.green,)
                ),
                child: Text("GIVE" ,style: TextStyle(color: Colors.white),))),
          ),



        ],
      ),
      body: Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          child: buildSettingsList(context)),
    );
  }

  Widget buildSettingsList(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    isSwitched = !(themeProvider.isLightTheme);
    return SettingsList(
      backgroundColor: themeProvider.isLightTheme
        ? clr_white
        : clr_black87,
      sections: [

        SettingsSection(
          title: 'App Settings',
         titleTextStyle: GoogleFonts.openSans(textStyle: TextStyle(color:themeProvider.isLightTheme?clr_black45:clr_white70 , fontSize: 16, fontWeight: FontWeight.w500)),

         // titleTextStyle:  ,
          tiles: [
            SettingsTile.switchTile(
              switchActiveColor:Colors.black26,
              title: themeProvider.isLightTheme? 'Dark Theme':"Light Theme",
              titleTextStyle: GoogleFonts.openSans(textStyle: TextStyle(color:themeProvider.isLightTheme?clr_black87:clr_white70 , fontSize: 16, fontWeight: FontWeight.w500)),
              leading: Icon(Icons.dark_mode),
              switchValue: isSwitched,

              onToggle: (bool value) {

                setState(() async {

                  await themeProvider.toggleThemeData();
                  isSwitched = value;
                  changeThemeMode(themeProvider.isLightTheme);

                });
              },
            ),
            SettingsTile(
              title: 'Give',
              titleTextStyle: GoogleFonts.openSans(textStyle: TextStyle(color:themeProvider.isLightTheme?clr_black87:clr_white70 , fontSize: 16, fontWeight: FontWeight.w500)),
              subtitle: 'Simple and Secure Givings',
              subtitleTextStyle: GoogleFonts.openSans(textStyle: TextStyle(color:themeProvider.isLightTheme?clr_black45:clr_white54 , fontSize: 12, fontWeight: FontWeight.w500)),
              leading: Icon(Icons.language),
              onPressed: (context){
                _launchURL();
              },
            ),
            SettingsTile(
                titleTextStyle: GoogleFonts.openSans(textStyle: TextStyle(color:themeProvider.isLightTheme?clr_black87:clr_white70 , fontSize: 16, fontWeight: FontWeight.w500)),
                title: 'About us', leading: Icon(Icons.description),
              onPressed: (context){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> About()));
              },
            ),
            SettingsTile(
              titleTextStyle: GoogleFonts.openSans(textStyle: TextStyle(color:themeProvider.isLightTheme?clr_black87:clr_white70 , fontSize: 16, fontWeight: FontWeight.w500)),
              title: 'Request Prayer', leading: Image.asset("assets/images/prayer.png", color: themeProvider.isLightTheme?Colors.grey:clr_white, width: 25.0, height: 25.0,),
              onPressed: (context){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> RequestPrayer()));
              },
            ),
            SettingsTile(
              titleTextStyle: GoogleFonts.openSans(textStyle: TextStyle(color:themeProvider.isLightTheme?clr_black87:clr_white70 , fontSize: 16, fontWeight: FontWeight.w500)),
              title: 'Version',
              subtitle: '2.5.2',
              subtitleTextStyle: GoogleFonts.openSans(textStyle: TextStyle(color:themeProvider.isLightTheme?clr_black45:clr_white54 , fontSize: 12, fontWeight: FontWeight.w500)),
              leading: Icon(Icons.app_settings_alt),
            ),
            SettingsTile(
              titleTextStyle: GoogleFonts.openSans(textStyle: TextStyle(color:themeProvider.isLightTheme?clr_black87:clr_white70 , fontSize: 16, fontWeight: FontWeight.w500)),
              title: 'Sign out', leading: Icon(Icons.exit_to_app),onPressed: (context) async {
              print("sign out button pressed");
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Login(
              )));
            },),

          ],
        ),

      ],
    );
  }
}
