import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hellojava/constants.dart';
import 'package:hellojava/models/admin.dart';
import 'package:hellojava/models/quiz.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ManageQuizScreen extends StatefulWidget {
  final Admin admin;
  const ManageQuizScreen({
    Key? key,
    required this.admin,
  }) : super(key: key);

  @override
  State<ManageQuizScreen> createState() => _ManageQuizScreenState();
}

class _ManageQuizScreenState extends State<ManageQuizScreen> {
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
          'Manage Quiz',
          style: TextStyle(
            fontSize: 17,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
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
                            'Manage Quiz List',
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
                                            ManageQuizListScreen(
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
                            'Manage Questions',
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

class ManageQuizListScreen extends StatefulWidget {
  final Admin admin;
  const ManageQuizListScreen({
    Key? key,
    required this.admin,
  }) : super(key: key);

  @override
  State<ManageQuizListScreen> createState() => _ManageQuizListScreenState();
}

class _ManageQuizListScreenState extends State<ManageQuizListScreen> {
  late double screenHeight, screenWidth, resWidth;
  List<Quiz> quizList = <Quiz>[];
  String titlecenter = "";
  TextEditingController quizTitleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadQuiz();
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
          'Manage Note Topic',
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
              padding: const EdgeInsets.all(15),
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
                          child: Card(
                              color: const Color(0xFFDEE7E7),
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      quizList[index].quizTitle.toString(),
                                      style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () =>
                                              _editQuizListDialog(index),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Color(0xFFAB3232),
                                          ),
                                          onPressed: () =>
                                              _deleteQuizListDialog(index),
                                        ),
                                      ],
                                    ),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _addQuizListDialog(),
      ),
      bottomNavigationBar: const BottomAppBar(
        color: Color(0xFF4F646F),
        shape: CircularNotchedRectangle(),
        child: SizedBox(
          height: 40,
        ),
      ),
    );
  }

  void _loadQuiz() {
    http
        .post(
      Uri.parse(CONSTANTS.server + "/hellojava/php/load_quiz.php"),
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
        throw SocketException("Connection timed out");
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);
      print(jsondata);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        if (extractdata['quiz'] != null) {
          quizList = <Quiz>[];
          extractdata['quiz'].forEach((v) {
            quizList.add(Quiz.fromJson(v));
          });
        } else {
          titlecenter = "No quiz available";
          quizList.clear();
        }
        setState(() {});
      } else {
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

  _addQuizListDialog() {
    quizTitleController.text = "";
    final _formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 350,
                    child: SingleChildScrollView(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {},
                        child: AlertDialog(
                          backgroundColor: const Color(0xFFF4F4F4),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          title: const Text(
                            "Add quiz?",
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          content: SingleChildScrollView(
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                controller: quizTitleController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  labelText: 'Title',
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  errorStyle:
                                      const TextStyle(color: Color(0xFFAB3232)),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFF9A03F), width: 2),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFF9A03F), width: 2),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the new title';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text(
                                "Confirm",
                                style: TextStyle(),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  Navigator.of(context).pop();
                                  _addQuiz();
                                }
                              },
                            ),
                            TextButton(
                              child: const Text(
                                "Cancel",
                                style: TextStyle(),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                _formKey.currentState!.reset();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _addQuiz() {
    String quizTitle = quizTitleController.text;
    http.post(Uri.parse(CONSTANTS.server + "/hellojava/php/add_quiz.php"),
        body: {
          "quiz_title": quizTitle,
        }).then((response) {
      print(response.body);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
            msg: data['data'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            fontSize: 14,
            backgroundColor: const Color(0xFF4F646F));
        _loadQuiz();
      } else {
        Fluttertoast.showToast(
            msg: data['data'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            fontSize: 14,
            backgroundColor: const Color(0xFFAB3232));
      }
    });
  }

  _editQuizListDialog(int index) {
    quizTitleController.text = quizList[index].quizTitle.toString();
    final _formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 350,
                    child: SingleChildScrollView(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {},
                        child: AlertDialog(
                          backgroundColor: const Color(0xFFF4F4F4),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          title: const Text(
                            "Change title?",
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          content: SingleChildScrollView(
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                controller: quizTitleController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  labelText: 'Title',
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  errorStyle:
                                      const TextStyle(color: Color(0xFFAB3232)),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFF9A03F), width: 2),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFF9A03F), width: 2),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the new title';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text(
                                "Confirm",
                                style: TextStyle(),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  Navigator.of(context).pop();
                                  String newtitle = quizTitleController.text;
                                  _updateTitle(newtitle, index);
                                }
                              },
                            ),
                            TextButton(
                              child: const Text(
                                "Cancel",
                                style: TextStyle(),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                _formKey.currentState!.reset();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _updateTitle(String newtitle, int index) {
    http.post(Uri.parse(CONSTANTS.server + "/hellojava/php/update_quiz.php"),
        body: {
          'quiz_id': quizList[index].quizId,
          "newtitle": newtitle,
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        Fluttertoast.showToast(
            msg: jsondata['data'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            fontSize: 14,
            backgroundColor: const Color(0xFF4F646F));
        _loadQuiz();
      } else {
        Fluttertoast.showToast(
            msg: jsondata['data'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            fontSize: 14,
            backgroundColor: const Color(0xFFAB3232));
      }
    });
  }

  _deleteQuizListDialog(int index) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFF4F4F4),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: const Text(
          'Delete quiz?',
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
        content: const Text('Are you sure want to delete this quiz?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteQuiz(index);
            },
            child: const Text('Delete'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _deleteQuiz(int index) async {
    var url = Uri.parse(CONSTANTS.server + "/hellojava/php/delete_quiz.php");
    var response = await http.post(url, body: {
      'quiz_id': quizList[index].quizId.toString(),
    });
    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == 'success') {
        Fluttertoast.showToast(
            msg: jsondata['data'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            fontSize: 14,
            backgroundColor: const Color(0xFF4F646F));
        setState(() {
          _loadQuiz();
        });
      } else {
        Fluttertoast.showToast(
            msg: jsondata['data'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            fontSize: 14,
            backgroundColor: const Color(0xFFAB3232));
      }
    } else {
      Fluttertoast.showToast(
          msg: "Failed to delete subtopic",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          fontSize: 14,
          backgroundColor: const Color(0xFFAB3232));
    }
  }
}

class SelectQuizListScreen extends StatefulWidget {
  final Admin admin;
  const SelectQuizListScreen({
    Key? key,
    required this.admin,
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
    _loadQuiz();
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
          'Select Quiz',
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
              padding: const EdgeInsets.all(15),
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
                                    builder: (content) =>
                                        ManageQuizQuestionScreen(
                                          admin: widget.admin,
                                          index: index,
                                          quizList: quizList,
                                        ))),
                          },
                          child: Card(
                              color: const Color(0xFFDEE7E7),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.check_box),
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

  void _loadQuiz() {
    http
        .post(
      Uri.parse(CONSTANTS.server + "/hellojava/php/load_quiz.php"),
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
        throw SocketException("Connection timed out");
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);
      print(jsondata);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        if (extractdata['quiz'] != null) {
          quizList = <Quiz>[];
          extractdata['quiz'].forEach((v) {
            quizList.add(Quiz.fromJson(v));
          });
        } else {
          titlecenter = "No quiz available";
          quizList.clear();
        }
        setState(() {});
      } else {
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

class ManageQuizQuestionScreen extends StatefulWidget {
  final Admin admin;
  int index;
  final List<Quiz> quizList;
  ManageQuizQuestionScreen({
    Key? key,
    required this.admin,
    required this.index,
    required this.quizList,
  }) : super(key: key);

  @override
  State<ManageQuizQuestionScreen> createState() =>
      _ManageQuizQuestionScreenState();
}

class _ManageQuizQuestionScreenState extends State<ManageQuizQuestionScreen> {
  late double screenHeight, screenWidth, resWidth;
  List<QuizQuestion> quizquestionList = <QuizQuestion>[];
  String titlecenter = "";

  @override
  void initState() {
    super.initState();
    _loadQuizQuestion();
  }

  void refreshExerciseQuestion() {
    _loadQuizQuestion();
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
          'Manage Quiz Questions',
          style: TextStyle(
            fontSize: 17,
          ),
        ),
      ),
      body: quizquestionList.isEmpty
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
                      children: List.generate(quizquestionList.length, (index) {
                        return InkWell(
                          child: Card(
                              color: const Color(0xFFDEE7E7),
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      'Question ' + (index + 1).toString(),
                                      style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (content) =>
                                                        EditQuizQuestionScreen(
                                                          admin: widget.admin,
                                                          quizquestionList:
                                                              quizquestionList[
                                                                  index],
                                                          onSubtopicUpdated:
                                                              refreshExerciseQuestion,
                                                        )));
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Color(0xFFAB3232),
                                          ),
                                          onPressed: () =>
                                              _deleteQuizQuestionDialog(index),
                                        ),
                                      ],
                                    ),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (content) => AddQuizQuestionScreen(
                        admin: widget.admin,
                        quizList: widget.quizList[widget.index],
                        onSubtopicUpdated: refreshExerciseQuestion,
                      )));
        },
      ),
      bottomNavigationBar: const BottomAppBar(
        color: Color(0xFF4F646F),
        shape: CircularNotchedRectangle(),
        child: SizedBox(
          height: 40,
        ),
      ),
    );
  }

  void _loadQuizQuestion() {
    http.post(
      Uri.parse(CONSTANTS.server + "/hellojava/php/load_quizquestions.php"),
      body: {
        'quiz_id': widget.quizList[widget.index].quizId.toString(),
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
        throw SocketException("Connection timed out");
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);
      print(jsondata);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        if (extractdata['quizquestion'] != null) {
          quizquestionList = <QuizQuestion>[];
          extractdata['quizquestion'].forEach((v) {
            quizquestionList.add(QuizQuestion.fromJson(v));
          });
        } else {
          titlecenter = "No question available for this quiz";
          quizquestionList.clear();
        }
        setState(() {});
      } else {
        //do something
        titlecenter = "No question available for this quiz";
        quizquestionList.clear();
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

  _deleteQuizQuestionDialog(index) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFF4F4F4),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: const Text(
          'Delete question?',
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
        content: const Text('Are you sure want to delete this question?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteQuestion(index);
            },
            child: const Text('Delete'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _deleteQuestion(index) async {
    var url =
        Uri.parse(CONSTANTS.server + "/hellojava/php/delete_quizquestion.php");
    var response = await http.post(url, body: {
      'quiz_id': widget.quizList[widget.index].quizId,
      'question_id': quizquestionList[index].questionId.toString(),
    });
    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == 'success') {
        Fluttertoast.showToast(
            msg: jsondata['data'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            fontSize: 14,
            backgroundColor: const Color(0xFF4F646F));
        setState(() {
          _loadQuizQuestion();
        });
      } else {
        Fluttertoast.showToast(
            msg: jsondata['data'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            fontSize: 14,
            backgroundColor: const Color(0xFFAB3232));
      }
    } else {
      Fluttertoast.showToast(
          msg: "Failed to delete question",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          fontSize: 14,
          backgroundColor: const Color(0xFFAB3232));
    }
  }
}

class AddQuizQuestionScreen extends StatefulWidget {
  final Admin admin;
  final Quiz quizList;
  final Function() onSubtopicUpdated;
  AddQuizQuestionScreen({
    Key? key,
    required this.admin,
    required this.quizList,
    required this.onSubtopicUpdated,
  }) : super(key: key);

  @override
  State<AddQuizQuestionScreen> createState() => _AddQuizQuestionScreenState();
}

class _AddQuizQuestionScreenState extends State<AddQuizQuestionScreen> {
  late double screenHeight, screenWidth, resWidth;
  List<QuizQuestion> quizquestionList = <QuizQuestion>[];
  final _formKey = GlobalKey<FormState>();
  TextEditingController questionTitleController = TextEditingController();
  TextEditingController optionAController = TextEditingController();
  TextEditingController optionBController = TextEditingController();
  TextEditingController optionCController = TextEditingController();
  TextEditingController correctAnswerController = TextEditingController();

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
          'Add Quiz Question',
          style: TextStyle(
            fontSize: 17,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: resWidth,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32, 25, 32, 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: questionTitleController,
                                maxLines: null,
                                decoration: InputDecoration(
                                  isDense: true,
                                  prefixIcon: const Icon(Icons.title),
                                  labelText: 'Question',
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF4F646F),
                                    ),
                                  ),
                                  errorStyle:
                                      const TextStyle(color: Color(0xFFAB3232)),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFF9A03F), width: 2),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFF9A03F), width: 2),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the question';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: optionAController,
                                maxLength: 100,
                                decoration: InputDecoration(
                                  isDense: true,
                                  prefixIcon: const Icon(Icons.list),
                                  labelText: 'Option A',
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF4F646F),
                                    ),
                                  ),
                                  errorStyle:
                                      const TextStyle(color: Color(0xFFAB3232)),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFF9A03F), width: 2),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFF9A03F), width: 2),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the option A of this question';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: optionBController,
                                maxLength: 100,
                                decoration: InputDecoration(
                                  isDense: true,
                                  prefixIcon: const Icon(Icons.list),
                                  labelText: 'Option B',
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF4F646F),
                                    ),
                                  ),
                                  errorStyle:
                                      const TextStyle(color: Color(0xFFAB3232)),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFF9A03F), width: 2),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFF9A03F), width: 2),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the option B of this question';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: optionCController,
                                maxLength: 100,
                                decoration: InputDecoration(
                                  isDense: true,
                                  prefixIcon: const Icon(Icons.list),
                                  labelText: 'Option C',
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF4F646F),
                                    ),
                                  ),
                                  errorStyle:
                                      const TextStyle(color: Color(0xFFAB3232)),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFF9A03F), width: 2),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFF9A03F), width: 2),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the option C of this question';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: correctAnswerController,
                                maxLength: 100,
                                decoration: InputDecoration(
                                  isDense: true,
                                  prefixIcon: const Icon(Icons.done),
                                  labelText: 'Correct Answer',
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF4F646F),
                                    ),
                                  ),
                                  errorStyle:
                                      const TextStyle(color: Color(0xFFAB3232)),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFF9A03F), width: 2),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFF9A03F), width: 2),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the correct answer of this question';
                                  }
                                  if (value != optionAController.text &&
                                      value != optionBController.text &&
                                      value != optionCController.text) {
                                    return 'The correct answer must match one of the options';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              Container(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  width: screenWidth,
                                  height: 50,
                                  child: ElevatedButton(
                                    child: const Text(
                                      "Add Question",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: _addQuestiondialog,
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18.0))),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        const Color(0xFFF9A03F),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _addQuestiondialog() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
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
                "Add new question?",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              content: const Text("Are you sure want to add new question?"),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    "Yes",
                    style: TextStyle(),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    _addQuestion();
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
      );
    }
  }

  void _addQuestion() {
    String questionTitle = questionTitleController.text;
    String optionA = optionAController.text;
    String optionB = optionBController.text;
    String optionC = optionCController.text;
    String correctAnswer = correctAnswerController.text;
    http.post(
        Uri.parse(CONSTANTS.server + "/hellojava/php/add_quizquestion.php"),
        body: {
          "quiz_id": widget.quizList.quizId,
          "question_title": questionTitle,
          "option_a": optionA,
          "option_b": optionB,
          "option_c": optionC,
          "correct_answer": correctAnswer,
        }).then((response) {
      print(response.body);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
            msg: data['data'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            fontSize: 14,
            backgroundColor: const Color(0xFF4F646F));
        Navigator.pop(context);
        widget.onSubtopicUpdated();
      } else {
        Fluttertoast.showToast(
            msg: data['data'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            fontSize: 14,
            backgroundColor: const Color(0xFFAB3232));
      }
    });
  }
}

class EditQuizQuestionScreen extends StatefulWidget {
  final Admin admin;
  final QuizQuestion quizquestionList;
  final Function() onSubtopicUpdated;
  EditQuizQuestionScreen({
    Key? key,
    required this.admin,
    required this.quizquestionList,
    required this.onSubtopicUpdated,
  }) : super(key: key);

  @override
  State<EditQuizQuestionScreen> createState() => _EditQuizQuestionScreenState();
}

class _EditQuizQuestionScreenState extends State<EditQuizQuestionScreen> {
  late double screenHeight, screenWidth, resWidth;
  TextEditingController questionTitleController = TextEditingController();
  TextEditingController optionAController = TextEditingController();
  TextEditingController optionBController = TextEditingController();
  TextEditingController optionCController = TextEditingController();
  TextEditingController correctAnswerController = TextEditingController();
  List<Quiz> quizList = <Quiz>[];
  List<QuizQuestion> quizquestionList = <QuizQuestion>[];

  @override
  void initState() {
    super.initState();
    questionTitleController.text =
        widget.quizquestionList.questionTitle.toString();
    optionAController.text = widget.quizquestionList.optionA.toString();
    optionBController.text = widget.quizquestionList.optionB.toString();
    optionCController.text = widget.quizquestionList.optionC.toString();
    correctAnswerController.text =
        widget.quizquestionList.correctAnswer.toString();
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
          'Edit Quiz Question',
          style: TextStyle(
            fontSize: 17,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
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
                          leading: const Icon(Icons.title),
                          title: const Text(
                            'Change Question',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                _updateQuestionDialog();
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
                          leading: const Icon(Icons.list),
                          title: const Text(
                            'Change Option and Correct Answer',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                _updateOptionNCorrectAnsDialog();
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

  void _updateQuestionDialog() {
    final _formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 350,
                    child: SingleChildScrollView(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {},
                        child: AlertDialog(
                          backgroundColor: const Color(0xFFF4F4F4),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          title: const Text(
                            "Change question?",
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          content: SingleChildScrollView(
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                controller: questionTitleController,
                                maxLines: null,
                                decoration: InputDecoration(
                                  isDense: true,
                                  labelText: 'Question',
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  errorStyle:
                                      const TextStyle(color: Color(0xFFAB3232)),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFF9A03F), width: 2),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFF9A03F), width: 2),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the new question';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text(
                                "Confirm",
                                style: TextStyle(),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  Navigator.of(context).pop();
                                  String newquestion =
                                      questionTitleController.text;
                                  _updateQuestion(newquestion);
                                }
                              },
                            ),
                            TextButton(
                              child: const Text(
                                "Cancel",
                                style: TextStyle(),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                _formKey.currentState!.reset();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _updateQuestion(String newquestion) async {
    http.post(
        Uri.parse(CONSTANTS.server + "/hellojava/php/update_quizquestion.php"),
        body: {
          'question_id': widget.quizquestionList.questionId,
          "newquestion": newquestion,
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
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
        widget.onSubtopicUpdated();
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
    });
  }

  void _updateOptionNCorrectAnsDialog() {
    final _formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: screenHeight / 1.3,
                    child: SingleChildScrollView(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {},
                        child: AlertDialog(
                          backgroundColor: const Color(0xFFF4F4F4),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          title: const Text(
                            "Change option and correct answer?",
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          content: SingleChildScrollView(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: optionAController,
                                    maxLength: 100,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      labelText: 'Option A',
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      errorStyle: const TextStyle(
                                          color: Color(0xFFAB3232)),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFF9A03F), width: 2),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFF9A03F), width: 2),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter the new option A of this question';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 5),
                                  TextFormField(
                                    controller: optionBController,
                                    maxLength: 100,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      labelText: 'Option B',
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      errorStyle: const TextStyle(
                                          color: Color(0xFFAB3232)),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFF9A03F), width: 2),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFF9A03F), width: 2),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter the new option B of this question';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 5),
                                  TextFormField(
                                    controller: optionCController,
                                    maxLength: 100,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      labelText: 'Option C',
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      errorStyle: const TextStyle(
                                          color: Color(0xFFAB3232)),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFF9A03F), width: 2),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFF9A03F), width: 2),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter the new option C of this question';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 5),
                                  TextFormField(
                                    controller: correctAnswerController,
                                    maxLength: 100,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      labelText: 'Correct Answer',
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      errorStyle: const TextStyle(
                                          color: Color(0xFFAB3232)),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFF9A03F), width: 2),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFF9A03F), width: 2),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter the new correct answer of this question';
                                      }
                                      if (value != optionAController.text &&
                                          value != optionBController.text &&
                                          value != optionCController.text) {
                                        return 'The correct answer must match one of the options';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text(
                                "Confirm",
                                style: TextStyle(),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  Navigator.of(context).pop();
                                  String optionA = optionAController.text;
                                  String optionB = optionBController.text;
                                  String optionC = optionCController.text;
                                  String correctAnswer =
                                      correctAnswerController.text;
                                  _changeOptionNAnswer(
                                      optionA, optionB, optionC, correctAnswer);
                                }
                              },
                            ),
                            TextButton(
                              child: const Text(
                                "Cancel",
                                style: TextStyle(),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                _formKey.currentState!.reset();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _changeOptionNAnswer(
      String optionA, String optionB, String optionC, String correctAnswer) {
    http.post(
        Uri.parse(CONSTANTS.server + "/hellojava/php/update_quizquestion.php"),
        body: {
          'question_id': widget.quizquestionList.questionId,
          "optionA": optionA,
          "optionB": optionB,
          "optionC": optionC,
          "correctAnswer": correctAnswer,
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
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
        widget.onSubtopicUpdated();
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
    });
  }
}
