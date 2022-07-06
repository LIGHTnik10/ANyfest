// ignore_for_file: unnecessary_new

import 'package:anyfest/model/user_model.dart';
import 'package:anyfest/screens/home_screen.dart';
import 'package:anyfest/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  //
  final _auth = FirebaseAuth.instance;
  //form_key
  final _formKey = GlobalKey<FormState>();

  //editing controller
  final firstNameEditingController = new TextEditingController();

  final emailController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmPasswordEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    //<-------------------------------------------------------------------------------------------------------------->
    //first name field
    final firstNameField = TextFormField(
      cursorColor: Colors.teal,
      autofocus: false,
      controller: firstNameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regEx =
            RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");
        if (value!.isEmpty) {
          return ("Please Enter your Name");
        }

        if (!regEx.hasMatch(value)) {
          return ("Please enter your validate and full name ");
        }
        return null;
      },
      onSaved: (value) {
        firstNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon:
            const Icon(Icons.account_circle_outlined, color: Colors.teal),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        label: const Text("Name"),
        hintText: "Name LastName",
        labelStyle: const TextStyle(color: Colors.teal),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.greenAccent),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

//<--------------------------------------------------//email field------------------------------------------------------------>

    final emailField = TextFormField(
      autofocus: false,
      cursorColor: Colors.teal,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter your Email");
        }
        //reg expression for email validation
        if (!RegExp(
                r"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-zA-Z0-9][a-zA-Z0-9-]{0,253}\.)*[a-zA-Z0-9][a-zA-Z0-9-]{0,253}\.[a-zA-Z0-9]{2,}$")
            .hasMatch(value)) {
          return ("Please Enter a valid Email");
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.mail_outline, color: Colors.teal),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        label: const Text("Email"),
        labelStyle: const TextStyle(color: Colors.teal),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.greenAccent),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
//<------------------------------------------------------//password field-------------------------------------------------------->

    final passwordField = TextFormField(
      autofocus: false,
      cursorColor: Colors.teal,
      controller: passwordEditingController,
      obscureText: true,
      validator: (value) {
        RegExp regEx = RegExp(r"[0-9a-zA-Z]{6,}");
        if (value!.isEmpty) {
          return ("Password is required for login");
        }
        if (!regEx.hasMatch(value)) {
          return ("Please enter 6 digit Valid Password");
        }
      },
      onSaved: (value) {
        passwordEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.vpn_key_outlined, color: Colors.teal),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        label: const Text("password"),
        labelStyle: const TextStyle(color: Colors.teal),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.greenAccent),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
//<---------------------------------------//confirm-password field----------------------------------------------------------------------->

    final confirmpasswordField = TextFormField(
      autofocus: false,
      cursorColor: Colors.teal,
      controller: confirmPasswordEditingController,
      obscureText: true,
      validator: (value) {
        if (confirmPasswordEditingController.text !=
            passwordEditingController.text) {
          return "password dont match";
        }
        return null;
      },
      onSaved: (value) {
        passwordEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.vpn_key_outlined, color: Colors.teal),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        label: const Text("Confirm Password"),
        labelStyle: const TextStyle(color: Colors.teal),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.greenAccent),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
//<--------------------------------------------------//SignUpbutton------------------------------------------------------------>

    // ignore: non_constant_identifier_names
    final SignUpButton = Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(20),
      color: Colors.blue,
      child: MaterialButton(
        color: Colors.teal,
        minWidth: 200.0,
        height: 50.0,
        onPressed: () {
          signUp(emailController.text, passwordEditingController.text);
        },
        child: const Text("SignUp"),
        elevation: 4,
        hoverColor: Colors.green,
      ),
    );
//<-------------------------------------------------------------------------------------------------------------->
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 10),
                      firstNameField,
                      const SizedBox(height: 10),
                      emailField,
                      const SizedBox(height: 10),
                      passwordField,
                      const SizedBox(height: 10),
                      confirmpasswordField,
                      const SizedBox(height: 30),
                      SignUpButton,
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text("Already have account ?"),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const Loginscreen()));
                            },
                            child: const Text(
                              "LogIn",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 15),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

//<------------------------------------------//SIGNUP WITH EMAIL AND PASSWORD FIREBASE AUTHENTICATION-------------------------------------------------------------------->

  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFirestore()})
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

//<----------------------------------------------//POSTING USER DETAILS TO FIREBASE FIRESTORE---------------------------------------------------------------->

  postDetailsToFirestore() async {
    //calling firestore
    //calling user model
    //setting these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    UserModel userModel = UserModel();
    //writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.firstName = firstNameEditingController.text;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created sucessfully");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false);
  }
}
