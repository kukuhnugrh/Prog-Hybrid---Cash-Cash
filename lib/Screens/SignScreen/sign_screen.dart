import 'package:cashcashproject/Screens/ContentScreen/content_screen.dart';
import 'package:cashcashproject/Screens/WelcomeScreen/components/body.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/already_have_an_account_check.dart';
import 'components/rounded_input_field.dart';
import 'components/rounded_password_field.dart';
import 'components/social_icon.dart';
import 'components/or_divider.dart';

class SignScreen extends StatefulWidget {
  String stateScreen;
  bool login;

  SignScreen({
    Key key,
    this.stateScreen,
    this.login,
  }) : super(key: key);

  @override
  State createState() => SignScreenState();
}

class SignScreenState extends State<SignScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailInputController;
  TextEditingController pwdInputController;

  @override
  void initState() {
    // TODO: implement initState
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    super.initState();
  }

  void signScreenChange(){
    setState(() {
      widget.login ? widget.stateScreen = "DAFTAR" : widget.stateScreen = "LOGIN";
      widget.login ? widget.login = false : widget.login = true;
    });
  }

  Future<FirebaseUser> googleSignIn() async{
    GoogleSignInAccount gsiacc = await GoogleSignIn().signIn();
    GoogleSignInAuthentication gsiauth = await gsiacc.authentication;

    AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: gsiauth.idToken,
      accessToken: gsiauth.accessToken
    );

    FirebaseUser user = (await FirebaseAuth.instance.signInWithCredential(credential)).user;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('stringValue', user.uid.toString());

    return user;
  }

  void _register() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String uid = user.uid.toString();
    print("register");
    print(_formKey.currentState.validate());
    if(_formKey.currentState.validate()){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('stringValue', user.uid.toString());
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailInputController.text,
          password: pwdInputController.text
      ).then((currentUser) => Firestore.instance
          .collection("users")
          .document(uid)
          .setData({
        "uid": uid,
        "email": emailInputController.text,
        "pwd": pwdInputController.text,
      }).then((result) => {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ContentScreen();
              },
            ),
          ),
        emailInputController.clear(),
        pwdInputController.clear(),
        },
      ));
    }
  }

  void _login() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String uid = user.uid.toString();
    print(pwdInputController.text);
    if(_formKey.currentState.validate()){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('stringValue', user.uid.toString());
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailInputController.text,
        password: pwdInputController.text)
          .then((currentUSer) => Firestore.instance
          .collection("users")
          .document(uid)
          .get()
          .then((DocumentSnapshot result) =>
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return ContentScreen();
                },
              ),
            ),
          ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/images/cashcash_logo.png",
                ),
                SizedBox(height: 20),
                Text(
                  "SALAMAT DATANG DI CASH CASH",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  widget.stateScreen,
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(height: 120),
                RoundedInputField(
                  hintText: "Masukkan Email Anda",
                  icon: Icons.person,
                  emailInputController: emailInputController,
                ),
                SizedBox(height: 20),
                RoundedPasswordField(
                ),
                SizedBox(height: 80),
                RoundedButton(
                  text: widget.stateScreen,
                  press: () async {
                    widget.login ? _register() : _login();
                  },
                ),
                SizedBox(height: 20),
                AlreadyHaveAnAccountCheck(
                  login: widget.login,
                  press: () {
                    signScreenChange();
                  },
                ),
                OrDivider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SocialIcon(
                      iconSrc: "assets/images/google_logo.png",
                      press: () {
                        googleSignIn().then((FirebaseUser user){
                          setState(() {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ContentScreen();
                                },
                              ),
                            );
                          });
                        }).catchError((e)=>print(e.toString()));
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}