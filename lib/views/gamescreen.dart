import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hellojava/colors.dart';
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
              backgroundColor: const Color(0xFFF4F4F4),
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
  List<String> javaKeywords = [];
  List<List<String>> keywordLists = [
    ['boolean', 'b', '=', 'true', ';'],
    ['public', 'static', 'void', 'main', '('],
    ['while', '(', 'expression', ')', '{'],
    ['if', '(condition)', '{', 'statement1;', '}'],
    [
      'Problem analysis',
      'Writing algorithm',
      'Test algorithm',
      'Coding',
      'Testing program'
    ],
  ];
  int currentListIndex = 0;
  int totalScore = 0;
  List<String> currentOrder = [];
  bool isCorrectOrder = false;
  int score = 0;
  late Timer _timer;
  int _timeRemaining = 600; // 10 minutes in seconds

  void initState() {
    super.initState();
    javaKeywords = List.from(keywordLists[currentListIndex])..shuffle();
    startTimer();
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final String item = javaKeywords.removeAt(oldIndex);
      javaKeywords.insert(newIndex, item);
    });
  }

  void _checkOrder() async {
    if (javaKeywords.join(' ') == keywordLists[currentListIndex].join(' ')) {
      Fluttertoast.showToast(
        msg: 'Congratulations! The order is correct!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        fontSize: 14,
        backgroundColor: correct,
      );
      setState(() {
        totalScore += 1;
      });
    } else {
      Fluttertoast.showToast(
        msg: 'Oops! The order is incorrect!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        fontSize: 14,
        backgroundColor: incorrect,
      );
      setState(() {
        totalScore -= 1;
      });
    }
    await Future.delayed(const Duration(seconds: 2));

    // Move to the next list of keywords or show the final score
    if (currentListIndex < keywordLists.length - 1) {
      setState(() {
        currentListIndex += 1;
        javaKeywords = List.from(keywordLists[currentListIndex])..shuffle();
      });
    } else {
      if (totalScore > 0) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: const Color(0xFFF4F4F4),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: const Text('Congratulations!'),
              content: Text(
                  'You have finished the game and obtained a score of $totalScore.'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        _timer.cancel();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Game Over!'),
              content: Text(
                  'You have finished the game and obtained a score of $totalScore. Better luck next time!'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeRemaining > 0) {
          _timeRemaining--;
        } else {
          _timer.cancel();
          // Show the dialog that the time is up
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              backgroundColor: const Color(0xFFF4F4F4),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: const Text('Time is up!'),
              content: const Text(
                  'Your score won\'t be saved. You can play the game again.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Exit'),
                ),
              ],
            ),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
            backgroundColor: const Color(0xFFF4F4F4),
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
        backgroundColor: const Color(0xFFF4FAFF),
        appBar: AppBar(
          title: Text(
            '(Time Left: ${(_timeRemaining ~/ 60).toString().padLeft(2, '0')}:${(_timeRemaining % 60).toString().padLeft(2, '0')})',
            style: const TextStyle(
              fontSize: 17,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Text(
                  'Score: $totalScore',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Rearrange the five keywords by dragging them into the correct order',
                style: TextStyle(fontSize: 17),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ReorderableListView(
                  onReorder: _onReorder,
                  children: [
                    for (final keyword in javaKeywords)
                      Padding(
                        key: ValueKey(keyword),
                        padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFFF9A03F),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: ListTile(
                            title: Text(keyword),
                            tileColor: const Color(0xFFF4FAFF),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Container(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: screenWidth,
                    height: 40,
                    child: ElevatedButton(
                      child: const Text(
                        "Check Order",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      onPressed: _checkOrder,
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0))),
                        backgroundColor: MaterialStateProperty.all(
                          const Color(0xFFF9A03F),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
