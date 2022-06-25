import 'package:chat/models/usermodel.dart';
import 'package:chat/services/auth.dart';
import 'package:chat/views/chatroomscreen.dart';
import 'package:chat/views/signup.dart';
import 'package:chat/widgets/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  AuthMethods authMethods = new AuthMethods();
  TextEditingController emailTextInputController = new TextEditingController();
  TextEditingController passwordTextInputController =
      new TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  /*
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (auth.currentUser != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ChatRoom()));
    }
  }*/

  Login(String email, String password) async {
    if (formKey.currentState!.validate()) {
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password)
            .then((value) {
          Navigator.pushAndRemoveUntil<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => ChatRoom(),
            ),
            (route) => false, //if you want to disable back feature set to false
          );
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60), child: appBarMain(context)),
      body: SingleChildScrollView(
        child: Container(
          key: formKey,
          padding: EdgeInsets.symmetric(horizontal: 24),
          alignment: Alignment.bottomCenter,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Please provide an email address";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      controller: emailTextInputController,
                      style: simpleTextFieldStyle(),
                      decoration: textFieldInputDecoration("email")),
                  TextFormField(
                      validator: (val) {
                        if (val!.length < 6) {
                          return "Please provide password 6+ character";
                        }
                        return null;
                      },
                      obscureText: true,
                      keyboardType: TextInputType.multiline,
                      controller: passwordTextInputController,
                      decoration: textFieldInputDecoration("password"),
                      style: simpleTextFieldStyle()),
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              alignment: Alignment.topRight,
              child: Text(
                "forgot password",
                style: simpleTextFieldStyle(),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            GestureDetector(
              onTap: () {
                var email = emailTextInputController.text;
                var password = passwordTextInputController.text;
                Login(email, password);
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      const Color(0xff007ef4),
                      const Color(0xff2a75bc)
                    ]),
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                  "Sign In",
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(vertical: 15),
              padding: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    const Color(0xff007ef4),
                    const Color(0xff2a75bc)
                  ]),
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
                "Sign In with Google",
                style: TextStyle(color: Colors.black87, fontSize: 13),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have account? ",
                    style: TextStyle(fontSize: 14, color: Colors.white)),
                GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil<dynamic>(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) => SignUp(),
                      ),
                      (route) =>
                          false, //if you want to disable back feature set to false
                    );
                  },
                  child: Container(
                    child: Text("Register now",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            decoration: TextDecoration.underline)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 50)
          ]),
        ),
      ),
    );
  }
}
