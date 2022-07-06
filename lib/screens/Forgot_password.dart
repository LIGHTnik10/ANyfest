// ignore_for_file: file_names

import 'package:anyfest/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({Key? key}) : super(key: key);

  @override
  _ForgotPassState createState() => _ForgotPassState();
}

//editing controller
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

//firebase

class _ForgotPassState extends State<ForgotPass> {
  //<------------------------------------------//email field-------------------------------------------------------------------->

  final emailField = TextFormField(
    autofocus: false,
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
      prefixIcon: const Icon(Icons.mail),
      label: const Text("Email"),
      contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      hintText: "Enter your register Email",
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
//<-------------------------------------------------------------------------------------------------------------->
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Reset-Password",
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.2,
      ),
//<-----------------------------------------MAIN BODY--------------------------------------------------------------------->
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(36.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 50,
              ),
              Form(key: _formKey, child: emailField),
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    passReset(context);
                  },
                  child: const Text("Reset"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//<---------------------------------------//RESSITING PASSWORD THROUGH EMAIL LINK----------------------------------------------------------------------->
  //formkey
  final _formKey = GlobalKey<FormState>();
  passReset(BuildContext context) async {
    try {
      if (_formKey.currentState!.validate()) {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: emailController.text);

        Fluttertoast.showToast(msg: "Password reset send to your email");
        Navigator.of(context)
            .pushReplacement(
                MaterialPageRoute(builder: (context) => const Loginscreen()))
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
        });
      }
    } on FirebaseAuthException catch (error) {
      Fluttertoast.showToast(msg: '${error.message}');
    }
  }
}
