import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hellojava/main.dart';
import 'package:hellojava/models/user.dart';
import 'package:hellojava/views/exercisescreen.dart';
import 'package:hellojava/views/gamescreen.dart';
import 'package:hellojava/views/loginscreen.dart';
import 'package:hellojava/views/notescreen.dart';
import 'package:hellojava/views/profilescreen.dart';
import 'package:hellojava/views/quizscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<User> userList = <User>[];
  late double screenHeight, screenWidth, resWidth;
  var val = 50;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4FAFF),
        appBar: AppBar(
          title: const Text('Hello Java'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: <Widget>[
              Tab(text: 'Note'),
              Tab(text: 'Exercise'),
              Tab(text: 'Quiz'),
              Tab(text: 'Game'),
              Tab(text: 'Profile')
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(widget.user.name.toString()),
                accountEmail: Text(widget.user.email.toString()),
                currentAccountPicture: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: CONSTANTS.server +
                        '/hellojava/assets/users/${widget.user.id}.jpg' +
                        "?v=$val",
                    fit: BoxFit.cover,
                    width: resWidth / 2,
                    placeholder: (context, url) =>
                        const LinearProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
              if (widget.user.email == "guest@gmail.com")
                _createDrawerItem(
                  icon: Icons.login,
                  text: 'Login',
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (content) => LoginScreen()));
                  },
                ),
              if (widget.user.email != "guest@gmail.com")
                _createDrawerItem(
                  icon: Icons.room_rounded,
                  text: 'User Manual',
                  onTap: () {},
                ),
              if (widget.user.email != "guest@gmail.com")
                _createDrawerItem(
                  icon: Icons.logout,
                  text: 'Logout',
                  onTap: () {
                    _logoutDialog();
                  },
                ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            NoteScreen(user: widget.user),
            ExerciseScreen(user: widget.user),
            QuizScreen(user: widget.user),
            GameScreen(),
            ProfileScreen(user: widget.user),
          ],
        ),
      ),
    );
  }

  Widget _createDrawerItem(
      {required IconData icon,
      required String text,
      required GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  void _logoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: StatefulBuilder(
            builder: (context, StateSetter setState) {
              return AlertDialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                title: const Text(
                  "Logout?",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
                content: const Text("Are your sure"),
                actions: <Widget>[
                  TextButton(
                    child: const Text(
                      "Yes",
                      style: TextStyle(),
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (content) => MyApp()));
                    },
                  ),
                  TextButton(
                    child: const Text(
                      "No",
                      style: TextStyle(),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
