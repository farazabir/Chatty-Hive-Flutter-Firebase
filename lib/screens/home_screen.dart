import 'package:chattyhive/helper/helper_function.dart';
import 'package:chattyhive/service/auth/auth_service.dart';
import 'package:chattyhive/service/database/database_service.dart';
import 'package:chattyhive/service/route/routes_name.dart';
import 'package:chattyhive/shared/constants.dart';
import 'package:chattyhive/widgets/group_tile.dart';
import 'package:chattyhive/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String fullname = "";
  String email = "";
  AuthService authService = AuthService();
  Stream? hives;
  bool _isloading = false;
  String groupName = "";

  @override
  void initState() {
    super.initState();
    gettingUserDetails();
  }

  gettingUserDetails() async {
    await HelperFunctions.getUsernameFromSf().then((value) => {
          setState(() {
            fullname = value!;
          })
        });
    await HelperFunctions.getUserEmailFromSf().then((value) => {
          setState(() {
            email = value!;
          })
        });
    //getting list of snapshots in out stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserHives()
        .then((snapshots) {
      setState(() {
        hives = snapshots;
      });
    });
  }

  popUpDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Create  your own hive",
              textAlign: TextAlign.start,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _isloading == true
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Constants.secondary,
                        ),
                      )
                    : TextField(
                        onChanged: (value) {
                          setState(() {
                            groupName = value;
                          });
                        },
                        decoration: textInputDecotation.copyWith()),
              ],
            ),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Constants.secondary),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("CANCEL")),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Constants.secondary),
                  onPressed: () async {
                    if (groupName != "") {
                      setState(() {
                        _isloading = true;
                      });
                      await DatabaseService(
                              uid: FirebaseAuth.instance.currentUser!.uid)
                          .createGroup(fullname,
                              FirebaseAuth.instance.currentUser!.uid, groupName)
                          .whenComplete(() {
                        setState(() {
                          _isloading = false;
                        });
                        Navigator.pop(context);
                        showSnackBar("Hive Created Successfully",
                            Constants.secondary, context);
                      });
                    }
                  },
                  child: const Text("CREATE")),
            ],
          );
        });
  }

  //string manipulation
  getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  hiveList() {
    return StreamBuilder(
      stream: hives,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != 0) {
              return ListView.builder(
                  itemCount: snapshot.data['groups'].length,
                  itemBuilder: (context, index) {
                    int reverseIndex =
                        snapshot.data['groups'].length - index - 1;
                    return GroupTile(
                        userName: snapshot.data["fullname"],
                        groupId: getId(snapshot.data["groups"][reverseIndex]),
                        groupName:
                            getName(snapshot.data["groups"][reverseIndex]));
                  });
            } else {
              return noHiveWidget();
            }
          } else {
            return noHiveWidget();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Constants.secondary,
            ),
          );
        }
      },
    );
  }

  noHiveWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: InkWell(
              onTap: () {
                popUpDialog(context);
              },
              child: Icon(
                Icons.add_circle,
                color: Constants.disabled,
                size: 80,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text("Click Here To Create Your Own Hive")
        ],
      ),
    );
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
          "H I V E S",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Constants.primary),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, RoutesName.search);
              },
              icon: Icon(
                Icons.search,
                color: Constants.primary,
              )),
        ],
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
              onTap: () {},
              selectedColor: Constants.secondary,
              selected: true,
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
      body: hiveList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialog(context);
        },
        elevation: 0,
        backgroundColor: Constants.secondary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
