import 'package:chattyhive/service/auth/auth_service.dart';
import 'package:chattyhive/service/database/database_service.dart';
import 'package:chattyhive/service/route/routes_name.dart';
import 'package:chattyhive/shared/constants.dart';
import 'package:chattyhive/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../helper/helper_function.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
  
}



class _LoginScreenState extends State<LoginScreen> {
  final formkey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool obscureText = true;
  bool _isLoading = false;

  AuthService authService = AuthService();


  login() async {
     if (formkey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .loginUserwithEmailandPassword( email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot = await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).gettingUserData(email);
          
          //saving data in shared pref
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUsernameSF(
            snapshot.docs[0]['fullname']
          );
          // ignore: use_build_context_synchronously
          Navigator.pushNamed(context, RoutesName.home);
        } else {
          showSnackBar(value, Constants.error, context);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final conHeight = MediaQuery.of(context).size.height;
    final conWidth = MediaQuery.of(context).size.height;
    return Scaffold(
        body: _isLoading ? Center(child: CircularProgressIndicator(color: Constants.secondary),): SafeArea( 
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: conWidth / 25, vertical: conHeight / 20),
          child: Form(
            key: formkey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Chatty Hive",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Login not the join the hive!",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  Container(
                    height: conHeight / 3,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('images/img1.png'),
                          fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(
                    height: conHeight / 18,
                  ),
                  TextFormField(
                    decoration: textInputDecotation.copyWith(
                      labelText: "Email",
                      prefixIcon: Icon(
                        Icons.email,
                        color: Constants.secondary,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },

                    //checking validation
                    validator: (value) {
                      return RegExp(
                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                              .hasMatch(value!)
                          ? null
                          : "Please enter a valid email";
                    },
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  TextFormField(
                    obscureText: obscureText,
                    decoration: textInputDecotation.copyWith(
                        labelText: "Password",
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Constants.secondary,
                        ),
                        suffixIconColor: Constants.secondary,
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                            icon: Icon(obscureText?  Icons.visibility:Icons.visibility_off))),
                    validator: (value) {
                      if (value!.length < 6) {
                        return "Password Must Be 6 Character";
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      setState(() {
                        password = value;
                        //  print(email);
                      });
                    },
                  ),
                  SizedBox(
                    height: conHeight / 20,
                  ),
                  InkWell(
                    onTap: () {
                      login();
                    },
                    child: Container(
                      height: conHeight / 14,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Constants.secondary,
                      ),
                      child: const Center(
                          child: Text(
                        "Login",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, RoutesName.register);
                        },
                        child: const Text(
                          "Register here",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,)
                    ],
                  )
                ]),
          ),
        ),
      ),
    ));
  }

 
}
