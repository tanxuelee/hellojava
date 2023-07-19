import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:hellojava/models/game.dart';
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
  int _timeRemaining = 1200; // 20 minutes in seconds
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
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            isDismissible: false,
            builder: (BuildContext context) {
              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Container(
                    color: const Color(0xFFF4F4F4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'Time is up!',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 25),
                          child: Text(
                            'Your score won\'t be saved. You can play the game again.',
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                        const Divider(
                          height: 2,
                          color: Colors.grey,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'Exit',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
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
          bool? confirm = await showModalBottomSheet<bool>(
            context: context,
            isScrollControlled: true,
            isDismissible: false,
            builder: (BuildContext context) {
              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Container(
                    color: const Color(0xFFF4F4F4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'Do you really want to leave?',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 25),
                          child: Text(
                            'All progress will be lost.',
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                        const Divider(
                          height: 2,
                          color: Colors.grey,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text(
                                  'Leave',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 48,
                              color: Colors.grey,
                            ),
                            Expanded(
                              child: TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
          return confirm ?? false;
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF4F4F4),
          appBar: AppBar(
            title: Text(
              'Medium (Time Left: ${(_timeRemaining ~/ 60).toString().padLeft(2, '0')}:${(_timeRemaining % 60).toString().padLeft(2, '0')})',
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
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
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF4F646F)),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Total score: $totalScore',
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFC58917)),
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
                    style: TextStyle(fontSize: 20),
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
                                  style: const TextStyle(fontSize: 17),
                                ),
                                tileColor: const Color(0xFFF4F4F4),
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
                          height: 50,
                          child: ElevatedButton(
                            child: const Text(
                              "Check Order",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
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
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            isDismissible: false,
            builder: (BuildContext context) {
              return Container(
                color: const Color(0xFFF4F4F4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Congratulations!',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 25),
                      child: Text(
                        'You have finished the game and obtained a score of $totalScore.',
                        style: const TextStyle(fontSize: 17),
                      ),
                    ),
                    const Divider(
                      height: 2,
                      color: Colors.grey,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LeaderboardScreen(
                                  user: widget.user,
                                ),
                              ),
                            ),
                            child: const Text(
                              'View Leaderboard',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 48,
                          color: Colors.grey,
                        ),
                        Expanded(
                          child: TextButton(
                            child: const Text(
                              'Exit',
                              style: TextStyle(fontSize: 15),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            isDismissible: false,
            builder: (BuildContext context) {
              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Container(
                    color: const Color(0xFFF4F4F4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'Game over!',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 25),
                          child: Text(
                            'You have finished the game and obtained a score of $totalScore. Better luck next time!',
                            style: const TextStyle(fontSize: 17),
                          ),
                        ),
                        const Divider(
                          height: 2,
                          color: Colors.grey,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LeaderboardScreen(
                                      user: widget.user,
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  'View Leaderboard',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 48,
                              color: Colors.grey,
                            ),
                            Expanded(
                              child: TextButton(
                                child: const Text(
                                  'Exit',
                                  style: TextStyle(fontSize: 15),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      } else {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          isDismissible: false,
          builder: (BuildContext context) {
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  color: const Color(0xFFF4F4F4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Error!',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 0, 16, 25),
                        child: Text(
                          'An error occurred while saving your game score, please try again.',
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      const Divider(
                        height: 2,
                        color: Colors.grey,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'OK',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
    });
  }
}

class LeaderboardScreen extends StatefulWidget {
  final User user;
  const LeaderboardScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  late double screenHeight, screenWidth, resWidth;
  List<Game> gameList = <Game>[];
  String titlecenter = "";
  Widget _verticalDivider = const VerticalDivider(
    thickness: 2,
  );
  late int index = 0;

  @override
  void initState() {
    super.initState();
    _loadLeaderboard(index);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Medium Mode",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      body: gameList.isEmpty
          ? Center(
              child: Text(titlecenter,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)))
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.emoji_events,
                            size: 18, color: Color(0xFFF9A03F)),
                        SizedBox(width: 15),
                        Text(
                          'Top Five of the Day',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 15),
                        Icon(Icons.emoji_events,
                            size: 18, color: Color(0xFFF9A03F)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Center(
                        child: DataTable(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          columnSpacing: 22.0,
                          dividerThickness: 2.0,
                          columns: [
                            const DataColumn(
                              label: Text(
                                'No.',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(label: _verticalDivider),
                            const DataColumn(
                                label: Text(
                              'Players',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                            DataColumn(label: _verticalDivider),
                            const DataColumn(
                                label: Text(
                              'Score',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                          ],
                          rows: List<DataRow>.generate(
                            gameList.length,
                            (index) {
                              return DataRow(
                                color: index == 0
                                    ? MaterialStateColor.resolveWith((states) =>
                                        const Color(0xFFFFF380)) // gold
                                    : index == 1
                                        ? MaterialStateColor.resolveWith(
                                            (states) => const Color(
                                                0xFFE5E4E2)) // silver
                                        : index == 2
                                            ? MaterialStateColor.resolveWith(
                                                (states) => const Color(
                                                    0xFFFBE7A1)) // bronze
                                            : null, // default color
                                cells: [
                                  DataCell(Center(
                                    child: Text(
                                      (index + 1).toString(),
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: index < 3
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  )),
                                  DataCell(_verticalDivider),
                                  DataCell(Text(
                                    gameList[index].name.toString(),
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: index < 3
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  )),
                                  DataCell(_verticalDivider),
                                  DataCell(Center(
                                    child: Text(
                                      gameList[index].totalScore.toString(),
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: index < 3
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  )),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _loadLeaderboard(int index) {
    http
        .post(
      Uri.parse(CONSTANTS.server + "/hellojava/php/load_mediumleaderboard.php"),
    )
        .timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        Fluttertoast.showToast(
            msg: "Timeout error, please try again later",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            fontSize: 14,
            backgroundColor: const Color(0xFFAB3232));
        throw const SocketException("Connection timed out");
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);
      print(jsondata);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        if (extractdata['gamescore'] != null) {
          gameList = <Game>[];
          extractdata['gamescore'].forEach((v) {
            gameList.add(Game.fromJson(v));
          });
        } else {
          titlecenter = "No data available today for this game";
          gameList.clear();
        }
        setState(() {});
      } else {
        titlecenter = "No data available today for this game";
        gameList.clear();
        setState(() {});
      }
    }).catchError((error) {
      if (error is SocketException) {
        Fluttertoast.showToast(
            msg: "Timeout error, please try again later",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            fontSize: 14,
            backgroundColor: const Color(0xFFAB3232));
      } else {
        print("Error: $error");
      }
    });
  }
}
