import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'helper/colors.dart';
import 'model/theme_model.dart';


class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  _launchURL() async {
    const url = 'https://tithe.ly/give_new/www/#/tithely/give-one-time/3317107?widget=1&action=Give%20Online%20Now';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  _launchWebsite() async {
    const url = 'https://fpgchurch.com/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);

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
            'About us',
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
          height: MediaQuery.of(context).size.height,
          color: themeProvider.isLightTheme? clr_white:clr_black,
          child: SizedBox.expand(
            child: Column(
              children: [
                Text("The gospel shall not be censored.  We created FPG Family as a place to hear the preaching of the Word of God.  Every minister is anointed by God to preach and teach the gospel. 24/7 FPG Family is a place to grow in Word and in relationship with the Holy Ghost.  A ministry of Faith Pleases God Church.",style: GoogleFonts.openSans(
                    textStyle: GoogleFonts.openSans(textStyle: TextStyle(
                        color:themeProvider.isLightTheme? clr_black87:clr_white70,
                        fontSize: 18,
                        fontWeight: FontWeight.w400
                    )),/*letterSpacing: 2, wordSpacing: 2.0*/),),
                Spacer(),
                Row(
                  children: [
                    Text("Email:  ",style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color:themeProvider.isLightTheme? clr_black87:clr_white70,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        )),),
                    Text("kevinsortiz@gmail.com",style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color:Colors.blue,
                            decoration: TextDecoration.underline,
                            fontSize: 18,
                            fontWeight: FontWeight.w500
                        )),),

                  ],
                ),
                Row(
                  children: [
                    Text("Contact number:  ",style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color:themeProvider.isLightTheme? clr_black87:clr_white70,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        )),),
                    Text("+1 (956) 412-5600",style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color:themeProvider.isLightTheme? clr_black87:clr_white70,
                            fontSize: 18,
                            fontWeight: FontWeight.w500
                        )),),

                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Church Address:  ",style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color:themeProvider.isLightTheme? clr_black87:clr_white70,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        )),),
                    Flexible(
                      child: Text("Faith Pleases God Church 4501 West Expressway 83 Harlingen, TX 78552",style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color:themeProvider.isLightTheme? clr_black87:clr_white70,
                              fontSize: 18,
                              fontWeight: FontWeight.w500
                          ),
                      ),
                      maxLines: 3,
                      ),
                    ),

                  ],
                ),
                Row(
                  children: [
                    Text("Website:  ",style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color:themeProvider.isLightTheme? clr_black87:clr_white70,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        )),),
                    GestureDetector(
                      onTap: (){
                        _launchWebsite();
                      },
                      child: Text("https://fpgchurch.com",style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color:themeProvider.isLightTheme? Colors.blue:Colors.blue,
                              fontSize: 18,
                              fontWeight: FontWeight.w500
                          )),),
                    ),

                  ],
                ),



              ],
            ),
          ),
        )
    );
  }

}



