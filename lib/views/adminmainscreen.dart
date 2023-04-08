import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hellojava/main.dart';
import 'package:hellojava/models/admin.dart';
import 'package:hellojava/views/manageexercisescreen.dart';
import 'package:hellojava/views/managenotescreen.dart';
import 'package:hellojava/views/managequizscreen.dart';
import 'package:hellojava/views/manageuserscreen.dart';

class AdminMainScreen extends StatefulWidget {
  final Admin admin;
  const AdminMainScreen({
    Key? key,
    required this.admin,
  }) : super(key: key);

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  List<Admin> adminList = <Admin>[];
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
          title: const Text(
            'Hello Java',
            style: TextStyle(
              fontSize: 17,
            ),
          ),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(widget.admin.name.toString()),
                accountEmail: Text(widget.admin.email.toString()),
                currentAccountPicture: ClipOval(
                  child: SizedBox(
                      width: resWidth / 2,
                      child: Image.asset('assets/images/logo.png')),
                ),
              ),
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
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                "Administration Panel",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: GridView.count(
                    crossAxisCount: 2,
                    scrollDirection: Axis.vertical,
                    primary: false,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    children: <Widget>[
                      TextButton(
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ManageNoteScreen(admin: widget.admin)),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                width: resWidth / 5,
                                child: Image.asset('assets/images/note.png')),
                            const SizedBox(height: 10),
                            const Text(
                              'Note',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.black),
                            ),
                          ],
                        ),
                        style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Color(0xFFDEE7E7)),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ManageExerciseScreen(admin: widget.admin)),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                width: resWidth / 5,
                                child:
                                    Image.asset('assets/images/exercise.png')),
                            const SizedBox(height: 10),
                            const Text(
                              'Exercise',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.black),
                            ),
                          ],
                        ),
                        style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Color(0xFFDEE7E7)),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ManageQuizScreen(admin: widget.admin)),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                width: resWidth / 5,
                                child: Image.asset('assets/images/quiz.png')),
                            const SizedBox(height: 10),
                            const Text(
                              'Quiz',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.black),
                            ),
                          ],
                        ),
                        style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Color(0xFFDEE7E7)),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ManageUserScreen(admin: widget.admin)),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                width: resWidth / 5,
                                child: Image.asset('assets/images/user.png')),
                            const SizedBox(height: 10),
                            const Text(
                              'User',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.black),
                            ),
                          ],
                        ),
                        style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Color(0xFFDEE7E7)),
                        ),
                      ),
                    ]),
              ),
            ],
          ),
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
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {},
                child: AlertDialog(
                  backgroundColor: const Color(0xFFF4F4F4),
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (content) => const MyApp()));
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
                ),
              );
            },
          ),
        );
      },
    );
  }
}
