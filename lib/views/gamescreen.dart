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
        child: Center(
          child: SizedBox(
            height: 50,
            width: 100,
            child: ElevatedButton(
              onPressed: _clickPlayButton,
              child: const Text(
                "Play Game",
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
        ),
      ),
    );
  }

  void _clickPlayButton() {
    if (widget.user.email == "guest@gmail.com") {
      _loadOptions();
    } else {
      _startConfirmation();
    }
  }

  _loadOptions() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {},
            child: AlertDialog(
              backgroundColor: const Color(0xFFF4FAFF),
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
                  onPressed: _onLogin,
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
            ),
          );
        });
  }

  _startConfirmation() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {},
            child: AlertDialog(
              backgroundColor: const Color(0xFFF4FAFF),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: const Text(
                "Play game now?",
                style: TextStyle(),
              ),
              content: const Text(
                "",
                textAlign: TextAlign.justify,
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    "Start",
                    style: TextStyle(),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (content) => PlayGameScreen(
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
}

class PlayGameScreen extends StatefulWidget {
  final User user;
  PlayGameScreen({
    Key? key,
    required this.user,
  });

  @override
  State<PlayGameScreen> createState() => _PlayGameScreenState();
}

class _PlayGameScreenState extends State<PlayGameScreen> {
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
    return WillPopScope(
      onWillPop: () async {
        bool confirm = await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFFF4FAFF),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            title: const Text('Are you sure you want to leave?'),
            content: const Text('All progress will be lost.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
        return confirm ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Game Screen'),
        ),
        body: const Padding(
          padding: EdgeInsets.all(15),
          child: Center(
            child: Text('Hello game'),
          ),
        ),
      ),
    );
  }
}
