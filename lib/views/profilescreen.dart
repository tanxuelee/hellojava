import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hellojava/main.dart';
import 'package:hellojava/views/loginscreen.dart';
import '../constants.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  const ProfileScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<User> userList = <User>[];
  late double screenHeight, screenWidth, resWidth;
  Random random = Random();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _oldpasswordController = TextEditingController();
  final TextEditingController _newpasswordController = TextEditingController();
  var val = 50;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.name.toString();
    _phoneController.text = widget.user.phone.toString();
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
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: screenHeight / 3,
              child: SizedBox(
                width: resWidth,
                child: Card(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            //onTap: () => {_updateImageDialog()},
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: CONSTANTS.server +
                                    '/hellojava/assets/users/${widget.user.id}.jpg' +
                                    "?v=$val",
                                fit: BoxFit.cover,
                                width: resWidth / 2,
                                placeholder: (context, url) =>
                                    const LinearProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.user.name.toString(),
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.email, size: 20),
                                  Text(" " + widget.user.email.toString()),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.phone, size: 20),
                                  Text(" " + widget.user.phone.toString()),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
                child: SizedBox(
              width: resWidth,
              child: Column(
                children: [
                  if (widget.user.email != "guest@gmail.com")
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Theme.of(context).primaryColor,
                        child: const Center(
                          child: Text("PROFILE SETTINGS",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      ),
                    ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      shrinkWrap: true,
                      children: [
                        if (widget.user.email == "guest@gmail.com")
                          ListTile(
                            leading: const Icon(Icons.login),
                            title: const Text("Login",
                                style: TextStyle(fontSize: 15)),
                            trailing: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (content) => LoginScreen()));
                                },
                                icon: const Icon(Icons.arrow_right)),
                          ),
                        if (widget.user.email == "guest@gmail.com")
                          const Divider(
                            height: 2,
                            color: Colors.grey,
                          ),
                        if (widget.user.email != "guest@gmail.com")
                          ListTile(
                            leading: const Icon(Icons.person),
                            title: const Text("Update Name",
                                style: TextStyle(fontSize: 15)),
                            trailing: IconButton(
                                onPressed: () {
                                  _updateNameDialog();
                                },
                                icon: const Icon(Icons.arrow_right)),
                          ),
                        if (widget.user.email != "guest@gmail.com")
                          const Divider(
                            height: 2,
                            color: Colors.grey,
                          ),
                        if (widget.user.email != "guest@gmail.com")
                          ListTile(
                            leading: const Icon(Icons.phone),
                            title: const Text("Update Phone Number",
                                style: TextStyle(fontSize: 15)),
                            trailing: IconButton(
                                onPressed: () {
                                  _updatePhoneDialog();
                                },
                                icon: const Icon(Icons.arrow_right)),
                          ),
                        if (widget.user.email != "guest@gmail.com")
                          const Divider(
                            height: 2,
                            color: Colors.grey,
                          ),
                        if (widget.user.email != "guest@gmail.com")
                          ListTile(
                            leading: const Icon(Icons.lock),
                            title: const Text("Change Password",
                                style: TextStyle(fontSize: 15)),
                            trailing: IconButton(
                                onPressed: () {
                                  _changePasswordDialog();
                                },
                                icon: const Icon(Icons.arrow_right)),
                          ),
                        if (widget.user.email != "guest@gmail.com")
                          const Divider(
                            height: 2,
                            color: Colors.grey,
                          ),
                        if (widget.user.email != "guest@gmail.com")
                          ListTile(
                            leading: const Icon(Icons.logout),
                            title: const Text("Logout",
                                style: TextStyle(fontSize: 15)),
                            trailing: IconButton(
                                onPressed: () {
                                  _logoutDialog();
                                },
                                icon: const Icon(Icons.arrow_right)),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  void _updateNameDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return SingleChildScrollView(
              child: AlertDialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                title: const Text(
                  "Update New Name?",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
                content: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: 'Name',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    errorStyle: const TextStyle(color: Color(0xFFF7D488)),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your new name';
                    }
                    return null;
                  },
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text(
                      "Yes",
                      style: TextStyle(),
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      String newname = _nameController.text;
                      _updateName(newname);
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
      },
    );
  }

  void _updatePhoneDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return SingleChildScrollView(
              child: AlertDialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                title: const Text(
                  "Update New Phone Number?",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
                content: TextFormField(
                  controller: _phoneController,
                  keyboardType: const TextInputType.numberWithOptions(),
                  decoration: InputDecoration(
                      labelText: 'Phone',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your new phone';
                    }
                    return null;
                  },
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text(
                      "Yes",
                      style: TextStyle(),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      String newphone = _phoneController.text;
                      _updatePhone(newphone);
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
      },
    );
  }

  void _changePasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return SingleChildScrollView(
              child: AlertDialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                title: const Text(
                  "Change Password?",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
                content: Column(
                  children: [
                    TextFormField(
                      controller: _oldpasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: 'Old Password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your old password';
                        }
                        if (value.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: _newpasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: 'New Password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your new password';
                        }
                        if (value.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text(
                      "Yes",
                      style: TextStyle(),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      String newpassword = _newpasswordController.text;
                      _changePassword(newpassword);
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
      },
    );
  }

  void _logoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: StatefulBuilder(
            builder: (context, StateSetter setState) {
              return AlertDialog(
                backgroundColor: const Color(0xFFF4FAFF),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                title: const Text(
                  "Logout?",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
                content: const Text("Are your sure"),
                actions: <Widget>[
                  TextButton(
                    child: const Text(
                      "Yes",
                      style: TextStyle(),
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (content) => MyApp()));
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
              );
            },
          ),
        );
      },
    );
  }

  void _updateName(String newname) {
    http.post(Uri.parse(CONSTANTS.server + "/hellojava/php/update_profile.php"),
        body: {
          "email": widget.user.email,
          "newname": newname,
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        setState(() {
          widget.user.name = newname;
        });
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }

  void _changePassword(String newpassword) {
    http.post(Uri.parse(CONSTANTS.server + "/hellojava/php/update_profile.php"),
        body: {
          "email": widget.user.email,
          "newpassword": newpassword,
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        setState(() {
          widget.user.password = newpassword;
        });
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }

  void _updatePhone(String newphone) {
    http.post(Uri.parse(CONSTANTS.server + "/hellojava/php/update_profile.php"),
        body: {
          "email": widget.user.email,
          "newphone": newphone,
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        setState(() {
          widget.user.phone = newphone;
        });
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }
}
