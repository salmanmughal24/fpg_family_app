import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fpg_family_app/helper/colors.dart';
import 'dart:ui';

import 'package:fpg_family_app/home_page_screen.dart';
import 'package:fpg_family_app/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'model/theme_model.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _auth = FirebaseAuth.instance;
  bool loading = false;
  String? _email = '';
  String? _password = '';
  String? _name = '';
  String? _number= '';
  bool _obscure = true;
  GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.isLightTheme
          ? clr_white
          : clr_black,
      resizeToAvoidBottomInset: false,

      body: Stack(
        children: [
          Container(
            width: _width,
            height: _height,
            child: SingleChildScrollView(
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Hero(
                    tag: 'logo',
                    child: Container(
                        margin: EdgeInsets.only(top: 50.0, bottom: 0.0),
                        width: _width / 1.8,
                        height: _height / 3,
                        child: Image.asset(
                          "assets/logo.png",
                        )),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 50),
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: themeProvider.isLightTheme?clr_black12.withOpacity(0.001):clr_white12.withOpacity(0.1),

                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            spreadRadius: 0.2,
                            blurRadius: 0.0),
                      ],
                    ),
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
                                cursorColor: themeProvider.isLightTheme?clr_black87:clr_white70,
                                //   autovalidate: false,
                                onChanged: (String value) {
                                  setState(() {
                                    _email = value;
                                  });
                                },
                                //validator: emailValidator,
                                autofocus: false,
                                style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 14.0, color: themeProvider.isLightTheme?clr_black87:clr_white70)),
                                decoration: InputDecoration(
                                  filled: true,
                                  label: Text(
                                      "Email",
                                      style: GoogleFonts.openSans(textStyle: TextStyle(
                                          color: clr_selected_icon, fontSize: 14),)
                                  ),
                                  fillColor: Colors.transparent,
                                  //   errorStyle: TextStyle(color: Colors.red),
                                  //  errorText: _email! =='' ? 'Phone number/Email is required' : _email!.contains('@')?null:'Invalid email',

                                  contentPadding: const EdgeInsets.only(
                                      left: 14.0,
                                      bottom: 12.0,
                                      top: 0.0,
                                      right: 2.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: clr_selected_icon),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: clr_selected_icon),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: clr_selected_icon),
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
                            padding: const EdgeInsets.only(top:20.0),
                            child: Theme(
                              data: Theme.of(context)
                                  .copyWith(splashColor: Colors.transparent),
                              child: TextFormField(
                                controller: _usernameController,
                                cursorColor: themeProvider.isLightTheme?clr_black87:clr_white70,
                                //   autovalidate: false,
                                onChanged: (String value) {
                                  _name = value;
                                },
                                validator: (text) {
                                  if (text!.isEmpty) {
                                    return "Please Enter Your Username";
                                  } else if (text.length < 2) {
                                    return "Please Enter Correct Username";
                                  } else {
                                    return null;
                                  }
                                },
                                //validator: emailValidator,
                                autofocus: false,
                                style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 14.0, color:themeProvider.isLightTheme?clr_black87:clr_white70)),
                                decoration: InputDecoration(
                                  hintText: "john",
                                  hintStyle: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 14.0, color: themeProvider.isLightTheme?clr_black45:clr_white54)),
                                  filled: true,
                                  label: Text(
                                      "Username",
                                      style: GoogleFonts.openSans(textStyle: TextStyle(
                                          color: clr_selected_icon, fontSize: 14),)
                                  ),
                                  fillColor: Colors.transparent,
                                  //   errorStyle: TextStyle(color: Colors.red),
                                  //  errorText: _email! =='' ? 'Phone number/Email is required' : _email!.contains('@')?null:'Invalid email',

                                  contentPadding: const EdgeInsets.only(
                                      left: 14.0,
                                      bottom: 12.0,
                                      top: 0.0,
                                      right: 2.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: clr_selected_icon),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: clr_selected_icon),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: clr_selected_icon),
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
                            padding:
                                const EdgeInsets.only(top: 20.0, bottom: 40.0),
                            child: Theme(
                              data: Theme.of(context)
                                  .copyWith(splashColor: Colors.transparent),
                              child: TextFormField(
                                controller: _passwordController,
                                cursorColor: themeProvider.isLightTheme?clr_black87:clr_white70,
                                autofocus: false,
                                onChanged: (value) {
                                  _password = value;
                                },
                                obscureText: _obscure,
                                style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 14.0, color: themeProvider.isLightTheme?clr_black87:clr_white70)),
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscure == true
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: clr_selected_icon,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      print(_obscure);
                                      setState(() {
                                        if (_obscure == true) {
                                          _obscure = false;
                                        } else
                                          _obscure = true;
                                      });
                                    },
                                  ),
                                  filled: true,
                                  label: Text(
                                      "Password",
                                      style: GoogleFonts.openSans(textStyle: TextStyle(
                                          color: clr_selected_icon, fontSize: 14),)
                                  ),
                                  fillColor: Colors.transparent,
                                  // errorStyle: TextStyle(color: Colors.red),
                                  //   errorText: _password! =='' ? 'Password is required' : _password!.length < 8 ?"Password is short (min 8 digits)":null,
                                  contentPadding: const EdgeInsets.only(
                                      left: 14.0,
                                      bottom: 12.0,
                                      top: 0.0,
                                      right: 2.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: clr_selected_icon),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: clr_selected_icon),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: clr_selected_icon),
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
                          ElevatedButton(
                              onPressed: () async {
                                if (!formKey.currentState!.validate()) {
                                  return;
                                }
                                else if (!EmailValidator.validate(_email!, false)) {
                                  Fluttertoast.showToast(
                                      msg: "Invalid Email",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: clr_selected_icon,
                                      textColor: clr_white,
                                      fontSize: 16.0);
                                } else if (_password!.length < 8) {
                                  Fluttertoast.showToast(
                                      msg: "Password is short (8 digits)",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: clr_selected_icon,
                                      textColor: clr_white,
                                      fontSize: 16.0);
                                } else {
                                  try {
                                    setState(() => loading = true);
                                    UserCredential _newUser = await _auth
                                        .createUserWithEmailAndPassword(
                                            email: _emailController.text,
                                            password: _passwordController.text,);
                                    if (_newUser != null) {
                                      FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(_auth.currentUser!.uid)
                                          .set({
                                               "email": _emailController.text,
                                        "username": _usernameController.text,

                                      }, SetOptions(merge: true)).whenComplete(() {
                                      });
                                      FirebaseFirestore.instance.collection("users").doc(_newUser!.user!.uid).get().then((value){


                                      });
                                     /* Navigator.pushReplacementNamed(
                                          context, 'navigation');*/

                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomePageScreen()));
                                    } else {
                                      setState(() => loading = false);
                                      print("New User is null");
                                    }
                                  } on FirebaseAuthException catch (e) {
                                    setState(() => loading = false);
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
                              child: Text('Register',style: GoogleFonts.openSans(textStyle: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold) ))),
                          Padding(
                            padding: EdgeInsets.only(top: 30),
                            //alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Already have an account?",
                                    style: GoogleFonts.openSans(textStyle: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: themeProvider.isLightTheme?clr_black45:Colors.white70))),
                                SizedBox(
                                  width: 4,
                                ),
                                GestureDetector(
                                    onTap: () {
                                      /*Navigator.pushReplacementNamed(
                                          context, 'login');*/

                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Login()));
                                    },
                                    child: Text("Login",
                                        style: GoogleFonts.openSans(textStyle: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: clr_selected_icon)))),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          loading == true ? Loading() : Container(),
        ],
      ),
    );
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Center(
          child: CircularProgressIndicator(
            color: clr_selected_icon,
            strokeWidth: 5.0,
          ),
        ),
      ),
    );
  }
}
