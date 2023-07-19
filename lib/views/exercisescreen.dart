import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hellojava/constants.dart';
import 'package:hellojava/views/loginscreen.dart';
import 'package:hellojava/views/registerscreen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/topic.dart';
import '../models/user.dart';

class ExerciseScreen extends StatefulWidget {
  final User user;
  const ExerciseScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  late double screenHeight, screenWidth, resWidth;
  List<Topic> topicList = <Topic>[];
  String titlecenter = "";

  @override
  void initState() {
    super.initState();
    _loadExercises();
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
      body: topicList.isEmpty
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
                  Row(
                    children: const [
                      Icon(Icons.flag_outlined, color: Color(0xFFF9A03F)),
                      SizedBox(width: 10),
                      Text(
                        "Java Exercise",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 1,
                      childAspectRatio: (1 / 0.23),
                      children: List.generate(topicList.length, (index) {
                        return InkWell(
                          onTap: () => {_clickExerciseButton(index)},
                          child: Card(
                              color: const Color(0xFFDEE7E7),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.check_box),
                                    title: Text(
                                      topicList[index].topicTitle.toString(),
                                      style: const TextStyle(
                                          fontSize: 15,
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

  void _loadExercises() {
    http
        .post(
      Uri.parse(CONSTANTS.server + "/hellojava/php/load_topics.php"),
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
        if (extractdata['topic'] != null) {
          topicList = <Topic>[];
          extractdata['topic'].forEach((v) {
            topicList.add(Topic.fromJson(v));
          });
        } else {
          titlecenter = "No Exercise available";
          topicList.clear();
        }
        setState(() {});
      } else {
        titlecenter = "No Exercise available";
        topicList.clear();
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

  _clickExerciseButton(int index) {
    if (widget.user.email == "guest@hellojava.com") {
      _loadOptions();
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (content) => SubExerciseScreen(
                    user: widget.user,
                    index: index,
                    topicList: topicList,
                  )));
    }
  }

  _loadOptions() {
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
                  "Please login first!",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                        Navigator.pop(context);
                        _onLogin();
                      },
                      child: const Text(
                        'Login',
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
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
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
        );
      },
    );
  }

  void _onLogin() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => const LoginScreen()));
  }
}

class SubExerciseScreen extends StatefulWidget {
  final User user;
  int index;
  final List<Topic> topicList;
  SubExerciseScreen({
    Key? key,
    required this.user,
    required this.index,
    required this.topicList,
  }) : super(key: key);

  @override
  State<SubExerciseScreen> createState() => _SubExerciseScreenState();
}

class _SubExerciseScreenState extends State<SubExerciseScreen> {
  late double screenHeight, screenWidth, resWidth;
  List<Topic> topicList = <Topic>[];
  List<Exercise> exerciseList = <Exercise>[];
  String titlecenter = "";

  @override
  void initState() {
    super.initState();
    _loadExerciseList();
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
          widget.topicList[widget.index].topicTitle.toString(),
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      body: exerciseList.isEmpty
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
                  Row(
                    children: const [
                      Icon(
                        Icons.lightbulb,
                        size: 24.0,
                        color: Color(0xFFF9A03F),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Exercise List",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 1,
                      childAspectRatio: (1 / 0.23),
                      children: List.generate(exerciseList.length, (index) {
                        return InkWell(
                          onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (content) => ExerciseDetailsScreen(
                                          user: widget.user,
                                          index: index,
                                          topicList: topicList,
                                          exerciseList: exerciseList,
                                        )))
                          },
                          child: Card(
                              color: const Color(0xFFDEE7E7),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: const Icon(
                                        Icons.question_answer_rounded),
                                    title: Text(
                                      exerciseList[index]
                                          .exerciseTitle
                                          .toString(),
                                      style: const TextStyle(
                                          fontSize: 15,
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

  void _loadExerciseList() {
    http.post(
      Uri.parse(CONSTANTS.server + "/hellojava/php/load_exercises.php"),
      body: {
        'topic_id': widget.topicList[widget.index].topicId.toString(),
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
        if (extractdata['exercise'] != null) {
          exerciseList = <Exercise>[];
          extractdata['exercise'].forEach((v) {
            exerciseList.add(Exercise.fromJson(v));
          });
        } else {
          titlecenter = "No exercise available for this topic";
          topicList.clear();
        }
        setState(() {});
      } else {
        //do something
        titlecenter = "No exercise available for this topic";
        topicList.clear();
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

class ExerciseDetailsScreen extends StatefulWidget {
  final User user;
  int index;
  final List<Topic> topicList;
  final List<Exercise> exerciseList;

  ExerciseDetailsScreen({
    Key? key,
    required this.user,
    required this.index,
    required this.topicList,
    required this.exerciseList,
  }) : super(key: key);

  @override
  State<ExerciseDetailsScreen> createState() => _ExerciseDetailsScreenState();
}

class _ExerciseDetailsScreenState extends State<ExerciseDetailsScreen> {
  late double screenHeight, screenWidth, resWidth;
  List<Question> questionList = <Question>[];
  String titlecenter = "";
  int numCorrectAnswers = 0;
  bool _showHint = false;

  @override
  void initState() {
    super.initState();
    _loadExerciseQuestion();
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
          widget.exerciseList[widget.index].exerciseTitle.toString(),
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      body: questionList.isEmpty
          ? Center(
              child: Text(titlecenter,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)))
          : Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(questionList.length, (index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 10.0),
                      child: Card(
                        color: const Color(0xFFDEE7E7),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Question ${index + 1} / ${questionList.length}',
                                    style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF4F646F)),
                                    textAlign: TextAlign.center,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _showHint = true;
                                      });
                                      _showHintDialog(index);
                                    },
                                    icon: Icon(Icons.help_outline),
                                  ),
                                ],
                              ),
                              Text(
                                questionList[index].questionTitle.toString(),
                                style: const TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: 400,
                                height: questionList[index]
                                            .optionA
                                            .toString()
                                            .length >
                                        38
                                    ? 80
                                    : 40,
                                child: ElevatedButton(
                                  onPressed: questionList[index].optionSelectedA
                                      ? null
                                      : () => _submitAnswer(widget.topicList,
                                          questionList[index].optionA, index),
                                  child: Text(
                                    questionList[index].optionA.toString(),
                                    style: const TextStyle(fontSize: 15),
                                    textAlign: TextAlign.center,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        questionList[index].buttonColorA,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: 400,
                                height: questionList[index]
                                            .optionB
                                            .toString()
                                            .length >
                                        38
                                    ? 80
                                    : 40,
                                child: ElevatedButton(
                                  onPressed: questionList[index].optionSelectedB
                                      ? null
                                      : () => _submitAnswer(widget.topicList,
                                          questionList[index].optionB, index),
                                  child: Text(
                                    questionList[index].optionB.toString(),
                                    style: const TextStyle(fontSize: 15),
                                    textAlign: TextAlign.center,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        questionList[index].buttonColorB,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: 400,
                                height: questionList[index]
                                            .optionC
                                            .toString()
                                            .length >
                                        38
                                    ? 80
                                    : 40,
                                child: ElevatedButton(
                                  onPressed: questionList[index].optionSelectedC
                                      ? null
                                      : () => _submitAnswer(widget.topicList,
                                          questionList[index].optionC, index),
                                  child: Text(
                                    questionList[index].optionC.toString(),
                                    style: const TextStyle(fontSize: 15),
                                    textAlign: TextAlign.center,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        questionList[index].buttonColorC,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
      bottomNavigationBar: Container(
        height: 50,
        color: Color(0xFF4F646F),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'You answered ${numCorrectAnswers} out of ${questionList.length} questions correctly.',
                style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFDEE7E7)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _loadExerciseQuestion() {
    http.post(
      Uri.parse(CONSTANTS.server + "/hellojava/php/load_exercisequestions.php"),
      body: {
        'exercise_id': widget.exerciseList[widget.index].exerciseId.toString(),
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
        if (extractdata['exercisequestion'] != null) {
          questionList = <Question>[];
          extractdata['exercisequestion'].forEach((v) {
            questionList.add(Question.fromJson(v));
          });

          // Shuffle the questionList
          questionList.shuffle();
        } else {
          titlecenter = "No question available for this exercise";
          questionList.clear();
        }
        setState(() {});
      } else {
        //do something
        titlecenter = "No question available for this exercise";
        questionList.clear();
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

  void _submitAnswer(List<Topic> topicList, String? selectedOption, int index) {
    if (selectedOption == questionList[index].correctAnswer) {
      // Set button color to green if selected option is correct
      questionList[index].buttonColor = Colors.green;
      numCorrectAnswers++;
    } else {
      // Set button color to red if selected option is incorrect
      questionList[index].buttonColor = Colors.red;
    }

    // Set the button color of the selected option to red/green
    if (selectedOption == questionList[index].optionA) {
      questionList[index].buttonColorA = questionList[index].buttonColor;
      questionList[index].optionSelectedA = false;
      questionList[index].optionSelectedB = true;
      questionList[index].optionSelectedC = true;
    } else if (selectedOption == questionList[index].optionB) {
      questionList[index].buttonColorB = questionList[index].buttonColor;
      questionList[index].optionSelectedA = true;
      questionList[index].optionSelectedB = false;
      questionList[index].optionSelectedC = true;
    } else if (selectedOption == questionList[index].optionC) {
      questionList[index].buttonColorC = questionList[index].buttonColor;
      questionList[index].optionSelectedA = true;
      questionList[index].optionSelectedB = true;
      questionList[index].optionSelectedC = false;
    }
    setState(() {});
  }

  void _showHintDialog(int index) {
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
                      "Hint of the question",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 25),
                    child: Text(
                      questionList[index].hint.toString(),
                      style: const TextStyle(fontSize: 17),
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
                          child: const Text('Close',
                              style: TextStyle(fontSize: 15)),
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
