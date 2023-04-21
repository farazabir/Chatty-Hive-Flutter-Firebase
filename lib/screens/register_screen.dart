// ignore_for_file: use_build_context_synchronously

import 'package:chattyhive/helper/helper_function.dart';
import 'package:chattyhive/service/auth/auth_service.dart';
import 'package:chattyhive/service/route/routes_name.dart';
import 'package:flutter/material.dart';

import '../shared/constants.dart';
import '../widgets/widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formkey = GlobalKey<FormState>();

  String fullName = "";
  String email = "";
  String password = "";
  bool _isLoading = false;

  AuthService authService = AuthService();

  register() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailandPassword(fullName, email, password)
          .then((value) async {
        if (value == true) {
          //saving data in shared pref
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUsernameSF(fullName);
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
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(color: Constants.secondary),
              )
            : SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: conWidth / 25,vertical: conHeight/20),
                    child: Form(
                      key: formkey,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              "Chatty Hive",
                              style: TextStyle(
                                  fontSize: 40, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Create your account to chat",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
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
                                labelText: "Full name",
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Constants.secondary,
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  fullName = value;
                                });
                              },

                              //checking validation
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Name can't be empty";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const SizedBox(
                              height: 18,
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
                                  //print(email);
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
                              obscureText: true,
                              decoration: textInputDecotation.copyWith(
                                labelText: "Password",
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Constants.secondary,
                                ),
                              ),
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
                                  // print(email);
                                });
                              },
                            ),
                            SizedBox(
                              height: conHeight / 20,
                            ),
                            InkWell(
                              onTap: () {
                                register();
                              },
                              child: Container(
                                height: conHeight / 14,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Constants.secondary,
                                ),
                                child: const Center(
                                    child: Text(
                                  "Register",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Already have an account ? ",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                ),
                                InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, RoutesName.login);
                                    },
                                    child: const Text(
                                      "Login",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          decoration: TextDecoration.underline),
                                    )),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ]),
                    ),
                  ),
                ),
              ));
  }
}
