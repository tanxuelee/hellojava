import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hellojava/colors.dart';
import 'package:hellojava/models/user.dart';
import '../constants.dart';

class PlayMediumModeScreen extends StatefulWidget {
  final User user;
  PlayMediumModeScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<PlayMediumModeScreen> createState() => _PlayMediumModeScreenState();
}

class _PlayMediumModeScreenState extends State<PlayMediumModeScreen> {
  late double screenHeight, screenWidth, resWidth;
  List<String> mediumJavaKeywords = <String>[];
  List<List<String>> mediumKeywordLists = [
    ['Scanner', 'input', '=', 'new Scanner', '(System.', 'in)', ';'],
    ['double', 'result', '=', 'Math.', 'sqrt', '(25.0)', ';'],
    ['System.', 'out.', 'printf(', '"%.3f"', ',', '11.4325', ');'],
    ['public', 'static', 'void', 'main', '(String[]', 'args)', '{'],
    ['double[][]', 'price', '=', 'new', 'double', '[4][2]', ';'],
  ];
  int currentListIndex = 0;
  int totalScore = 0;
  int consecutiveCorrectAnswers = 0;
  bool lastAnswerCorrect = true;
  List<String> currentOrder = [];
  bool isCorrectOrder = false;
  int score = 0;
  late Timer _timer;
  int _timeRemaining = 900; // 15 minutes in seconds
  bool showingToast = false;

  void initState() {
    super.initState();
    mediumJavaKeywords = List.from(mediumKeywordLists[currentListIndex])
      ..shuffle();
    startTimer();
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final String item = mediumJavaKeywords.removeAt(oldIndex);
      mediumJavaKeywords.insert(newIndex, item);
    });
  }

  void _checkOrder() async {
    setState(() {
      showingToast = true;
    });
    if (mediumJavaKeywords.join(' ') ==
        mediumKeywordLists[currentListIndex].join(' ')) {
      Fluttertoast.showToast(
        msg: 'Congratulations! The order is correct!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        fontSize: 14,
        backgroundColor: correct,
      );
      setState(() {
        totalScore += 1 +
            consecutiveCorrectAnswers; // Add bonus points for consecutive correct answers
        lastAnswerCorrect = true;
        consecutiveCorrectAnswers++;
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
        lastAnswerCorrect = false;
        consecutiveCorrectAnswers = 0;
      });
    }
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      showingToast = false;
    });

    // Move to the next list of keywords or show the final score
    if (currentListIndex < mediumKeywordLists.length - 1) {
      setState(() {
        currentListIndex += 1;
        mediumJavaKeywords = List.from(mediumKeywordLists[currentListIndex])
          ..shuffle();
      });
    } else {
      // if (totalScore > 0) {
      setState(() {
        _saveGameScore(totalScore);
      });
      _timer.cancel();
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
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }
    return IgnorePointer(
      ignoring: showingToast,
      child: WillPopScope(
        onWillPop: () async {
          bool confirm = await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              backgroundColor: const Color(0xFFF4F4F4),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              title: const Text('Do you really want to leave?'),
              content: const Text('All progress will be lost.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Leave'),
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
              'Medium (Time Left: ${(_timeRemaining ~/ 60).toString().padLeft(2, '0')}:${(_timeRemaining % 60).toString().padLeft(2, '0')})',
              style: const TextStyle(
                fontSize: 17,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: IgnorePointer(
              ignoring: showingToast,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                      child: Container(
                        width: screenWidth,
                        decoration: BoxDecoration(
                          color: const Color(0xFFDEE7E7),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF4F646F)),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Round ${currentListIndex + 1} / ${mediumKeywordLists.length}',
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF4F646F)),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Total score: $totalScore',
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF4F646F)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Rearrange the seven keywords below by dragging them into the correct order',
                    style: TextStyle(fontSize: 17),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ReorderableListView(
                      onReorder: _onReorder,
                      children: List.generate(
                        mediumJavaKeywords.length,
                        (index) {
                          return Padding(
                            key: ValueKey('keyword_$index'),
                            padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                            child: Container(
                              height: 55,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFF9A03F),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: ListTile(
                                title: Text(
                                  '${index + 1}.     ${mediumJavaKeywords[index]}',
                                ),
                                tileColor: const Color(0xFFF4FAFF),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  IgnorePointer(
                    ignoring: showingToast,
                    child: Padding(
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
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(8.0))),
                              backgroundColor: MaterialStateProperty.all(
                                const Color(0xFFF9A03F),
                              ),
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
        ),
      ),
    );
  }

  void _saveGameScore(int totalScore) async {
    http.post(
        Uri.parse(CONSTANTS.server + "/hellojava/php/save_mediumscore.php"),
        body: {
          "user_id": widget.user.id.toString(),
          "total_score": totalScore.toString(),
        }).then((response) {
      print(response.body);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
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
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: const Color(0xFFF4F4F4),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
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
      } else {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: const Color(0xFFF4F4F4),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: const Text('Error'),
              content: const Text(
                  'An error occurred while saving your game score, please try it again.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    });
  }
}
