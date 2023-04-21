import 'package:chattyhive/helper/helper_function.dart';
import 'package:chattyhive/service/route/routes.dart';
import 'package:chattyhive/service/route/routes_name.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    getLoggedInStatus();
  }

  getLoggedInStatus() async {
    await HelperFunctions.getLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isLoggedIn = value;

          log(_isLoggedIn.toString());
        });
      }
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool?>(
      future: HelperFunctions.getLoggedInStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          bool isLoggedIn = snapshot.data ?? false;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: isLoggedIn ? RoutesName.home : RoutesName.login,
            onGenerateRoute: Routes.generateRoutes,
          );
        }
      },
    );
  }
}
