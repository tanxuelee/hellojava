import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              "Java Exercise",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
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

  void _loadExercises() {
    http
        .post(
      Uri.parse(CONSTANTS.server + "/hellojava/php/load_topics.php"),
    )
        .timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        titlecenter = "Timeout Please retry again later";
        return http.Response(
            'Error', 408); // Request Timeout response status code
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
          titlecenter = "No Topic Available";
          topicList.clear();
        }
        setState(() {});
      } else {
        titlecenter = "No Topic Available";
        topicList.clear();
        setState(() {});
      }
    });
  }

  _clickExerciseButton(int index) {
    if (widget.user.email == "guest@gmail.com") {
      _loadOptions();
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (content) => SubExerciseScreen(user: widget.user)));
    }
  }

  _loadOptions() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
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
          );
        });
  }

  void _onLogin() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => const LoginScreen()));
  }
}

class SubExerciseScreen extends StatefulWidget {
  final User user;
  const SubExerciseScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<SubExerciseScreen> createState() => _SubExerciseScreenState();
}

class _SubExerciseScreenState extends State<SubExerciseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 1'),
      ),
      body: const Center(
        child: Text('Hi Exercise'),
      ),
    );
  }
}
