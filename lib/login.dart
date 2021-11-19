import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fpg_family_app/helper/colors.dart';
import 'package:fpg_family_app/home_page_screen.dart';
import 'package:fpg_family_app/register.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:provider/provider.dart';

import 'model/theme_model.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscure = true;
  final _auth = FirebaseAuth.instance;
  bool loading = false;
  String? _email = '';
  String? _password = '';
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
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
                      color: themeProvider.isLightTheme?clr_black12.withOpacity(0.001):clr_white12.withOpacity(0.001),
                      boxShadow: [
                        BoxShadow(
                            color: themeProvider.isLightTheme?clr_black12:clr_white12,
                            spreadRadius: 0.22,
                            blurRadius: 0.0),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Theme(
                            data: Theme.of(context)
                                .copyWith(splashColor: Colors.transparent),
                            child: TextField(
                                controller: _emailController,
                                cursorColor: themeProvider.isLightTheme?clr_black87:clr_white70,
                                autofocus: false,
                                style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                        fontSize: 14.0, color: themeProvider.isLightTheme?clr_black87:clr_white70,)),
                                decoration: InputDecoration(
                                  filled: true,
                                  label: Text("Email",
                                      style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                            color: clr_selected_icon,
                                            fontSize: 14),
                                      )),
                                  fillColor: Colors.transparent,
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
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: clr_selected_icon),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                onChanged: (String value) {
                                  setState(() {
                                    _email = value;
                                  });
                                }),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 20.0, bottom: 40.0),
                          child: Theme(
                            data: Theme.of(context)
                                .copyWith(splashColor: Colors.transparent),
                            child: TextField(
                                controller: _passwordController,
                                cursorColor: themeProvider.isLightTheme?clr_black87:clr_white70,
                                autofocus: false,
                                obscureText: _obscure,
                                style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                        fontSize: 14.0, color: themeProvider.isLightTheme?clr_black87:clr_white70)),
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
                                    style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                            color: clr_selected_icon,
                                            fontSize: 14)),
                                  ),
                                  fillColor: Colors.transparent,
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
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: clr_selected_icon),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                onChanged: (String value) {
                                  setState(() {
                                    _password = value;
                                  });
                                }),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (!EmailValidator.validate(_email!, false)) {
                              Fluttertoast.showToast(
                                  msg: "Invalid email",
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
                                UserCredential _newUser =
                                    await _auth.signInWithEmailAndPassword(
                                        email: _emailController.text,
                                        password: _passwordController.text);
                                if (_newUser != null) {
                                  FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(_newUser.user!.uid)
                                      .get()
                                      .then((value) {});
                                  /*  Navigator.pushReplacementNamed(
                                        context, 'navigation');*/

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              HomePageScreen()));
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 18),
                            backgroundColor: clr_selected_icon,
                            shape: RoundedRectangleBorder(
                                // side: BorderSide(color: Color(0xffEE95A7), width: 2),
                                borderRadius: BorderRadius.circular(6)),
                          ),
                          child: Text('Login',
                              style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 30),
                          //alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("New in FPG Family?",
                                  style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: themeProvider.isLightTheme?clr_black45:Colors.white70))),
                              SizedBox(
                                width: 4,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    // Navigator.pushReplacementNamed(context, 'register');

                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Register()));
                                  },
                                  child: Text("Register",
                                      style: GoogleFonts.openSans(
                                          textStyle: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: clr_selected_icon)))),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  GestureDetector(
                      onTap: () async {
                        try {
                          _userCredential = await signInWithGoogle();
                          if (_userCredential != null) {
                            FirebaseFirestore.instance
                                .collection("users")
                                .doc(_auth.currentUser!.uid)
                                .set({
                              "phoneNumber": _userCredential.user!.phoneNumber??"",
                              "email": _userCredential.user!.email,
                              "username": _userCredential.user!.displayName,
                            }, SetOptions(merge: true)).whenComplete(() {});
                            FirebaseFirestore.instance
                                .collection("users")
                                .doc(_userCredential!.user!.uid)
                                .get()
                                .then((value) {});
                            print(_userCredential.user!.displayName);
                             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomePageScreen()));
                          }
                        } catch (e) {
                          print(e.toString());
                          Fluttertoast.showToast(
                              msg: e.toString(),
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: clr_selected_icon,
                              textColor: clr_white,
                              fontSize: 16.0);
                        }
                      },
                      child: Container(
                          width: _width / 1.9,
                          decoration: BoxDecoration(
                              color: themeProvider.isLightTheme?clr_black45:clr_white54,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          padding: EdgeInsets.only(
                              left: 4.0, right: 10.0, top: 4.0, bottom: 4.0),
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/images/google.png",
                                width: 30.0,
                                height: 30.0,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                'Login with Google',
                                style: GoogleFonts.openSans(
                                    textStyle: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ))),
                  SizedBox(
                    height: 10.0,
                  ),
                  GestureDetector(
                      onTap: () async {
                        try {
                          _userCredential = await signInWithFacebook();
                          if (_userCredential != null) {
                            FirebaseFirestore.instance
                                .collection("users")
                                .doc(_auth.currentUser!.uid)
                                .set({
                              "phoneNumber": _userCredential.user!.phoneNumber??"",
                              "email": _userCredential.user!.email,
                              "username": _userCredential.user!.displayName,
                            }, SetOptions(merge: true)).whenComplete(() {});
                            FirebaseFirestore.instance
                                .collection("users")
                                .doc(_userCredential!.user!.uid)
                                .get()
                                .then((value) {});
                            print(_userCredential.user!.displayName);
                             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomePageScreen()));
                          }
                        } catch (e) {
                          print(e.toString());
                          Fluttertoast.showToast(
                              msg: e.toString(),
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: clr_selected_icon,
                              textColor: clr_white,
                              fontSize: 16.0);
                        }
                      },
                      child: Container(
                          width: _width / 1.9,
                          decoration: BoxDecoration(
                              color: Color(0XFF45619D),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          padding: EdgeInsets.only(
                              left: 4.0, right: 10.0, top: 4.0, bottom: 4.0),
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/images/fb.png",
                                width: 30.0,
                                height: 30.0,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                'Login with Facebook',
                                style: GoogleFonts.openSans(
                                    textStyle: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ))),
                  SizedBox(
                    height: 40.0,
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

  late UserCredential _userCredential;

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }
}
