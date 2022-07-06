// ignore_for_file: non_constant_identifier_names

import 'package:anyfest/screens/Forgot_password.dart';
import 'package:anyfest/screens/home_screen.dart';
import 'package:anyfest/screens/registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({Key? key}) : super(key: key);

  @override
  _LoginscreenState createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  //formkey
  final _formKey = GlobalKey<FormState>();

//editing controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //firebase
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    //<---------------------------------------------------//email field----------------------------------------------------------->

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
        prefixIcon: const Icon(Icons.mail, color: Colors.teal),
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
//<----------------------------------------------//password field---------------------------------------------------------------->

    final passwordField = TextFormField(
      autofocus: false,
      cursorColor: Colors.teal,
      controller: passwordController,
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
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.vpn_key,
          color: Colors.teal,
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        label: const Text("Password"),
        labelStyle: const TextStyle(color: Colors.teal),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.greenAccent),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
//<----------------------------------------------------// reset password---------------------------------------------------------->

    final reset = Align(
      alignment: Alignment.bottomRight,
      child: TextButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ForgotPass()));
        },
        child: const Text("Forgot Password?"),
      ),
    );
//<--------------------------------------------------//loginbutton------------------------------------------------------------>

    final LoginButton = Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(20),
      color: Colors.blue,
      child: MaterialButton(
        color: Colors.teal.shade400,
        minWidth: 200.0,
        height: 50.0,
        onPressed: () {
          signIn(emailController.text, passwordController.text);
        },
        child: const Text("Login"),
        elevation: 4,
        hoverColor: Colors.green,
      ),
    );
//<-------------------------------------------------------------------------------------------------------------->
    return Scaffold(
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
                    emailField,
                    const SizedBox(height: 20),
                    passwordField,
                    reset,
                    const SizedBox(height: 30),
                    LoginButton,
                    const SizedBox(height: 45),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text("Don't have account ?"),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUp()));
                          },
                          child: const Text(
                            "SignUp",
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
    );
  }

//<----------------------------------------------//login function---------------------------------------------------------------->

  void signIn(String email, String password) async {
    try {
      if (_formKey.currentState!.validate()) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        Fluttertoast.showToast(msg: "login Sucessful");
        Navigator.of(context)
            .pushReplacement(
                MaterialPageRoute(builder: (context) => const HomeScreen()))
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
        });
      }
    } on FirebaseAuthException catch (error) {
      Fluttertoast.showToast(msg: '${error.message}');
    }
  }
}
