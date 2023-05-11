import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hellojava/constants.dart';
import 'package:hellojava/models/topic.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:hellojava/models/admin.dart';

class ManageExerciseScreen extends StatefulWidget {
  final Admin admin;
  const ManageExerciseScreen({
    Key? key,
    required this.admin,
  }) : super(key: key);

  @override
  State<ManageExerciseScreen> createState() => _ManageExerciseScreenState();
}

class _ManageExerciseScreenState extends State<ManageExerciseScreen> {
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
          'Manage Exercise',
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
                            'Manage Exercise List',
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
                                        builder: (content) => SelectTopicScreen(
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
                                            SelectTopicScreen2(
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

class SelectTopicScreen extends StatefulWidget {
  final Admin admin;
  const SelectTopicScreen({
    Key? key,
    required this.admin,
  }) : super(key: key);

  @override
  State<SelectTopicScreen> createState() => _SelectTopicScreenState();
}

class _SelectTopicScreenState extends State<SelectTopicScreen> {
  late double screenHeight, screenWidth, resWidth;
  List<Topic> topicList = <Topic>[];
  List<Exercise> exerciseList = <Exercise>[];
  String titlecenter = "";

  @override
  void initState() {
    super.initState();
    _loadTopics();
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
          'Select Exercise Topic',
          style: TextStyle(
            fontSize: 17,
          ),
        ),
      ),
      body: topicList.isEmpty
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
                      children: List.generate(topicList.length, (index) {
                        return InkWell(
                          onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (content) =>
                                        ManageExerciseListScreen(
                                          admin: widget.admin,
                                          index: index,
                                          topicList: topicList,
                                          exerciseList: exerciseList,
                                        ))),
                          },
                          child: Card(
                              color: const Color(0xFFDEE7E7),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.check_box),
                                    title: Text(
                                      topicList[index].topicTitle.toString(),
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

  void _loadTopics() {
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
          titlecenter = "No exercise available";
          topicList.clear();
        }
        setState(() {});
      } else {
        titlecenter = "No exercise available";
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

class ManageExerciseListScreen extends StatefulWidget {
  final Admin admin;
  int index;
  final List<Topic> topicList;
  final List<Exercise> exerciseList;
  ManageExerciseListScreen({
    Key? key,
    required this.admin,
    required this.index,
    required this.topicList,
    required this.exerciseList,
  }) : super(key: key);

  @override
  State<ManageExerciseListScreen> createState() =>
      _ManageExerciseListScreenState();
}

class _ManageExerciseListScreenState extends State<ManageExerciseListScreen> {
  late double screenHeight, screenWidth, resWidth;
  List<Topic> topicList = <Topic>[];
  List<Exercise> exerciseList = <Exercise>[];
  String titlecenter = "";
  TextEditingController exerciseTitleController = TextEditingController();

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
        title: const Text(
          'Manage Exercise List',
          style: TextStyle(
            fontSize: 17,
          ),
        ),
      ),
      body: exerciseList.isEmpty
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
                      children: List.generate(exerciseList.length, (index) {
                        return InkWell(
                          child: Card(
                              color: const Color(0xFFDEE7E7),
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      exerciseList[index]
                                          .exerciseTitle
                                          .toString(),
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
                                              _editExerciseListDialog(index),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Color(0xFFAB3232),
                                          ),
                                          onPressed: () =>
                                              _deleteExerciseListDialog(index),
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
        onPressed: () => _addExerciseListDialog(),
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

  _addExerciseListDialog() {
    exerciseTitleController.text = "";
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
                            "Add exercise?",
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          content: SingleChildScrollView(
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                controller: exerciseTitleController,
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
                                  _addExercise();
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

  void _addExercise() {
    String exerciseTitle = exerciseTitleController.text;
    http.post(Uri.parse(CONSTANTS.server + "/hellojava/php/add_exercises.php"),
        body: {
          "topic_id": widget.topicList[widget.index].topicId,
          "exercise_title": exerciseTitle,
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
        _loadExerciseList();
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

  _editExerciseListDialog(int index) {
    exerciseTitleController.text = exerciseList[index].exerciseTitle.toString();
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
                                controller: exerciseTitleController,
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
                                  String newtitle =
                                      exerciseTitleController.text;
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
    http.post(
        Uri.parse(CONSTANTS.server + "/hellojava/php/update_exercises.php"),
        body: {
          'topic_id': widget.topicList[widget.index].topicId,
          'exercise_id': exerciseList[index].exerciseId,
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
        _loadExerciseList();
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

  _deleteExerciseListDialog(int index) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFF4F4F4),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: const Text(
          'Delete exercise?',
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
        content: const Text('Are you sure want to delete this exercise?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteExercise(index);
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

  void _deleteExercise(int index) async {
    var url =
        Uri.parse(CONSTANTS.server + "/hellojava/php/delete_exercises.php");
    var response = await http.post(url, body: {
      'topic_id': widget.topicList[widget.index].topicId,
      'exercise_id': exerciseList[index].exerciseId.toString(),
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
          _loadExerciseList();
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
          msg: "Failed to delete exercise",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          fontSize: 14,
          backgroundColor: const Color(0xFFAB3232));
    }
  }
}

class SelectTopicScreen2 extends StatefulWidget {
  final Admin admin;
  const SelectTopicScreen2({
    Key? key,
    required this.admin,
  }) : super(key: key);

  @override
  State<SelectTopicScreen2> createState() => _SelectTopicScreen2State();
}

class _SelectTopicScreen2State extends State<SelectTopicScreen2> {
  late double screenHeight, screenWidth, resWidth;
  List<Topic> topicList = <Topic>[];
  String titlecenter = "";

  @override
  void initState() {
    super.initState();
    _loadTopics();
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
          'Select Exercise Topic',
          style: TextStyle(
            fontSize: 17,
          ),
        ),
      ),
      body: topicList.isEmpty
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
                      children: List.generate(topicList.length, (index) {
                        return InkWell(
                          onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (content) =>
                                        SelectExerciseListScreen(
                                          admin: widget.admin,
                                          index: index,
                                          topicList: topicList,
                                        ))),
                          },
                          child: Card(
                              color: const Color(0xFFDEE7E7),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.check_box),
                                    title: Text(
                                      topicList[index].topicTitle.toString(),
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

  void _loadTopics() {
    http
        .post(Uri.parse(CONSTANTS.server + "/hellojava/php/load_topics.php"))
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
          titlecenter = "No exercise available for this topic";
          topicList.clear();
        }
        setState(() {});
      } else {
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

class SelectExerciseListScreen extends StatefulWidget {
  final Admin admin;
  int index;
  final List<Topic> topicList;
  SelectExerciseListScreen({
    Key? key,
    required this.admin,
    required this.index,
    required this.topicList,
  }) : super(key: key);

  @override
  State<SelectExerciseListScreen> createState() =>
      _SelectExerciseListScreenState();
}

class _SelectExerciseListScreenState extends State<SelectExerciseListScreen> {
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
        title: const Text(
          'Manage Exercise List',
          style: TextStyle(
            fontSize: 17,
          ),
        ),
      ),
      body: exerciseList.isEmpty
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
                      children: List.generate(exerciseList.length, (index) {
                        return InkWell(
                          onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (content) => ManageQuestionScreen(
                                          admin: widget.admin,
                                          index: index,
                                          topicList: topicList,
                                          exerciseList: exerciseList,
                                        ))),
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

class ManageQuestionScreen extends StatefulWidget {
  final Admin admin;
  int index;
  final List<Topic> topicList;
  final List<Exercise> exerciseList;

  ManageQuestionScreen({
    Key? key,
    required this.admin,
    required this.index,
    required this.topicList,
    required this.exerciseList,
  }) : super(key: key);

  @override
  State<ManageQuestionScreen> createState() => _ManageQuestionScreenState();
}

class _ManageQuestionScreenState extends State<ManageQuestionScreen> {
  late double screenHeight, screenWidth, resWidth;
  List<Exercise> exerciseList = <Exercise>[];
  List<Question> questionList = <Question>[];
  String titlecenter = "";

  @override
  void initState() {
    super.initState();
    _loadExerciseQuestion();
  }

  void refreshExerciseQuestion() {
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
        title: const Text(
          'Manage Exercise Questions',
          style: TextStyle(
            fontSize: 17,
          ),
        ),
      ),
      body: questionList.isEmpty
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
                      children: List.generate(questionList.length, (index) {
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
                                                        EditExerciseQuestionScreen(
                                                          admin: widget.admin,
                                                          questionList:
                                                              questionList[
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
                                              _deleteExerciseQuestionDialog(
                                                  index),
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
                  builder: (content) => AddExerciseQuestionScreen(
                        admin: widget.admin,
                        exerciseList: widget.exerciseList[widget.index],
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

  _deleteExerciseQuestionDialog(int index) {
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

  void _deleteQuestion(int index) async {
    var url = Uri.parse(
        CONSTANTS.server + "/hellojava/php/delete_exercisequestion.php");
    var response = await http.post(url, body: {
      'exercise_id': widget.exerciseList[widget.index].exerciseId,
      'question_id': questionList[index].questionId.toString(),
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
          _loadExerciseQuestion();
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

class AddExerciseQuestionScreen extends StatefulWidget {
  final Admin admin;
  final Exercise exerciseList;
  final Function() onSubtopicUpdated;
  AddExerciseQuestionScreen({
    Key? key,
    required this.admin,
    required this.exerciseList,
    required this.onSubtopicUpdated,
  }) : super(key: key);

  @override
  State<AddExerciseQuestionScreen> createState() =>
      _AddExerciseQuestionScreenState();
}

class _AddExerciseQuestionScreenState extends State<AddExerciseQuestionScreen> {
  late double screenHeight, screenWidth, resWidth;
  List<Question> questionList = <Question>[];
  final _formKey = GlobalKey<FormState>();
  TextEditingController questionTitleController = TextEditingController();
  TextEditingController questionHintController = TextEditingController();
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
          'Add Exercise Question',
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
                                controller: questionHintController,
                                maxLines: null,
                                decoration: InputDecoration(
                                  isDense: true,
                                  prefixIcon: const Icon(Icons.help_outline),
                                  labelText: "Hint",
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
                                    return 'Please enter the hint of this question';
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
    String questionHint = questionHintController.text;
    String optionA = optionAController.text;
    String optionB = optionBController.text;
    String optionC = optionCController.text;
    String correctAnswer = correctAnswerController.text;
    http.post(
        Uri.parse(CONSTANTS.server + "/hellojava/php/add_exercisequestion.php"),
        body: {
          "exercise_id": widget.exerciseList.exerciseId,
          "question_title": questionTitle,
          "question_hint": questionHint,
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

class EditExerciseQuestionScreen extends StatefulWidget {
  final Admin admin;
  final Question questionList;
  final Function() onSubtopicUpdated;
  EditExerciseQuestionScreen({
    Key? key,
    required this.admin,
    required this.questionList,
    required this.onSubtopicUpdated,
  }) : super(key: key);

  @override
  State<EditExerciseQuestionScreen> createState() =>
      _EditExerciseQuestionScreenState();
}

class _EditExerciseQuestionScreenState
    extends State<EditExerciseQuestionScreen> {
  late double screenHeight, screenWidth, resWidth;
  TextEditingController questionTitleController = TextEditingController();
  TextEditingController questionHintController = TextEditingController();
  TextEditingController optionAController = TextEditingController();
  TextEditingController optionBController = TextEditingController();
  TextEditingController optionCController = TextEditingController();
  TextEditingController correctAnswerController = TextEditingController();
  List<Exercise> exerciseList = <Exercise>[];
  List<Question> questionList = <Question>[];

  @override
  void initState() {
    super.initState();
    questionTitleController.text = widget.questionList.questionTitle.toString();
    questionHintController.text = widget.questionList.hint.toString();
    optionAController.text = widget.questionList.optionA.toString();
    optionBController.text = widget.questionList.optionB.toString();
    optionCController.text = widget.questionList.optionC.toString();
    correctAnswerController.text = widget.questionList.correctAnswer.toString();
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
          'Edit Exercise Question',
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
                          leading: const Icon(Icons.help_outline),
                          title: const Text(
                            'Change Hint',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                _updateHintDialog();
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
        Uri.parse(
            CONSTANTS.server + "/hellojava/php/update_exercisequestion.php"),
        body: {
          'question_id': widget.questionList.questionId,
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

  void _updateHintDialog() {
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
                    height: screenHeight / 1.2,
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
                            "Change hint?",
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          content: SingleChildScrollView(
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                controller: questionHintController,
                                maxLines: null,
                                decoration: InputDecoration(
                                  isDense: true,
                                  labelText: 'Hint',
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
                                    return 'Please enter the new hint';
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
                                  String newhint = questionHintController.text;
                                  _updateHint(newhint);
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

  void _updateHint(String newhint) {
    http.post(
        Uri.parse(
            CONSTANTS.server + "/hellojava/php/update_exercisequestion.php"),
        body: {
          'question_id': widget.questionList.questionId,
          "newhint": newhint,
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
        Uri.parse(
            CONSTANTS.server + "/hellojava/php/update_exercisequestion.php"),
        body: {
          'question_id': widget.questionList.questionId,
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
