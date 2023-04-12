import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hellojava/constants.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../models/topic.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class NoteScreen extends StatefulWidget {
  final User user;
  const NoteScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  late double screenHeight, screenWidth, resWidth;
  List<Topic> topicList = <Topic>[];
  String titlecenter = "";

  @override
  void initState() {
    super.initState();
    _loadNotes();
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
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "Java Note",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      scrollDirection: Axis.vertical,
                      primary: false,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      children: List.generate(topicList.length, (index) {
                        return TextButton(
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SubNoteScreen(
                                        user: widget.user,
                                        index: index,
                                        topicList: topicList,
                                      )),
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CachedNetworkImage(
                                imageUrl: CONSTANTS.server +
                                    "/hellojava/assets/notes/topic/" +
                                    topicList[index].topicId.toString() +
                                    '.png',
                                fit: BoxFit.cover,
                                width: resWidth / 5,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                topicList[index].topicTitle.toString(),
                                style: const TextStyle(
                                    fontSize: 11, color: Colors.black),
                              ),
                            ],
                          ),
                          style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Color(0xFFDEE7E7)),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _loadNotes() {
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
            gravity: ToastGravity.BOTTOM,
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
          titlecenter = "No Topic Available";
          topicList.clear();
        }
        setState(() {});
      } else {
        //do something
        titlecenter = "No Topic Available";
        topicList.clear();
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

class SubNoteScreen extends StatefulWidget {
  final User user;
  int index;
  final List<Topic> topicList;
  SubNoteScreen({
    Key? key,
    required this.user,
    required this.index,
    required this.topicList,
  }) : super(key: key);

  @override
  State<SubNoteScreen> createState() => _SubNoteScreenState();
}

class _SubNoteScreenState extends State<SubNoteScreen> {
  late double screenHeight, screenWidth, resWidth;
  List<Topic> topicList = <Topic>[];
  String titlecenter = "";

  @override
  void initState() {
    super.initState();
    _loadSubNotes();
  }

  void refreshSubtopics() {
    _loadSubNotes();
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
                  Row(
                    children: const [
                      Icon(
                        Icons.lightbulb,
                        size: 24.0,
                        color: Color(0xFFF9A03F),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Subtopic List",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
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
                          onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (content) => SubNoteDetailsScreen(
                                          user: widget.user,
                                          index: index,
                                          topicList: topicList,
                                          onSubtopicUpdated: refreshSubtopics,
                                        )))
                          },
                          child: Card(
                              color: const Color(0xFFDEE7E7),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.notes_rounded),
                                    title: Text(
                                      topicList[index].subtopicTitle.toString(),
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

  void _loadSubNotes() {
    http.post(
      Uri.parse(CONSTANTS.server + "/hellojava/php/load_subtopics.php"),
      body: {
        'topic_id': widget.topicList[widget.index].topicId.toString(),
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
        throw SocketException("Connection timed out");
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);
      print(jsondata);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        if (extractdata['subtopic'] != null) {
          topicList = <Topic>[];
          extractdata['subtopic'].forEach((v) {
            topicList.add(Topic.fromJson(v));
          });
        } else {
          titlecenter = "No Topic Available";
          topicList.clear();
        }
        setState(() {});
      } else {
        //do something
        titlecenter = "No Topic Available";
        topicList.clear();
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

class SubNoteDetailsScreen extends StatefulWidget {
  final User user;
  int index;
  final List<Topic> topicList;
  final Function() onSubtopicUpdated;
  SubNoteDetailsScreen({
    Key? key,
    required this.user,
    required this.index,
    required this.topicList,
    required this.onSubtopicUpdated,
  }) : super(key: key);

  @override
  State<SubNoteDetailsScreen> createState() => _SubNoteDetailsScreenState();
}

class _SubNoteDetailsScreenState extends State<SubNoteDetailsScreen> {
  late double screenHeight, screenWidth, resWidth;
  List<Topic> topicList = <Topic>[];
  late YoutubePlayerController _controller;
  String titlecenter = "";
  String? videoUrl;
  Random random = Random();
  late int val;

  @override
  void initState() {
    super.initState();
    _loadSubNotesDetails();
    val = Random().nextInt(1000);
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
          'Note Details',
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
              padding: const EdgeInsets.all(18),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(topicList.length, (index) {
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Color(0xFFF9A03F),
                          ),
                          child: Text(
                            widget.topicList[widget.index].subtopicTitle
                                .toString(),
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          topicList[index].subtopicDescription.toString(),
                          textAlign: TextAlign.justify,
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  child: Container(
                                    width: screenWidth,
                                    child: CachedNetworkImage(
                                      imageUrl: CONSTANTS.server +
                                          "/hellojava/assets/notes/subtopics/" +
                                          topicList[index]
                                              .subtopicId
                                              .toString() +
                                          '.jpg' +
                                          "?v=$val",
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                            ),
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: CachedNetworkImage(
                                imageUrl: CONSTANTS.server +
                                    "/hellojava/assets/notes/subtopics/" +
                                    topicList[index].subtopicId.toString() +
                                    '.jpg' +
                                    "?v=$val",
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'You may learn more information through the video below:',
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 10),
                        YoutubePlayer(
                          controller: _controller,
                          showVideoProgressIndicator: true,
                          progressIndicatorColor: const Color(0xFFF9A03F),
                          onReady: () => debugPrint('Video Ready'),
                        )
                      ],
                    );
                  }),
                ),
              ),
            ),
    );
  }

  void _loadSubNotesDetails() {
    http.post(
      Uri.parse(CONSTANTS.server + "/hellojava/php/load_subtopicdetails.php"),
      body: {
        'topic_id': widget.topicList[widget.index].topicId.toString(),
        'subtopic_id': widget.topicList[widget.index].subtopicId.toString(),
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
        throw SocketException("Connection timed out");
      },
    ).then((response) {
      var jsondata = json.decode(response.body);
      if (jsondata["status"] == "success") {
        setState(() {
          var data = jsondata["data"]["subtopicdetails"][0];
          topicList.add(Topic.fromJson(data));
          videoUrl = topicList[0].subtopicVideoLink;

          // Add a null check before calling the convertUrlToId method
          String? videoID =
              videoUrl != null ? YoutubePlayer.convertUrlToId(videoUrl!) : null;
          _controller = YoutubePlayerController(
              initialVideoId: videoID ?? '',
              flags: const YoutubePlayerFlags(autoPlay: false));
        });
        widget.onSubtopicUpdated();
      } else {
        setState(() {
          titlecenter = "No Data Found";
        });
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
