import 'package:chat/models/usermodel.dart';
import 'package:chat/services/auth.dart';
import 'package:chat/services/database.dart';
import 'package:chat/views/chatroomscreen.dart';
import 'package:chat/views/signin.dart';
import 'package:chat/widgets/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEdittingController =
      new TextEditingController();
  TextEditingController emailTextInputController = new TextEditingController();
  TextEditingController passwordInputController = new TextEditingController();
  AuthMethods authMethods = new AuthMethods();

  DatabaseReference ref = FirebaseDatabase.instance.reference();

  void registerNewUser(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      var username = userNameTextEdittingController.text;
      var email = emailTextInputController.text;
      var password = passwordInputController.text;
      UserModel userModel = new UserModel(username, email, password);

      final User? fUser = (await _auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;
      if (fUser != null) {
        final scaffold = ScaffoldMessenger.of(context);
        scaffold.showSnackBar(
          SnackBar(
            content: Text('Sign Up'),
            action: SnackBarAction(
                label: 'register successfully',
                onPressed: scaffold.hideCurrentSnackBar),
          ),
        );

        // save user to database
        userModel.setUserId = fUser.uid;
        saveUserToDatabase(userModel);
        Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => ChatRoom(),
          ),
          (route) => false, //if you want to disable back feature set to false
        );
      } else {
        // error occured - display error msg
        final scaffold = ScaffoldMessenger.of(context);
        scaffold.showSnackBar(
          SnackBar(
            content: Text('Sign Up'),
            action: SnackBarAction(
                label: 'register failed',
                onPressed: scaffold.hideCurrentSnackBar),
          ),
        );
      }
    }
  }

  void saveUserToDatabase(UserModel user) {
    var userInfo = {
      "id": user.getUserId,
      "username": user.getUsername,
      "email": user.getEmail,
      "password": user.getPassword
    };
    ref.child("Users").child(user.getUserId).set(userInfo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60), child: appBarMain(context)),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          alignment: Alignment.bottomCenter,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                      validator: (val) {
                        if (val!.isEmpty || val.length < 2) {
                          return "Please provide username";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      controller: userNameTextEdittingController,
                      style: simpleTextFieldStyle(),
                      decoration: textFieldInputDecoration("username")),
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
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      controller: passwordInputController,
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
                registerNewUser(context);
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
                  "Sign Up",
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(vertical: 20),
              padding: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    const Color(0xff007ef4),
                    const Color(0xff2a75bc)
                  ]),
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
                "Sign Up with Google",
                style: TextStyle(color: Colors.black87, fontSize: 13),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have account?",
                    style: TextStyle(fontSize: 14, color: Colors.white)),
                GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil<dynamic>(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) => SignIn(),
                        ),
                        (route) =>
                            false, //if you want to disable back feature set to false
                      );
                    },
                    child: Container(
                      child: Text("Login now",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              decoration: TextDecoration.underline)),
                    )),
              ],
            ),
            SizedBox(height: 50)
          ]),
        ),
      ),
    );
  }
}
