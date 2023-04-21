import 'package:chattyhive/helper/helper_function.dart';
import 'package:flutter/material.dart';

import '../service/auth/auth_service.dart';
import '../service/route/routes_name.dart';
import '../shared/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String fullname = "";
  String email = "";
  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  getUserData() async {
    await HelperFunctions.getUsernameFromSf().then((value) {
      setState(() {
        fullname = value!;
      });
    });
    await HelperFunctions.getUserEmailFromSf().then((value) {
      setState(() {
        email = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Constants.primary,
      appBar: AppBar(
        backgroundColor: Constants.secondary,
        title: Text(
          "Profile",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Constants.primary),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      drawer: Drawer(
        backgroundColor: Constants.primary,
        child: ListView(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth / 20, vertical: screenHeight / 10),
          children: <Widget>[
            Icon(
              Icons.account_circle,
              size: 150,
              color: Constants.secondary,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              fullname,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 50,
            ),
            const Divider(
              height: 2,
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, RoutesName.home);
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.group),
              title: Text(
                "Hives",
                style: TextStyle(color: Constants.disabled),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, RoutesName.profile);
              },
              selectedColor: Constants.secondary,
              selected: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.person),
              title: Text(
                "Profile",
                style: TextStyle(color: Constants.disabled),
              ),
            ),
            ListTile(
              onTap: () async {
                authService.logOut().whenComplete(
                    () => Navigator.pushNamed(context, RoutesName.login));
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.exit_to_app),
              title: Text(
                "Logout",
                style: TextStyle(color: Constants.disabled),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.account_circle,
              size: 150,
              color: Constants.secondary,
            ),
            SizedBox(
              height: screenHeight / 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  "Full Name: ",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  fullname,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight / 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  "Email: ",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  email,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
