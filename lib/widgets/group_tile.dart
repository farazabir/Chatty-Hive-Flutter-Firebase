import 'package:chattyhive/screens/chat_screen.dart';
import 'package:chattyhive/shared/constants.dart';
import 'package:flutter/material.dart';

class GroupTile extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;

  const GroupTile(
      {Key? key,
      required this.userName,
      required this.groupId,
      required this.groupName})
      : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatScreen(
                      groupId: widget.groupId,
                      groupName: widget.groupName,
                      userName: widget.userName)));
        },
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Constants.secondary,
            child: Text(
              widget.groupName.substring(0, 1).toUpperCase(),
              style: TextStyle(
                  color: Constants.primary, fontWeight: FontWeight.bold),
            ),
          ),
          title: Text(
            widget.groupName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "Start chatting as ${widget.userName}",
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ),
    );
  }
}
