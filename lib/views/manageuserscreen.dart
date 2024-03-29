import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hellojava/constants.dart';
import 'package:hellojava/models/admin.dart';
import 'package:hellojava/models/game.dart';
import 'package:hellojava/models/user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/quiz.dart';

class ManageUserScreen extends StatefulWidget {
  final Admin admin;
  const ManageUserScreen({
    Key? key,
    required this.admin,
  }) : super(key: key);

  @override
  State<ManageUserScreen> createState() => _ManageUserScreenState();
}

class _ManageUserScreenState extends State<ManageUserScreen> {
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
      appBar: AppBar(
        title: const Text(
          'Manage User',
          style: TextStyle(
            fontSize: 17,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 1,
                childAspectRatio: (1 / 0.23),
                children: <Widget>[
                  Card(
                    color: const Color(0xFFDEE7E7),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.lightbulb),
                          title: const Text(
                            'Manage User Account',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (content) =>
                                            ManageUserAccountScreen(
                                              admin: widget.admin,
                                            )));
                              },
                              icon: const Icon(
                                Icons.arrow_right,
                                size: 30,
                              ),
                              color: const Color(0xFFF9A03F)),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    color: const Color(0xFFDEE7E7),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.lightbulb),
                          title: const Text(
                            'Manage Score',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (content) =>
                                            SelectUserListScreen(
                                              admin: widget.admin,
                                            )));
                              },
                              icon: const Icon(
                                Icons.arrow_right,
                                size: 30,
                              ),
                              color: const Color(0xFFF9A03F)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ManageUserAccountScreen extends StatefulWidget {
  final Admin admin;
  const ManageUserAccountScreen({
    Key? key,
    required this.admin,
  }) : super(key: key);

  @override
  State<ManageUserAccountScreen> createState() =>
      _ManageUserAccountScreenState();
}

class _ManageUserAccountScreenState extends State<ManageUserAccountScreen> {
  late double screenHeight, screenWidth, resWidth;
  List<User> userList = <User>[];
  String titlecenter = "";
  Widget _verticalDivider = const VerticalDivider(
    thickness: 2,
  );

  @override
  void initState() {
    super.initState();
    _loadUserList();
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
          'Manage User Account',
          style: TextStyle(
            fontSize: 17,
          ),
        ),
      ),
      body: userList.isEmpty
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
                          columnSpacing: 40.0,
                          dividerThickness: 2.0,
                          columns: [
                            const DataColumn(
                                label: Text(
                              'User Email',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                            DataColumn(label: _verticalDivider),
                            const DataColumn(label: Text('')),
                          ],
                          rows: List<DataRow>.generate(
                            userList.length,
                            (index) => DataRow(
                              cells: [
                                DataCell(
                                  GestureDetector(
                                    onTap: () => {_moreDetails(index)},
                                    child: Text(
                                      userList[index].email.toString(),
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.black),
                                    ),
                                  ),
                                ),
                                DataCell(_verticalDivider),
                                DataCell(
                                  IconButton(
                                      onPressed: () =>
                                          _confirmationDelete(index),
                                      icon: const Center(
                                        child: Icon(
                                          Icons.delete,
                                          size: 22.0,
                                          color: Color(0xFFF9A03F),
                                        ),
                                      )),
                                ),
                              ],
                            ),
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

  void _loadUserList() {
    http
        .post(
      Uri.parse(CONSTANTS.server + "/hellojava/php/load_users.php"),
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
        if (extractdata['user'] != null) {
          userList = <User>[];
          extractdata['user'].forEach((v) {
            userList.add(User.fromJson(v));
          });
        } else {
          titlecenter = "No user available";
          userList.clear();
        }
        setState(() {});
      } else {
        //do something
        titlecenter = "No user available";
        userList.clear();
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

  _confirmationDelete(int index) {
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
                      'Delete user account?',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 25),
                    child: Text(
                      'Are you sure want to delete this user account?',
                      style: TextStyle(fontSize: 15),
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
                          onPressed: () {
                            Navigator.of(context).pop();
                            _deleteUser(index);
                          },
                          child: const Text('Delete'),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 48,
                        color: Colors.grey,
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
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

  void _deleteUser(int index) async {
    var url = Uri.parse(CONSTANTS.server + "/hellojava/php/delete_user.php");
    var response = await http.post(url, body: {
      'id': userList[index].id.toString(),
    });
    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              jsondata['data'],
              style: const TextStyle(color: Color(0xFFF4FAFF)),
              textAlign: TextAlign.center,
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: const Color(0xFF4F646F),
            behavior: SnackBarBehavior
                .fixed, // Ensures the snackbar sticks to the bottom
          ),
        );
        setState(() {
          _loadUserList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              jsondata['data'],
              style: const TextStyle(color: Color(0xFFF4FAFF)),
              textAlign: TextAlign.center,
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: const Color(0xFFAB3232),
            behavior: SnackBarBehavior
                .fixed, // Ensures the snackbar sticks to the bottom
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Failed to delete user account",
            style: const TextStyle(color: Color(0xFFF4FAFF)),
            textAlign: TextAlign.center,
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: const Color(0xFFAB3232),
          behavior: SnackBarBehavior
              .fixed, // Ensures the snackbar sticks to the bottom
        ),
      );
    }
  }

  void _moreDetails(int index) {
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
                      "User details",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 25),
                    child: Text(
                      'Name: ' +
                          userList[index].name.toString() +
                          '\nEmail: ' +
                          userList[index].email.toString() +
                          '\nPhone Number: ' +
                          userList[index].phone.toString() +
                          '\nRegistration Date:\n' +
                          userList[index].datereg.toString(),
                      style: const TextStyle(fontSize: 15),
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
                          child: const Text('Close'),
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
}

class SelectUserListScreen extends StatefulWidget {
  final Admin admin;
  const SelectUserListScreen({
    Key? key,
    required this.admin,
  }) : super(key: key);

  @override
  State<SelectUserListScreen> createState() => _SelectUserListScreenState();
}

class _SelectUserListScreenState extends State<SelectUserListScreen> {
  late double screenHeight, screenWidth, resWidth;
  List<User> userList = <User>[];
  String titlecenter = "";

  @override
  void initState() {
    super.initState();
    _loadUserList();
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
          'Select User',
          style: TextStyle(
            fontSize: 17,
          ),
        ),
      ),
      body: userList.isEmpty
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
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 1,
                      childAspectRatio: (1 / 0.23),
                      children: List.generate(userList.length, (index) {
                        return InkWell(
                          onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (content) =>
                                        SelectScoreCategoryScreen(
                                          admin: widget.admin,
                                          user: userList[index],
                                        ))),
                          },
                          child: Card(
                              color: const Color(0xFFDEE7E7),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.person),
                                    title: Text(
                                      userList[index].name.toString(),
                                      style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    trailing: const Icon(Icons.arrow_right,
                                        size: 30, color: Color(0xFFF9A03F)),
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

  void _loadUserList() {
    http
        .post(
      Uri.parse(CONSTANTS.server + "/hellojava/php/load_users.php"),
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
        if (extractdata['user'] != null) {
          userList = <User>[];
          extractdata['user'].forEach((v) {
            userList.add(User.fromJson(v));
          });
        } else {
          titlecenter = "No user available";
          userList.clear();
        }
        setState(() {});
      } else {
        //do something
        titlecenter = "No user available";
        userList.clear();
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

class SelectScoreCategoryScreen extends StatefulWidget {
  final Admin admin;
  final User user;
  SelectScoreCategoryScreen({
    Key? key,
    required this.admin,
    required this.user,
  }) : super(key: key);

  @override
  State<SelectScoreCategoryScreen> createState() =>
      _SelectScoreCategoryScreenState();
}

class _SelectScoreCategoryScreenState extends State<SelectScoreCategoryScreen> {
  late double screenHeight, screenWidth, resWidth;
  List<User> userList = <User>[];
  List<Quiz> quizList = <Quiz>[];
  List<Game> gameList = <Game>[];

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
          'Select Score Category',
          style: TextStyle(
            fontSize: 17,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 1,
                childAspectRatio: (1 / 0.23),
                children: <Widget>[
                  Card(
                    color: const Color(0xFFDEE7E7),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.quiz),
                          title: const Text(
                            'Quiz Score',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (content) =>
                                            SelectQuizListScreen(
                                              admin: widget.admin,
                                              user: widget.user,
                                              quizList: quizList,
                                            )));
                              },
                              icon: const Icon(
                                Icons.arrow_right,
                                size: 30,
                              ),
                              color: const Color(0xFFF9A03F)),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    color: const Color(0xFFDEE7E7),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.videogame_asset_rounded),
                          title: const Text(
                            'Game Score',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (content) =>
                                            SelectGameListScreen(
                                              admin: widget.admin,
                                              user: widget.user,
                                              gameList: gameList,
                                            )));
                              },
                              icon: const Icon(
                                Icons.arrow_right,
                                size: 30,
                              ),
                              color: const Color(0xFFF9A03F)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectQuizListScreen extends StatefulWidget {
  final User user;
  final Admin admin;
  final List<Quiz> quizList;
  const SelectQuizListScreen({
    Key? key,
    required this.user,
    required this.admin,
    required this.quizList,
  }) : super(key: key);

  @override
  State<SelectQuizListScreen> createState() => _SelectQuizListScreenState();
}

class _SelectQuizListScreenState extends State<SelectQuizListScreen> {
  late double screenHeight, screenWidth, resWidth;
  List<Quiz> quizList = <Quiz>[];
  String titlecenter = "";

  @override
  void initState() {
    super.initState();
    _loadQuizList();
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
          'Manage Score for',
          style: TextStyle(
            fontSize: 17,
          ),
        ),
      ),
      body: quizList.isEmpty
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
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 1,
                      childAspectRatio: (1 / 0.23),
                      children: List.generate(quizList.length, (index) {
                        return InkWell(
                          onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (content) => QuizScoreScreen(
                                          admin: widget.admin,
                                          user: widget.user,
                                          quizList: quizList[index],
                                        )))
                          },
                          child: Card(
                              color: const Color(0xFFDEE7E7),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.quiz),
                                    title: Text(
                                      quizList[index].quizTitle.toString(),
                                      style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    trailing: const Icon(Icons.arrow_right,
                                        size: 30, color: Color(0xFFF9A03F)),
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

  void _loadQuizList() {
    http
        .post(
      Uri.parse(CONSTANTS.server + "/hellojava/php/load_quizlist.php"),
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
        if (extractdata['quizList'] != null) {
          quizList = <Quiz>[];
          extractdata['quizList'].forEach((v) {
            quizList.add(Quiz.fromJson(v));
          });
        } else {
          titlecenter = "No quiz available";
          quizList.clear();
        }
        setState(() {});
      } else {
        //do something
        titlecenter = "No quiz available";
        quizList.clear();
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

class QuizScoreScreen extends StatefulWidget {
  final Admin admin;
  final User user;
  final Quiz quizList;
  QuizScoreScreen({
    Key? key,
    required this.admin,
    required this.user,
    required this.quizList,
  }) : super(key: key);

  @override
  State<QuizScoreScreen> createState() => _QuizScoreScreenState();
}

class _QuizScoreScreenState extends State<QuizScoreScreen> {
  late double screenHeight, screenWidth, resWidth;
  List<Quiz> quizList = <Quiz>[];
  String titlecenter = "";
  Widget _verticalDivider = const VerticalDivider(
    thickness: 2,
  );

  @override
  void initState() {
    super.initState();
    _loadQuizScore(widget.quizList.quizId);
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
          'Manage Quiz Score',
          style: TextStyle(
            fontSize: 17,
          ),
        ),
      ),
      body: quizList.isEmpty
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
                          columnSpacing: 6.0,
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
                              'Date Time',
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
                            DataColumn(label: _verticalDivider),
                            const DataColumn(label: Text('')),
                          ],
                          rows: List<DataRow>.generate(
                            quizList.length,
                            (index) => DataRow(
                              cells: [
                                DataCell(Center(
                                  child: Text(
                                    (index + 1).toString(),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                    ),
                                  ),
                                )),
                                DataCell(_verticalDivider),
                                DataCell(Text(
                                  quizList[index].quizDate.toString(),
                                  style: const TextStyle(
                                      fontSize: 13, color: Colors.black),
                                )),
                                DataCell(_verticalDivider),
                                DataCell(Center(
                                  child: Text(
                                    quizList[index].totalScore.toString(),
                                    style: const TextStyle(
                                        fontSize: 13, color: Colors.black),
                                  ),
                                )),
                                DataCell(_verticalDivider),
                                DataCell(
                                  IconButton(
                                      onPressed: () =>
                                          _confirmationDelete(index),
                                      icon: const Center(
                                        child: Icon(
                                          Icons.delete,
                                          size: 20.0,
                                          color: Color(0xFFF9A03F),
                                        ),
                                      )),
                                ),
                              ],
                            ),
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

  void _loadQuizScore(String? quizId) {
    http.post(
      Uri.parse(CONSTANTS.server + "/hellojava/php/load_quizscore.php"),
      body: {
        'id': widget.user.id.toString(),
        'quiz_id': widget.quizList.quizId.toString(),
      },
    ).timeout(
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
        if (extractdata['quizscore'] != null) {
          quizList = <Quiz>[];
          extractdata['quizscore'].forEach((v) {
            quizList.add(Quiz.fromJson(v));
          });
        } else {
          titlecenter = "No quiz score available";
          quizList.clear();
        }
        setState(() {});
      } else {
        titlecenter = "No quiz score available";
        quizList.clear();
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

  _confirmationDelete(int index) {
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
                      'Delete quiz score?',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 25),
                    child: Text(
                      'Are you sure want to delete this quiz score?',
                      style: TextStyle(fontSize: 15),
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
                          onPressed: () {
                            Navigator.of(context).pop();
                            _deleteScore(index);
                          },
                          child: const Text('Delete'),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 48,
                        color: Colors.grey,
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
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

  void _deleteScore(int index) async {
    var url =
        Uri.parse(CONSTANTS.server + "/hellojava/php/delete_quizscore.php");
    var response = await http.post(url, body: {
      'quiz_id': quizList[index].quizId.toString(),
      "score_id": quizList[index].scoreId.toString(),
      "email": widget.user.email.toString(),
    });
    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              jsondata['data'],
              style: const TextStyle(color: Color(0xFFF4FAFF)),
              textAlign: TextAlign.center,
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: const Color(0xFF4F646F),
            behavior: SnackBarBehavior
                .fixed, // Ensures the snackbar sticks to the bottom
          ),
        );
        setState(() {
          _loadQuizScore(widget.quizList.quizId);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              jsondata['data'],
              style: const TextStyle(color: Color(0xFFF4FAFF)),
              textAlign: TextAlign.center,
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: const Color(0xFFAB3232),
            behavior: SnackBarBehavior
                .fixed, // Ensures the snackbar sticks to the bottom
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Failed to delete quiz score",
            style: const TextStyle(color: Color(0xFFF4FAFF)),
            textAlign: TextAlign.center,
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: const Color(0xFFAB3232),
          behavior: SnackBarBehavior
              .fixed, // Ensures the snackbar sticks to the bottom
        ),
      );
    }
  }
}

class SelectGameListScreen extends StatefulWidget {
  final User user;
  final Admin admin;
  final List<Game> gameList;
  const SelectGameListScreen({
    Key? key,
    required this.user,
    required this.admin,
    required this.gameList,
  }) : super(key: key);

  @override
  State<SelectGameListScreen> createState() => _SelectGameListScreenState();
}

class _SelectGameListScreenState extends State<SelectGameListScreen> {
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
          'Manage Score for',
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
              padding: const EdgeInsets.all(20),
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
                                    builder: (content) => GameScoreScreen(
                                          admin: widget.admin,
                                          user: widget.user,
                                          gameList: gameList[index],
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
                                    trailing: const Icon(Icons.arrow_right,
                                        size: 30, color: Color(0xFFF9A03F)),
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
        if (extractdata['gameList'] != null) {
          gameList = <Game>[];
          extractdata['gameList'].forEach((v) {
            gameList.add(Game.fromJson(v));
          });
        } else {
          titlecenter = "No game list available";
          gameList.clear();
        }
        setState(() {});
      } else {
        //do something
        titlecenter = "No game list available";
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

class GameScoreScreen extends StatefulWidget {
  final Admin admin;
  final User user;
  final Game gameList;
  GameScoreScreen({
    Key? key,
    required this.admin,
    required this.user,
    required this.gameList,
  }) : super(key: key);

  @override
  State<GameScoreScreen> createState() => _GameScoreScreenState();
}

class _GameScoreScreenState extends State<GameScoreScreen> {
  late double screenHeight, screenWidth, resWidth;
  List<Game> gameList = <Game>[];
  String titlecenter = "";
  Widget _verticalDivider = const VerticalDivider(
    thickness: 2,
  );

  @override
  void initState() {
    super.initState();
    _loadGameScore(widget.gameList.gameId);
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
          'Manage Game Score',
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
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
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
                          columnSpacing: 6.0,
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
                              'Date Time',
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
                            DataColumn(label: _verticalDivider),
                            const DataColumn(label: Text('')),
                          ],
                          rows: List<DataRow>.generate(
                            gameList.length,
                            (index) => DataRow(
                              cells: [
                                DataCell(Center(
                                  child: Text(
                                    (index + 1).toString(),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                    ),
                                  ),
                                )),
                                DataCell(_verticalDivider),
                                DataCell(Text(
                                  gameList[index].gameDate.toString(),
                                  style: const TextStyle(
                                      fontSize: 13, color: Colors.black),
                                )),
                                DataCell(_verticalDivider),
                                DataCell(Center(
                                  child: Text(
                                    gameList[index].totalScore.toString(),
                                    style: const TextStyle(
                                        fontSize: 13, color: Colors.black),
                                  ),
                                )),
                                DataCell(_verticalDivider),
                                DataCell(
                                  IconButton(
                                      onPressed: () =>
                                          _confirmationDelete(index),
                                      icon: const Center(
                                        child: Icon(
                                          Icons.delete,
                                          size: 20.0,
                                          color: Color(0xFFF9A03F),
                                        ),
                                      )),
                                ),
                              ],
                            ),
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

  void _loadGameScore(String? gameId) {
    http.post(
      Uri.parse(CONSTANTS.server + "/hellojava/php/load_gamescore.php"),
      body: {
        'id': widget.user.id.toString(),
        'game_id': widget.gameList.gameId.toString(),
      },
    ).timeout(
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
          titlecenter = "No game score available";
          gameList.clear();
        }
        setState(() {});
      } else {
        titlecenter = "No game score available";
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

  _confirmationDelete(int index) {
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
                      "Delete game score?",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 25),
                    child: Text(
                      'Are you sure want to delete this game score?',
                      style: TextStyle(fontSize: 15),
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
                          onPressed: () {
                            Navigator.of(context).pop();
                            _deleteScore(index);
                          },
                          child: const Text('Delete'),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 48,
                        color: Colors.grey,
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
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

  void _deleteScore(int index) async {
    var url =
        Uri.parse(CONSTANTS.server + "/hellojava/php/delete_gamescore.php");
    var response = await http.post(url, body: {
      'game_id': gameList[index].gameId.toString(),
      "score_id": gameList[index].scoreId.toString(),
      "email": widget.user.email.toString(),
    });
    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              jsondata['data'],
              style: const TextStyle(color: Color(0xFFF4FAFF)),
              textAlign: TextAlign.center,
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: const Color(0xFF4F646F),
            behavior: SnackBarBehavior
                .fixed, // Ensures the snackbar sticks to the bottom
          ),
        );
        setState(() {
          _loadGameScore(widget.gameList.gameId);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              jsondata['data'],
              style: const TextStyle(color: Color(0xFFF4FAFF)),
              textAlign: TextAlign.center,
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: const Color(0xFFAB3232),
            behavior: SnackBarBehavior
                .fixed, // Ensures the snackbar sticks to the bottom
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Failed to delete game score",
            style: const TextStyle(color: Color(0xFFF4FAFF)),
            textAlign: TextAlign.center,
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: const Color(0xFFAB3232),
          behavior: SnackBarBehavior
              .fixed, // Ensures the snackbar sticks to the bottom
        ),
      );
    }
  }
}
