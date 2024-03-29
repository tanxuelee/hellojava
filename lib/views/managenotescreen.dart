import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hellojava/views/adminmainscreen.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:hellojava/constants.dart';
import 'package:hellojava/models/admin.dart';
import 'package:hellojava/models/topic.dart';
import 'package:http/http.dart' as http;

class ManageNoteScreen extends StatefulWidget {
  final Admin admin;
  const ManageNoteScreen({
    Key? key,
    required this.admin,
  }) : super(key: key);

  @override
  State<ManageNoteScreen> createState() => _ManageNoteScreenState();
}

class _ManageNoteScreenState extends State<ManageNoteScreen> {
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
          'Select Note Topic',
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
              padding: const EdgeInsets.all(20),
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
                                    builder: (content) => ManageSubTopicScreen(
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
        throw const SocketException("Connection timed out");
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
          titlecenter = "No topic available";
          topicList.clear();
        }
        setState(() {});
      } else {
        titlecenter = "No topic available";
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

class ManageSubTopicScreen extends StatefulWidget {
  final Admin admin;
  int index;
  final List<Topic> topicList;
  ManageSubTopicScreen({
    Key? key,
    required this.admin,
    required this.index,
    required this.topicList,
  }) : super(key: key);

  @override
  State<ManageSubTopicScreen> createState() => _ManageSubTopicScreenState();
}

class _ManageSubTopicScreenState extends State<ManageSubTopicScreen> {
  late double screenHeight, screenWidth, resWidth;
  List<Topic> topicList = <Topic>[];
  String titlecenter = "";

  @override
  void initState() {
    super.initState();
    _loadSubTopics(widget.topicList[widget.index].subtopicId);
  }

  void refreshSubtopics() {
    _loadSubTopics(widget.topicList[widget.index].subtopicId);
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
          'Manage Note Subtopic',
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
              padding: const EdgeInsets.all(20),
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
                          child: Card(
                              color: const Color(0xFFDEE7E7),
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      topicList[index].subtopicTitle.toString(),
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
                                                        EditSubtopicScreen(
                                                          admin: widget.admin,
                                                          topicList:
                                                              topicList[index],
                                                          onSubtopicUpdated:
                                                              refreshSubtopics,
                                                        )));
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Color(0xFFAB3232),
                                          ),
                                          onPressed: () =>
                                              _deleteSubTopicDialog(index),
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
                  builder: (content) => AddNoteSubtopicScreen(
                        admin: widget.admin,
                        topicList: widget.topicList[widget.index],
                        onSubtopicUpdated: refreshSubtopics,
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

  void _loadSubTopics(String? subtopicId) {
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
        if (extractdata['subtopic'] != null) {
          topicList = <Topic>[];
          extractdata['subtopic'].forEach((v) {
            topicList.add(Topic.fromJson(v));
          });
        } else {
          titlecenter = "No subtopic available for this topic";
          topicList.clear();
        }
        setState(() {});
      } else {
        //do something
        titlecenter = "No subtopic available for this topic";
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

  _deleteSubTopicDialog(int index) {
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
                      'Delete subtopic?',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 25),
                    child: Text(
                      'Are you sure want to delete this subtopic?',
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
                            _deleteSubtopic(index);
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

  void _deleteSubtopic(int index) async {
    var url =
        Uri.parse(CONSTANTS.server + "/hellojava/php/delete_subtopic.php");
    var response = await http.post(url, body: {
      'topic_id': topicList[index].topicId.toString(),
      'subtopic_id': topicList[index].subtopicId.toString(),
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
          _loadSubTopics(widget.topicList[widget.index].subtopicId);
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

class AddNoteSubtopicScreen extends StatefulWidget {
  final Admin admin;
  final Topic topicList;
  final Function() onSubtopicUpdated;
  AddNoteSubtopicScreen({
    Key? key,
    required this.admin,
    required this.topicList,
    required this.onSubtopicUpdated,
  }) : super(key: key);

  @override
  State<AddNoteSubtopicScreen> createState() => _AddNoteSubtopicScreenState();
}

class _AddNoteSubtopicScreenState extends State<AddNoteSubtopicScreen> {
  late double screenHeight, screenWidth, resWidth;
  final _formKey = GlobalKey<FormState>();
  var _image;
  TextEditingController subtopicTitleController = TextEditingController();
  TextEditingController subtopicDescriptionController = TextEditingController();
  TextEditingController youtubeLinkController = TextEditingController();

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
          'Add Note Subtopic',
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
                              const Text(
                                "Please complete the form below:",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: subtopicTitleController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  prefixIcon: const Icon(Icons.title),
                                  labelText: 'Title',
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
                                    return 'Please enter the subtopic title';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: subtopicDescriptionController,
                                maxLines: null,
                                decoration: InputDecoration(
                                  isDense: true,
                                  prefixIcon: const Icon(Icons.description),
                                  labelText: "Descriptions",
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
                                    return 'Please enter the subtopic descriptions';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              Container(
                                decoration: const BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFFDEE7E7),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Card(
                                  child: GestureDetector(
                                    onTap: () => {_takePictureDialog()},
                                    child: Container(
                                      decoration: _image == null
                                          ? BoxDecoration(
                                              border: Border.all(
                                                  color:
                                                      const Color(0xFFF9A03F),
                                                  width: 2),
                                            )
                                          : null,
                                      child: SizedBox(
                                        height: screenHeight / 4,
                                        width: screenWidth,
                                        child: _image == null
                                            ? Image.asset(
                                                'assets/images/uploadimage.png')
                                            : Image.file(
                                                _image,
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: youtubeLinkController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  prefixIcon: const Icon(Icons.link),
                                  labelText: 'Youtube Link',
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
                                  final pattern =
                                      r'(?:http(?:s)?:\/\/)?(?:www\.)?(?:youtube\.com|youtu\.be)\/(?:watch\?v=|embed\/|v\/)?([a-zA-Z0-9\-_]+)';
                                  final regex = RegExp(pattern);

                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the youtube link';
                                  }

                                  if (!regex.hasMatch(value)) {
                                    return 'Please enter a valid youtube link';
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
                                      "Add Subtopic",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: _addsubtopicdialog,
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

  _takePictureDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: const Color(0xFFF4F4F4),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text(
                    'Import photo from the gallery',
                    style: TextStyle(fontSize: 15),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _galleryPicker();
                  },
                ),
                const Divider(
                  height: 2,
                  color: Colors.grey,
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text(
                    'Take photo using the camera',
                    style: TextStyle(fontSize: 15),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _cameraPicker();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _galleryPicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _cropImage();
    }
  }

  _cameraPicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _cropImage();
    }
  }

  Future<void> _cropImage() async {
    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: _image!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.ratio16x9,
        ],
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Color(0xFF4F646F),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {});
    }
  }

  void _addsubtopicdialog() {
    if (_formKey.currentState!.validate() && _image != null) {
      _formKey.currentState!.save();
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
                        "Add new subtopic?",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 25),
                      child: Text(
                        "Are you sure want to add new subtopic?",
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
                            child: const Text(
                              "Yes",
                              style: TextStyle(),
                            ),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              _addSubtopic();
                            },
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
                              "No",
                              style: TextStyle(),
                            ),
                            onPressed: () {
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
  }

  void _addSubtopic() {
    String subtopicTitle = subtopicTitleController.text;
    String subtopicDescription = subtopicDescriptionController.text;
    String subtopicVideoLink = youtubeLinkController.text;
    String base64Image = base64Encode(_image!.readAsBytesSync());
    http.post(Uri.parse(CONSTANTS.server + "/hellojava/php/add_subtopic.php"),
        body: {
          "topic_id": widget.topicList.topicId,
          "subtopic_title": subtopicTitle,
          "subtopic_description": subtopicDescription,
          "subtopic_videolink": subtopicVideoLink,
          "subtopic_image": base64Image,
        }).then((response) {
      print(response.body);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        setState(() {
          Navigator.pop(context);
          Fluttertoast.showToast(
              msg: data['data'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              fontSize: 14,
              backgroundColor: const Color(0xFF4F646F));
          widget.onSubtopicUpdated();
        });
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

class EditSubtopicScreen extends StatefulWidget {
  final Admin admin;
  final Topic topicList;
  final Function() onSubtopicUpdated;
  EditSubtopicScreen({
    Key? key,
    required this.admin,
    required this.topicList,
    required this.onSubtopicUpdated,
  }) : super(key: key);

  @override
  State<EditSubtopicScreen> createState() => _EditSubtopicScreenState();
}

class _EditSubtopicScreenState extends State<EditSubtopicScreen> {
  late double screenHeight, screenWidth, resWidth;
  TextEditingController subtopicTitleController = TextEditingController();
  TextEditingController subtopicDescriptionController = TextEditingController();
  TextEditingController youtubeLinkController = TextEditingController();
  var val = 50;
  var _image;
  Random random = Random();

  @override
  void initState() {
    super.initState();
    subtopicTitleController.text = widget.topicList.subtopicTitle.toString();
    subtopicDescriptionController.text =
        widget.topicList.subtopicDescription.toString();
    youtubeLinkController.text = widget.topicList.subtopicVideoLink.toString();
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
          'Edit Note Subtopic',
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
                          leading: const Icon(Icons.title),
                          title: const Text(
                            'Change Title',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                _updateTitleDialog();
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
                          leading: const Icon(Icons.description),
                          title: const Text(
                            'Change Descriptions',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                _updateDescriptionsDialog();
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
                          leading: const Icon(Icons.link),
                          title: const Text(
                            'Change Youtube Link',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                _updateYoutubeLinkDialog();
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
                          leading: const Icon(Icons.image),
                          title: const Text(
                            'Change Image',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                _updateImageDialog();
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

  void _updateTitleDialog() {
    final _formKey = GlobalKey<FormState>();
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
                      "Change title?",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 25),
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: subtopicTitleController,
                        decoration: InputDecoration(
                          labelText: 'Title',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          errorStyle: const TextStyle(color: Color(0xFFAB3232)),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(
                              color: Color(0xFFF9A03F),
                              width: 2,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(
                              color: Color(0xFFF9A03F),
                              width: 2,
                            ),
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
                  const Divider(
                    height: 2,
                    color: Colors.grey,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: TextButton(
                          child: const Text(
                            "Confirm",
                            style: TextStyle(),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              Navigator.of(context).pop();
                              String newtitle = subtopicTitleController.text;
                              _updateTitle(newtitle);
                            }
                          },
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
                            "Cancel",
                            style: TextStyle(),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            subtopicTitleController.text =
                                widget.topicList.subtopicTitle.toString();
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

  void _updateTitle(String newtitle) async {
    http.post(
        Uri.parse(CONSTANTS.server + "/hellojava/php/update_subtopic.php"),
        body: {
          'topic_id': widget.topicList.topicId,
          'subtopic_id': widget.topicList.subtopicId,
          "newtitle": newtitle,
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

  void _updateDescriptionsDialog() {
    final _formKey = GlobalKey<FormState>();
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
                      "Change descriptions?",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 25),
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: subtopicDescriptionController,
                        maxLines: null,
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: 'Descriptions',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          errorStyle: const TextStyle(color: Color(0xFFAB3232)),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(
                              color: Color(0xFFF9A03F),
                              width: 2,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(
                              color: Color(0xFFF9A03F),
                              width: 2,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the new descriptions';
                          }
                          return null;
                        },
                      ),
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
                          child: const Text(
                            "Confirm",
                            style: TextStyle(),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              Navigator.of(context).pop();
                              String newdescription =
                                  subtopicDescriptionController.text;
                              _updateDescription(newdescription);
                            }
                          },
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
                            "Cancel",
                            style: TextStyle(),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            subtopicDescriptionController.text =
                                widget.topicList.subtopicDescription.toString();
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

  void _updateDescription(String newdescription) {
    http.post(
        Uri.parse(CONSTANTS.server + "/hellojava/php/update_subtopic.php"),
        body: {
          'topic_id': widget.topicList.topicId,
          'subtopic_id': widget.topicList.subtopicId,
          "newdescription": newdescription,
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

  void _updateYoutubeLinkDialog() {
    final _formKey = GlobalKey<FormState>();
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
                      "Change youtube link?",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 25),
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: youtubeLinkController,
                        decoration: InputDecoration(
                          labelText: 'Youtube Link',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          errorStyle: const TextStyle(color: Color(0xFFAB3232)),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(
                              color: Color(0xFFF9A03F),
                              width: 2,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(
                              color: Color(0xFFF9A03F),
                              width: 2,
                            ),
                          ),
                        ),
                        validator: (value) {
                          final pattern =
                              r'(?:http(?:s)?:\/\/)?(?:www\.)?(?:youtube\.com|youtu\.be)\/(?:watch\?v=|embed\/|v\/)?([a-zA-Z0-9\-_]+)';
                          final regex = RegExp(pattern);

                          if (value == null || value.isEmpty) {
                            return 'Please enter the new youtube link';
                          }

                          if (!regex.hasMatch(value)) {
                            return 'Please enter a valid youtube link';
                          }

                          return null;
                        },
                      ),
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
                          child: const Text(
                            "Confirm",
                            style: TextStyle(),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              Navigator.of(context).pop();
                              String newyoutubelink =
                                  youtubeLinkController.text;
                              _updateYoutubeLink(newyoutubelink);
                            }
                          },
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
                            "Cancel",
                            style: TextStyle(),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            youtubeLinkController.text =
                                widget.topicList.subtopicVideoLink.toString();
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

  void _updateYoutubeLink(String newyoutubelink) {
    http.post(
        Uri.parse(CONSTANTS.server + "/hellojava/php/update_subtopic.php"),
        body: {
          'topic_id': widget.topicList.topicId,
          'subtopic_id': widget.topicList.subtopicId,
          "newyoutubelink": newyoutubelink,
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

  void _updateImageDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: const Color(0xFFF4F4F4),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text(
                    'Import photo from the gallery',
                    style: TextStyle(fontSize: 15),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _galleryPicker();
                  },
                ),
                const Divider(
                  height: 2,
                  color: Colors.grey,
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text(
                    'Take photo using the camera',
                    style: TextStyle(fontSize: 15),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _cameraPicker();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _galleryPicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _cropImage();
    }
  }

  _cameraPicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _cropImage();
    }
  }

  Future<void> _cropImage() async {
    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: _image!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.ratio16x9,
        ],
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Color(0xFF4F646F),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    if (croppedFile != null) {
      _image = croppedFile;
      _updateImage(_image);
    }
  }

  void _updateImage(image) {
    String base64Image = base64Encode(image!.readAsBytesSync());
    http.post(
        Uri.parse(CONSTANTS.server + "/hellojava/php/update_subtopic.php"),
        body: {
          'topic_id': widget.topicList.topicId,
          'subtopic_id': widget.topicList.subtopicId,
          "image": base64Image,
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
        setState(() {
          val = Random().nextInt(1000);
        });
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
