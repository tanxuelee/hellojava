import 'package:hellojava/views/playeasymodescreen.dart';
import 'package:hellojava/views/playhardmodescreen.dart';
import 'package:hellojava/views/playmediummodescreen.dart';
import 'package:flutter/material.dart';
import 'package:hellojava/models/user.dart';
import 'package:hellojava/views/loginscreen.dart';

class GameScreen extends StatefulWidget {
  final User user;
  GameScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late double screenHeight, screenWidth, resWidth;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.swap_vert_circle_outlined, color: Color(0xFFF9A03F)),
                SizedBox(width: 10),
                Text(
                  "Drag and Drop Game",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              "How to play: Long press on the keywords, drag and drop them into the correct order.",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              color: const Color(0xFFDEE7E7),
              child: ListTile(
                leading: const Icon(Icons.directions_walk),
                title: const Text(
                  'Easy Mode',
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  'Has five keywords',
                  style: TextStyle(color: Color(0xFF4F646F)),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded,
                    color: Color(0xFFF9A03F)),
                onTap: _clickPlayEasyModeButton,
              ),
            ),
            const SizedBox(height: 1),
            Card(
              color: const Color(0xFFDEE7E7),
              child: ListTile(
                leading: const Icon(Icons.directions_bike),
                title: const Text(
                  'Medium Mode',
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  'Has seven keywords',
                  style: TextStyle(color: Color(0xFF4F646F)),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded,
                    color: Color(0xFFF9A03F)),
                onTap: _clickPlayMediumModeButton,
              ),
            ),
            const SizedBox(height: 1),
            Card(
              color: const Color(0xFFDEE7E7),
              child: ListTile(
                leading: const Icon(Icons.directions_car),
                title: const Text(
                  'Hard Mode',
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  'Has ten keywords',
                  style: TextStyle(color: Color(0xFF4F646F)),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded,
                    color: Color(0xFFF9A03F)),
                onTap: _clickPlayHardModeButton,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _clickPlayEasyModeButton() {
    if (widget.user.email == "guest@gmail.com") {
      _loadOptions();
    } else {
      _easyModeConfirmation();
    }
  }

  _loadOptions() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color(0xFFF4F4F4),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Center(
              child: Text(
                "Please login first!",
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
            content: SizedBox(
              height: 50,
              width: 100,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _onLogin();
                },
                child: const Text(
                  "Login",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0))),
                  backgroundColor: MaterialStateProperty.all(
                    const Color(0xFFF9A03F),
                  ),
                ),
              ),
            ),
          );
        });
  }

  _easyModeConfirmation() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {},
            child: AlertDialog(
              backgroundColor: const Color(0xFFF4F4F4),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: const Text(
                "Play easy mode now?",
                style: TextStyle(),
              ),
              content: const SingleChildScrollView(
                child: Text(
                  "1. You have 10 minutes to complete five rounds." +
                      "\n\n2. If you rearrange correctly, you will get points that increases by one for each correct answer.\n(Example: 1+2+3)" +
                      "\n\n3. If you get it wrong, you lose one point and the sequence of points starts over at one." +
                      "\n\n4. If the time runs out, your score will not be saved and you can play the game again.",
                  textAlign: TextAlign.justify,
                ),
              ),
              actions: [
                TextButton(
                  child: const Text(
                    "Play",
                    style: TextStyle(),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (content) => PlayEasyModeScreen(
                                  user: widget.user,
                                )));
                  },
                ),
                TextButton(
                  child: const Text(
                    "Cancel",
                    style: TextStyle(),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  void _onLogin() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => const LoginScreen()));
  }

  void _clickPlayMediumModeButton() {
    if (widget.user.email == "guest@gmail.com") {
      _loadOptions();
    } else {
      _mediumModeConfirmation();
    }
  }

  void _mediumModeConfirmation() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {},
            child: AlertDialog(
              backgroundColor: const Color(0xFFF4F4F4),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: const Text(
                "Play medium mode now?",
                style: TextStyle(),
              ),
              content: const SingleChildScrollView(
                child: Text(
                  "1. You have 15 minutes to complete five rounds." +
                      "\n\n2. If you rearrange correctly, you will get points that increases by one for each correct answer.\n(Example: 1+2+3)" +
                      "\n\n3. If you get it wrong, you lose one point and the sequence of points starts over at one." +
                      "\n\n4. If the time runs out, your score will not be saved and you can play the game again.",
                  textAlign: TextAlign.justify,
                ),
              ),
              actions: [
                TextButton(
                  child: const Text(
                    "Play",
                    style: TextStyle(),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (content) => PlayMediumModeScreen(
                                  user: widget.user,
                                )));
                  },
                ),
                TextButton(
                  child: const Text(
                    "Cancel",
                    style: TextStyle(),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  void _clickPlayHardModeButton() {
    if (widget.user.email == "guest@gmail.com") {
      _loadOptions();
    } else {
      _hardModeConfirmation();
    }
  }

  void _hardModeConfirmation() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {},
            child: AlertDialog(
              backgroundColor: const Color(0xFFF4F4F4),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: const Text(
                "Play hard mode now?",
                style: TextStyle(),
              ),
              content: const SingleChildScrollView(
                child: Text(
                  "1. You have 20 minutes to complete five rounds." +
                      "\n\n2. If you rearrange correctly, you will get points that increases by one for each correct answer.\n(Example: 1+2+3)" +
                      "\n\n3. If you get it wrong, you lose one point and the sequence of points starts over at one." +
                      "\n\n4. If the time runs out, your score will not be saved and you can play the game again.",
                  textAlign: TextAlign.justify,
                ),
              ),
              actions: [
                TextButton(
                  child: const Text(
                    "Play",
                    style: TextStyle(),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (content) => PlayHardModeScreen(
                                  user: widget.user,
                                )));
                  },
                ),
                TextButton(
                  child: const Text(
                    "Cancel",
                    style: TextStyle(),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }
}
