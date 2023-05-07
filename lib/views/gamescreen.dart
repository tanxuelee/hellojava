import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hellojava/constants.dart';
import 'package:hellojava/models/game.dart';
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.swap_vert_circle_outlined,
                      color: Color(0xFFF9A03F)),
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
              const SizedBox(height: 3),
              const Text(
                "How to play: Long press on the keywords, drag and drop them into the correct order.",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 5),
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
      ),
      bottomNavigationBar: BottomAppBar(
        child: GestureDetector(
          onTap: _clickLeaderboardButton,
          child: Container(
            height: 45,
            color: const Color(0xFF4F646F),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.emoji_events,
                    color: Color(0xFFDEE7E7),
                  ),
                  SizedBox(width: 15),
                  Text(
                    "View Leaderboard",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFDEE7E7)),
                  ),
                  SizedBox(width: 15),
                  Icon(
                    Icons.emoji_events,
                    color: Color(0xFFDEE7E7),
                  ),
                ],
              ),
            ),
          ),
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

  void _clickLeaderboardButton() {
    if (widget.user.email == "guest@gmail.com") {
      _loadOptions();
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (content) => LeaderboardScreen(
                    user: widget.user,
                  )));
    }
  }
}

class LeaderboardScreen extends StatefulWidget {
  final User user;
  LeaderboardScreen({
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

  @override
  void initState() {
    super.initState();
    _loadGameList();
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
          'View Leaderboard',
          style: TextStyle(
            fontSize: 17,
          ),
        ),
      ),
      body: gameList.isEmpty
          ? Center(
              child: Text(titlecenter,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)))
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 1,
                      childAspectRatio: (1 / 0.23),
                      children: List.generate(gameList.length, (index) {
                        return InkWell(
                          onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (content) => GameLeaderboardScreen(
                                          user: widget.user,
                                          index: index,
                                          gameList: gameList,
                                        )))
                          },
                          child: Card(
                              color: const Color(0xFFDEE7E7),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: const Icon(
                                        Icons.videogame_asset_rounded),
                                    title: Text(
                                      gameList[index].gameMode.toString(),
                                      style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    trailing: const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: Color(0xFFF9A03F)),
                                  ),
                                ],
                              )),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _loadGameList() {
    http
        .post(
      Uri.parse(CONSTANTS.server + "/hellojava/php/load_gamelist.php"),
    )
        .timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        Fluttertoast.showToast(
            msg: "Timeout error, please try again later",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
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
        if (extractdata['gameList'] != null) {
          gameList = <Game>[];
          extractdata['gameList'].forEach((v) {
            gameList.add(Game.fromJson(v));
          });
        } else {
          titlecenter = "No Game List Available";
          gameList.clear();
        }
        setState(() {});
      } else {
        //do something
        titlecenter = "No Game List Available";
        gameList.clear();
        setState(() {});
      }
    }).catchError((error) {
      if (error is SocketException) {
        Fluttertoast.showToast(
            msg: "Timeout error, please try again later",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            fontSize: 14,
            backgroundColor: const Color(0xFFAB3232));
      } else {
        print("Error: $error");
      }
    });
  }
}

class GameLeaderboardScreen extends StatefulWidget {
  final User user;
  int index;
  final List<Game> gameList;
  GameLeaderboardScreen({
    Key? key,
    required this.user,
    required this.index,
    required this.gameList,
  }) : super(key: key);

  @override
  State<GameLeaderboardScreen> createState() => _GameLeaderboardScreenState();
}

class _GameLeaderboardScreenState extends State<GameLeaderboardScreen> {
  late double screenHeight, screenWidth, resWidth;
  List<Game> gameList = <Game>[];
  String titlecenter = "";
  Widget _verticalDivider = const VerticalDivider(
    thickness: 2,
  );

  @override
  void initState() {
    super.initState();
    _loadLatestGameScore(widget.gameList[widget.index].gameId);
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
        title: Text(
          widget.gameList[widget.index].gameMode.toString(),
          style: const TextStyle(
            fontSize: 17,
          ),
        ),
      ),
      body: gameList.isEmpty
          ? Center(
              child: Text(titlecenter,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)))
          : Padding(
              padding: const EdgeInsets.all(15),
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
                            fontSize: 18,
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
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(label: _verticalDivider),
                            const DataColumn(
                                label: Text(
                              'Players',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                            DataColumn(label: _verticalDivider),
                            const DataColumn(
                                label: Text(
                              'Score',
                              style: TextStyle(
                                fontSize: 13,
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
                                        fontSize: 13,
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
                                      fontSize: 13,
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
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight: index < 3
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  )),
                                ],
                              );

                              // if (index < 3) {
                              //   // check if this is one of the top 3 rows
                              //   return DataRow(
                              //     color: MaterialStateColor.resolveWith(
                              //         (states) => const Color(
                              //             0xFFF7D488)), // set a background color
                              //     cells: [
                              //       DataCell(Center(
                              //         child: Text(
                              //           (index + 1).toString(),
                              //           style: const TextStyle(
                              //             fontSize: 13,
                              //             color: Colors.black,
                              //             fontWeight: FontWeight.bold,
                              //           ),
                              //         ),
                              //       )),
                              //       DataCell(_verticalDivider),
                              //       DataCell(Text(
                              //         gameList[index].name.toString(),
                              //         style: const TextStyle(
                              //           fontSize: 13,
                              //           color: Colors.black,
                              //           fontWeight:
                              //               FontWeight.bold, // set a font style
                              //         ),
                              //       )),
                              //       DataCell(_verticalDivider),
                              //       DataCell(Center(
                              //         child: Text(
                              //           gameList[index].totalScore.toString(),
                              //           style: const TextStyle(
                              //             fontSize: 13,
                              //             color: Colors.black,
                              //             fontWeight: FontWeight
                              //                 .bold, // set a font style
                              //           ),
                              //         ),
                              //       )),
                              //     ],
                              //   );
                              // } else {
                              //   // for the rest of the rows, use the default styling
                              //   return DataRow(
                              //     cells: [
                              //       DataCell(Center(
                              //         child: Text(
                              //           (index + 1).toString(),
                              //           style: const TextStyle(
                              //             fontSize: 13,
                              //             color: Colors.black,
                              //           ),
                              //         ),
                              //       )),
                              //       DataCell(_verticalDivider),
                              //       DataCell(Text(
                              //         gameList[index].name.toString(),
                              //         style: const TextStyle(
                              //           fontSize: 13,
                              //           color: Colors.black,
                              //         ),
                              //       )),
                              //       DataCell(_verticalDivider),
                              //       DataCell(Center(
                              //         child: Text(
                              //           gameList[index].totalScore.toString(),
                              //           style: const TextStyle(
                              //             fontSize: 13,
                              //             color: Colors.black,
                              //           ),
                              //         ),
                              //       )),
                              //     ],
                              //   );
                              // }
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

  void _loadLatestGameScore(String? gameId) {
    http.post(
      Uri.parse(CONSTANTS.server + "/hellojava/php/load_latestgamescore.php"),
      body: {
        'game_id': widget.gameList[widget.index].gameId.toString(),
      },
    ).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        Fluttertoast.showToast(
            msg: "Timeout error, please try again later",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
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
          titlecenter = "No Data Available";
          gameList.clear();
        }
        setState(() {});
      } else {
        titlecenter = "No Data Available";
        gameList.clear();
        setState(() {});
      }
    }).catchError((error) {
      if (error is SocketException) {
        Fluttertoast.showToast(
            msg: "Timeout error, please try again later",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            fontSize: 14,
            backgroundColor: const Color(0xFFAB3232));
      } else {
        print("Error: $error");
      }
    });
  }
}
