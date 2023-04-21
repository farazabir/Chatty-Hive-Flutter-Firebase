import 'package:chattyhive/helper/helper_function.dart';
import 'package:chattyhive/screens/chat_screen.dart';
import 'package:chattyhive/service/database/database_service.dart';
import 'package:chattyhive/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../shared/constants.dart';
import 'dart:developer';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchController = TextEditingController();
  bool _isloading = false;
  QuerySnapshot? searchSnapshot;
  bool _hasUserSearch = false;
  String userName = "";
  // ignore: unused_field
  bool _isJoined = false;
  User? user;

  String getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  userJoinedorNot(
      String userName, String groupId, String groupName, String admin) async {
    await DatabaseService(uid: user!.uid)
        .isUserJoined(groupName, groupId, userName)
        .then((value) {
      setState(() {
        _isJoined = value;
        log(value.toString());
      });
    });
  }

  searchHive() async {
    if (searchController.text.isNotEmpty) {
      setState(() {
        _isloading = true;
      });
      await DatabaseService()
          .searchByName(searchController.text)
          .then((snapshot) {
        setState(() {
          searchSnapshot = snapshot;
          _isloading = false;
          _hasUserSearch = true;
        });
      });
    }
  }

  groupList() {
    return _hasUserSearch
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: (context, index) {
              return groupTile(
                  userName: userName,
                  groupId: searchSnapshot!.docs[index]['groupId'],
                  groupName: searchSnapshot!.docs[index]['groupName'],
                  admin: searchSnapshot!.docs[index]['admin']);
            },
          )
        : Container();
  }

  Widget groupTile(
      {required String userName,
      required String groupId,
      required String groupName,
      required String admin}) {
    userJoinedorNot(userName, groupId, groupName, admin);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      leading: CircleAvatar(
        backgroundColor: Constants.secondary,
        radius: 30,
        child: Text(
          groupName.substring(0, 1).toUpperCase(),
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Constants.primary),
        ),
      ),
      title: Text(
        groupName,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text("Admin: ${getName(admin)}"),
      trailing: InkWell(
        onTap: () {
          DatabaseService(uid: user!.uid)
              .toggleHiveJoin(groupId, userName, groupName);
          if (_isJoined != true) {
            setState(() {
              _isJoined = !_isJoined;
            });
            showSnackBar(
                "Sucessfully joined the hive", Constants.secondary, context);
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatScreen(
                          groupId: groupId,
                          groupName: groupName,
                          userName: userName)));
            });
          } else {
            setState(() {
              _isJoined = !_isJoined;
              showSnackBar(
                  "Left the hive $groupName", Constants.error, context);
            });
          }
        },
        child: _isJoined
            ? Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Constants.secondary,
                ),
                child: Text(
                  "Joined",
                  style: TextStyle(color: Constants.primary),
                ),
              )
            : Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Constants.secondary,
                ),
                child: Text(
                  "Join",
                  style: TextStyle(color: Constants.primary),
                ),
              ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  getUserDetails() async {
    await HelperFunctions.getUsernameFromSf().then((value) {
      setState(() {
        userName = value!;
        user = FirebaseAuth.instance.currentUser;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.secondary,
          title: Text(
            "Search",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Constants.primary),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              color: Constants.secondary,
              child: Row(children: [
                Expanded(
                    child: TextField(
                  controller: searchController,
                  style: TextStyle(color: Constants.primary),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search Hives",
                      hintStyle:
                          TextStyle(color: Constants.primary, fontSize: 18)),
                )),
                InkWell(
                  onTap: () {
                    searchHive();
                  },
                  child: Icon(
                    Icons.search,
                    color: Constants.primary,
                  ),
                )
              ]),
            ),
            _isloading
                ? Center(
                    child:
                        CircularProgressIndicator(color: Constants.secondary),
                  )
                : groupList(),
          ],
        ));
  }
}
