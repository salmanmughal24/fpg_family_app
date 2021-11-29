import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fpg_family_app/helper/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'model/theme_model.dart';

class RequestPrayer extends StatefulWidget {
  const RequestPrayer({Key? key}) : super(key: key);

  @override
  _RequestPrayerState createState() => _RequestPrayerState();
}

class _RequestPrayerState extends State<RequestPrayer> {
  GlobalKey<FormState> formKey = GlobalKey();
/*  String _currentSelectedValue = "";
  var _prayercategories = [
    "Addiction",
    "Anxiety/Stress",
    "Career/Job",
    "Grief/Loss",
    "Current Events",
    "Decision/Direction",
    "Depression/Suicidal Thoughts",
    "Family/Friends Relationship",
    "Finances",
    "God Will's",
    "Health/Heelings",
    "Praise Report",
    "Protection/Safety",
    "Marriage/Dating",
    "Salvation/Rededication",
    "Spirtual Growth",
    "",
  ];*/

  TextEditingController _emailController = TextEditingController();
  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _prayerRequestController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  _launchURL() async {
    const url = 'https://tithe.ly/give_new/www/#/tithely/give-one-time/3317107?widget=1&action=Give%20Online%20Now';
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
      backgroundColor: themeProvider.isLightTheme ? clr_white : clr_black,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: clr_selected_icon,
        /*   backgroundColor: themeProvider.isLightTheme
            ? Colors.white
            : clr_black,*/
        title: Text(
          'Request Prayer',
          style: TextStyle(
              color: Colors.white,
              /*  color: themeProvider.isLightTheme
              ? Colors.black87
              : Colors.white,*/
              fontSize: 17,
              fontWeight: FontWeight.w700),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              _launchURL();
            },
            child: Center(
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    padding:
                        EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        border: Border.all(
                          color: Colors.green,
                        )),
                    child: Text(
                      "GIVE",
                      style: TextStyle(color: Colors.white),
                    ))),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: themeProvider.isLightTheme
              ? clr_black12.withOpacity(0.001)
              : clr_white12.withOpacity(0.1),
          boxShadow: [
            BoxShadow(
                color: Colors.black12, spreadRadius: 0.2, blurRadius: 0.0),
          ],
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(splashColor: Colors.transparent),
                    child: TextFormField(
                      controller: _emailController,
                      cursorColor: themeProvider.isLightTheme
                          ? clr_black87
                          : clr_white,
                      //   autovalidate: false,
                      //validator: emailValidator,
                      autofocus: false,
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 14.0,
                              color: themeProvider.isLightTheme
                                  ? clr_black87
                                  : clr_white)),
                      decoration: InputDecoration(
                        filled: true,
                        label: Text("Email",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: clr_selected_icon, fontSize: 14),
                            )),
                        fillColor: Colors.transparent,
                        //   errorStyle: TextStyle(color: Colors.red),
                        //  errorText: _email! =='' ? 'Phone number/Email is required' : _email!.contains('@')?null:'Invalid email',

                        contentPadding: const EdgeInsets.only(
                            left: 14.0, bottom: 12.0, top: 0.0, right: 2.0),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: clr_selected_icon),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: clr_selected_icon),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: clr_selected_icon),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(splashColor: Colors.transparent),
                    child: TextFormField(
                      controller: _firstnameController,
                      cursorColor: themeProvider.isLightTheme
                          ? clr_black87
                          : clr_white,
                      //   autovalidate: false,

                      validator: (text) {
                        if (text!.isEmpty) {
                          return "Please Enter Your first name";
                        } else if (text.length < 2) {
                          return "Please Enter Correct first name";
                        } else {
                          return null;
                        }
                      },
                      //validator: emailValidator,
                      autofocus: false,
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 14.0,
                              color: themeProvider.isLightTheme
                                  ? clr_black87
                                  : clr_white)),
                      decoration: InputDecoration(
                        hintText: "john",
                        hintStyle: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 14.0,
                                color: themeProvider.isLightTheme
                                    ? clr_black
                                    : clr_white)),
                        filled: true,
                        label: Text("First Name",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: clr_selected_icon, fontSize: 14),
                            )),
                        fillColor: Colors.transparent,
                        //   errorStyle: TextStyle(color: Colors.red),
                        //  errorText: _email! =='' ? 'Phone number/Email is required' : _email!.contains('@')?null:'Invalid email',

                        contentPadding: const EdgeInsets.only(
                            left: 14.0, bottom: 12.0, top: 0.0, right: 2.0),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: clr_selected_icon),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: clr_selected_icon),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: clr_selected_icon),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(splashColor: Colors.transparent),
                    child: TextFormField(
                      controller: _lastnameController,
                      cursorColor: themeProvider.isLightTheme
                          ? clr_black87
                          : clr_white,
                      //   autovalidate: false,

                      validator: (text) {
                        if (text!.isEmpty) {
                          return "Please Enter Your last name";
                        } else if (text.length < 2) {
                          return "Please Enter Correct last name";
                        } else {
                          return null;
                        }
                      },
                      //validator: emailValidator,
                      autofocus: false,
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 14.0,
                              color: themeProvider.isLightTheme
                                  ? clr_black87
                                  : clr_white)),
                      decoration: InputDecoration(
                        hintText: "Wick",
                        hintStyle: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 14.0,
                                color: themeProvider.isLightTheme
                                    ? clr_black
                                    : clr_white)),
                        filled: true,
                        label: Text("Last Name",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: clr_selected_icon, fontSize: 14),
                            )),
                        fillColor: Colors.transparent,
                        //   errorStyle: TextStyle(color: Colors.red),
                        //  errorText: _email! =='' ? 'Phone number/Email is required' : _email!.contains('@')?null:'Invalid email',

                        contentPadding: const EdgeInsets.only(
                            left: 14.0, bottom: 12.0, top: 0.0, right: 2.0),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: clr_selected_icon),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: clr_selected_icon),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: clr_selected_icon),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(splashColor: Colors.transparent),
                    child: TextFormField(
                      controller: _prayerRequestController,textAlignVertical: TextAlignVertical.top,
                      cursorColor: themeProvider.isLightTheme
                          ? clr_black87
                          : clr_white,
                      //   autovalidate: false,

                      validator: (text) {
                        if (text!.isEmpty) {
                          return "Please Enter Your prayer request";
                        } else {
                          return null;
                        }
                      },
                      //validator: emailValidator,
                      autofocus: false,minLines: 10,maxLines: 20,
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 14.0,
                              color: themeProvider.isLightTheme
                                  ? clr_black87
                                  : clr_white)),
                      decoration: InputDecoration(
                        hintText: "",
                        hintStyle: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 14.0,
                                color: themeProvider.isLightTheme
                                    ? clr_black
                                    : clr_white)),
                        filled: true,
                        label: Text("Prayer Request",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: clr_selected_icon, fontSize: 14),
                            )),
                        fillColor: Colors.transparent,
                        //   errorStyle: TextStyle(color: Colors.red),
                        //  errorText: _email! =='' ? 'Phone number/Email is required' : _email!.contains('@')?null:'Invalid email',

                        contentPadding: const EdgeInsets.only(
                            left: 14.0, bottom: 12.0, top: 12.0, right: 2.0),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: clr_selected_icon),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: clr_selected_icon),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: clr_selected_icon),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ),
                ),
               /* SizedBox(
                  height: 20.0,
                ),
                FormField<String>(
                  builder: (FormFieldState<String> state) {
                    return InputDecorator(


                      decoration: InputDecoration(
                          labelStyle:
                           GoogleFonts.poppins(
                      textStyle: TextStyle(
                      color: clr_selected_icon, fontSize: 14),
                    ),
                          errorStyle: TextStyle(
                              color: Colors.redAccent, fontSize: 16.0),
                          hintText: 'Please select category',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            borderSide: BorderSide(color: clr_selected_icon),
                          ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: BorderSide(color: clr_selected_icon),
                      ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide: BorderSide(color: clr_selected_icon),
                        )
                      ),
                      isEmpty: _currentSelectedValue == '',
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _currentSelectedValue,
                          iconDisabledColor: clr_selected_icon,
                          iconEnabledColor:clr_selected_icon ,
                          isDense: true,
                          onChanged: (newValue) {
                            setState(() {
                              _currentSelectedValue = newValue!;
                              state.didChange(newValue);
                            });
                          },
                          items: _prayercategories.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style:   GoogleFonts.poppins(
                              textStyle: TextStyle(
                              color: clr_selected_icon, fontSize: 14),
                            ),),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),*/
                SizedBox(
                  height: 40.0,
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) {
                        return;
                      } else if (!EmailValidator.validate(
                          _emailController.text!, false)) {
                        Fluttertoast.showToast(
                            msg: "Invalid Email",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: clr_selected_icon,
                            textColor: clr_white,
                            fontSize: 16.0);
                      } else {
                        try {
                          if (_auth.currentUser != null) {
                            FirebaseFirestore.instance
                                .collection("prayers")
                                .add({
                              "uid": _auth.currentUser!.uid,
                              "time": DateTime.now(),
                              "first_name": _firstnameController.text,
                              "last_name": _lastnameController.text,
                              "email": _emailController.text,
                              "prayer_request": _prayerRequestController.text,
                          //    "category": _currentSelectedValue,
                            }).whenComplete(() => Fluttertoast.showToast(
                                msg: "Request submitted",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: clr_selected_icon,
                                textColor: clr_white,
                                fontSize: 16.0));

                            setState(() {
                              _prayerRequestController.text = "";
                              _firstnameController.text = "";
                              _lastnameController.text = "";
                              _emailController.text = "";
                           //   _currentSelectedValue = "";
                            });
                            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomePageScreen()));
                          } else {
                            Fluttertoast.showToast(
                                msg: "No user found",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: clr_selected_icon,
                                textColor: clr_white,
                                fontSize: 16.0);
                            print("New User is null");
                          }
                        } on FirebaseAuthException catch (e) {
                          Fluttertoast.showToast(
                              msg: e.message!,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: clr_selected_icon,
                              textColor: clr_white,
                              fontSize: 16.0);
                        }
                      }
                    },
                    style: TextButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 18),
                      backgroundColor: clr_selected_icon,
                      shape: RoundedRectangleBorder(
                          // side: BorderSide(color: Color(0xffEE95A7), width: 2),
                          borderRadius: BorderRadius.circular(6)),
                    ),
                    child: Text('Submit',
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
