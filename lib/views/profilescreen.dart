import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hellojava/main.dart';
import 'package:hellojava/models/quiz.dart';
import 'package:hellojava/views/loginscreen.dart';
import 'package:hellojava/views/mainscreen.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
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
  bool oldpasswordVisible = true;
  bool newpasswordVisible = true;
  late int val;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.name.toString();
    _phoneController.text = widget.user.phone.toString();
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
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SingleChildScrollView(
              child: SizedBox(
                height: screenHeight / 3.2,
                child: SizedBox(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                      child: Hero(
                                        tag: 'profileImage${widget.user.id}',
                                        child: CachedNetworkImage(
                                          imageUrl: CONSTANTS.server +
                                              '/hellojava/assets/users/${widget.user.id}.jpg' +
                                              "?v=$val",
                                          fit: BoxFit.contain,
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: ClipOval(
                                  child: Hero(
                                    tag: 'profileImage${widget.user.id}',
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
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  // Row(
                                  //   children: [
                                  //     Icon(Icons.email,
                                  //         size: 20,
                                  //         color:
                                  //             Theme.of(context).primaryColor),
                                  Text(" " + widget.user.email.toString()),
                                  //   ],
                                  // ),
                                  // Row(
                                  //   children: [
                                  //     Icon(Icons.phone,
                                  //         size: 20,
                                  //         color:
                                  //             Theme.of(context).primaryColor),
                                  Text(" " + widget.user.phone.toString()),
                                  //   ],
                                  // ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: resWidth,
                child: Column(
                  children: [
                    if (widget.user.email == "guest@gmail.com")
                      const Divider(
                        height: 2,
                        color: Colors.grey,
                      ),
                    ListView(
                      shrinkWrap: true,
                      children: [
                        if (widget.user.email == "guest@gmail.com")
                          Container(
                            color: Colors.white,
                            child: ListTile(
                              leading: const Icon(Icons.login),
                              title: const Text("Login",
                                  style: TextStyle(fontSize: 15)),
                              trailing: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (content) =>
                                                const LoginScreen()));
                                  },
                                  icon: const Icon(Icons.arrow_right),
                                  color: const Color(0xFFF9A03F)),
                            ),
                          ),
                        if (widget.user.email == "guest@gmail.com")
                          const Divider(
                            height: 2,
                            color: Colors.grey,
                          ),
                        if (widget.user.email != "guest@gmail.com")
                          const Divider(
                            height: 2,
                            color: Colors.grey,
                          ),
                        if (widget.user.email != "guest@gmail.com")
                          Container(
                            color: Colors.white,
                            child: ListTile(
                              leading: const Icon(Icons.edit),
                              title: const Text("Edit Profile",
                                  style: TextStyle(fontSize: 15)),
                              trailing: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (content) =>
                                                EditProfileScreen(
                                                  user: widget.user,
                                                )));
                                  },
                                  icon: const Icon(Icons.arrow_right),
                                  color: const Color(0xFFF9A03F)),
                            ),
                          ),
                        if (widget.user.email != "guest@gmail.com")
                          const Divider(
                            height: 2,
                            color: Colors.grey,
                          ),
                        if (widget.user.email != "guest@gmail.com")
                          Container(
                            color: Colors.white,
                            child: ListTile(
                              leading: const Icon(Icons.scoreboard),
                              title: const Text("View Score",
                                  style: TextStyle(fontSize: 15)),
                              trailing: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (content) =>
                                                ViewScoreScreen(
                                                  user: widget.user,
                                                )));
                                  },
                                  icon: const Icon(Icons.arrow_right),
                                  color: const Color(0xFFF9A03F)),
                            ),
                          ),
                        if (widget.user.email != "guest@gmail.com")
                          const Divider(
                            height: 2,
                            color: Colors.grey,
                          ),
                        if (widget.user.email != "guest@gmail.com")
                          Container(
                            color: Colors.white,
                            child: ListTile(
                              leading: const Icon(Icons.logout),
                              title: const Text("Logout",
                                  style: TextStyle(fontSize: 15)),
                              trailing: IconButton(
                                  onPressed: () {
                                    _logoutDialog();
                                  },
                                  icon: const Icon(Icons.arrow_right),
                                  color: const Color(0xFFF9A03F)),
                            ),
                          ),
                        if (widget.user.email != "guest@gmail.com")
                          const Divider(
                            height: 2,
                            color: Colors.grey,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _logoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: SingleChildScrollView(
            child: StatefulBuilder(
              builder: (context, StateSetter setState) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {},
                  child: AlertDialog(
                    backgroundColor: const Color(0xFFF4F4F4),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    title: const Text(
                      "Logout?",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    content: const Text("Are your sure want to logout?"),
                    actions: <Widget>[
                      TextButton(
                        child: const Text(
                          "Yes",
                          style: TextStyle(),
                        ),
                        onPressed: () async {
                          Navigator.of(context).pop();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (content) => const MyApp()));
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
            ),
          ),
        );
      },
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  final User user;
  const EditProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late double screenHeight, screenWidth, resWidth;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final TextEditingController oldpasswordController = TextEditingController();
  final TextEditingController newpasswordController = TextEditingController();
  bool oldpasswordVisible = true;
  bool newpasswordVisible = true;
  var val = 50;
  var _image;
  Random random = Random();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.user.name.toString();
    phoneController.text = widget.user.phone.toString();
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
        title: const Text('Edit Profile'),
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
                          leading: const Icon(Icons.person),
                          title: const Text(
                            'Change Name',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                _updateNameDialog();
                              },
                              icon: const Icon(Icons.arrow_forward_ios_rounded),
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
                          leading: const Icon(Icons.phone),
                          title: const Text(
                            'Change Phone Number',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                _updatePhoneDialog();
                              },
                              icon: const Icon(Icons.arrow_forward_ios_rounded),
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
                          leading: const Icon(Icons.lock),
                          title: const Text(
                            'Change Password',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                _changePasswordDialog();
                              },
                              icon: const Icon(Icons.arrow_forward_ios_rounded),
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
                            'Change Profile Picture',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                _updateImageDialog();
                              },
                              icon: const Icon(Icons.arrow_forward_ios_rounded),
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

  void _updateNameDialog() {
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
                            "Change Name?",
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                          content: SingleChildScrollView(
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                controller: nameController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  labelText: 'Name',
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your new name';
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
                                  String newname = nameController.text;
                                  _updateName(newname);
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

  void _updateName(String newname) {
    http.post(Uri.parse(CONSTANTS.server + "/hellojava/php/update_profile.php"),
        body: {
          "email": widget.user.email,
          "newname": newname,
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Change Name Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14,
            backgroundColor: const Color(0xFF4F646F));
        setState(() {
          widget.user.name = newname;
        });
      } else {
        Fluttertoast.showToast(
            msg: "Failed to Change Name",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14,
            backgroundColor: const Color(0xFF4F646F));
      }
    });
  }

  void _updatePhoneDialog() {
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
                            "Change Phone Number?",
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                          content: SingleChildScrollView(
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                controller: phoneController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(),
                                decoration: InputDecoration(
                                    labelText: 'Phone',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your new phone number';
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
                                  String newphone = phoneController.text;
                                  _updatePhone(newphone);
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

  void _updatePhone(String newphone) {
    http.post(Uri.parse(CONSTANTS.server + "/hellojava/php/update_profile.php"),
        body: {
          "email": widget.user.email,
          "newphone": newphone,
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Change Phone Number Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14,
            backgroundColor: const Color(0xFF4F646F));
        setState(() {
          widget.user.phone = newphone;
        });
      } else {
        Fluttertoast.showToast(
            msg: "Failed to Change Phone Number",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14,
            backgroundColor: const Color(0xFF4F646F));
      }
    });
  }

  void _changePasswordDialog() {
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
                    height: screenHeight / 1.5,
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
                            "Change Password?",
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                          content: SingleChildScrollView(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: oldpasswordController,
                                    obscureText: oldpasswordVisible,
                                    decoration: InputDecoration(
                                        labelText: 'Old Password',
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            oldpasswordVisible
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              oldpasswordVisible =
                                                  !oldpasswordVisible;
                                            });
                                          },
                                        )),
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
                                    controller: newpasswordController,
                                    obscureText: newpasswordVisible,
                                    decoration: InputDecoration(
                                        labelText: 'New Password',
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            newpasswordVisible
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              newpasswordVisible =
                                                  !newpasswordVisible;
                                            });
                                          },
                                        )),
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
                                  String oldpassword =
                                      oldpasswordController.text;
                                  String newpassword =
                                      newpasswordController.text;
                                  _changePassword(oldpassword, newpassword);
                                }
                                _formKey.currentState!.reset();
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

  void _changePassword(String oldpassword, String newpassword) {
    http.post(Uri.parse(CONSTANTS.server + "/hellojava/php/update_profile.php"),
        body: {
          "email": widget.user.email,
          "oldpassword": oldpassword,
          "newpassword": newpassword,
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Change Password Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14,
            backgroundColor: const Color(0xFF4F646F));
        setState(() {
          widget.user.password = newpassword;
        });
      } else if (jsondata['status'] == 'invalid') {
        Fluttertoast.showToast(
            msg: "Incorrect Old Password",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14,
            backgroundColor: const Color(0xFF4F646F));
      } else {
        Fluttertoast.showToast(
            msg: "Failed to Change Password",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14,
            backgroundColor: const Color(0xFF4F646F));
      }
    });
  }

  _updateImageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: AlertDialog(
            backgroundColor: const Color(0xFFF4F4F4),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Select from",
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            actions: <Widget>[
              TextButton.icon(
                onPressed: () => {
                  Navigator.of(context).pop(),
                  _galleryPicker(),
                },
                icon: const Icon(Icons.browse_gallery),
                label: const Text("Gallery"),
              ),
              TextButton.icon(
                onPressed: () => {Navigator.of(context).pop(), _cameraPicker()},
                icon: const Icon(Icons.camera_alt),
                label: const Text("Camera"),
              ),
            ],
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
          CropAspectRatioPreset.square,
        ],
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    if (croppedFile != null) {
      _image = croppedFile;
      _updateProfileImage(_image);
    }
  }

  void _updateProfileImage(image) {
    String base64Image = base64Encode(image!.readAsBytesSync());
    http.post(Uri.parse(CONSTANTS.server + "/hellojava/php/update_profile.php"),
        body: {
          "id": widget.user.id,
          "image": base64Image,
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Change Profile Picture Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14,
            backgroundColor: const Color(0xFF4F646F));
        setState(() {
          val = Random().nextInt(1000);
        });
      } else {
        Fluttertoast.showToast(
            msg: "Failed to Change Profile Picture",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14,
            backgroundColor: const Color(0xFF4F646F));
      }
    });
  }
}

class ViewScoreScreen extends StatefulWidget {
  final User user;
  const ViewScoreScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ViewScoreScreen> createState() => _ViewScoreScreenState();
}

class _ViewScoreScreenState extends State<ViewScoreScreen> {
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
        title: const Text('View Score'),
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
                                        builder: (content) => QuizListScreen(
                                              user: widget.user,
                                            )));
                                /*Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (content) => QuizScoreScreen(
                                              user: widget.user,
                                            )));*/
                              },
                              icon: const Icon(Icons.arrow_forward_ios_rounded),
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
                              onPressed: () {},
                              icon: const Icon(Icons.arrow_forward_ios_rounded),
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

class QuizListScreen extends StatefulWidget {
  final User user;
  const QuizListScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<QuizListScreen> createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
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
        title: const Text('Score for'),
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
                                    builder: (content) => QuizScoreScreen(
                                          user: widget.user,
                                          index: index,
                                          quizList: quizList,
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

  void _loadQuizList() {
    http
        .post(
      Uri.parse(CONSTANTS.server + "/hellojava/php/load_quizlist.php"),
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
        if (extractdata['quizList'] != null) {
          quizList = <Quiz>[];
          extractdata['quizList'].forEach((v) {
            quizList.add(Quiz.fromJson(v));
          });
        } else {
          titlecenter = "No Quiz List Available";
          quizList.clear();
        }
        setState(() {});
      } else {
        //do something
        titlecenter = "No Quiz List Available";
        quizList.clear();
        setState(() {});
      }
    });
  }
}

class QuizScoreScreen extends StatefulWidget {
  final User user;
  int index;
  final List<Quiz> quizList;
  QuizScoreScreen({
    Key? key,
    required this.user,
    required this.index,
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
    _loadQuizScore(widget.quizList[widget.index].quizId);
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
          widget.quizList[widget.index].quizTitle.toString(),
          style: const TextStyle(
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
        'quiz_id': widget.quizList[widget.index].quizId.toString(),
      },
    ).timeout(
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
        if (extractdata['quizscore'] != null) {
          quizList = <Quiz>[];
          extractdata['quizscore'].forEach((v) {
            quizList.add(Quiz.fromJson(v));
          });
        } else {
          titlecenter = "No Quiz Score Available";
          quizList.clear();
        }
        setState(() {});
      } else {
        titlecenter = "No Quiz Score Available";
        quizList.clear();
        setState(() {});
      }
    });
  }

  _confirmationDelete(int index) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFF4F4F4),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: const Text('Delete Score?'),
        content: const Text('Are you sure want to delete this score?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteScore(index);
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
        Fluttertoast.showToast(
            msg: "Quiz Score Deleted Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14,
            backgroundColor: const Color(0xFF4F646F));
        setState(() {
          _loadQuizScore(widget.quizList[widget.index].quizId);
        });
      } else {
        Fluttertoast.showToast(
            msg: "Failed to Delete Quiz Score",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14,
            backgroundColor: const Color(0xFF4F646F));
      }
    } else {
      Fluttertoast.showToast(
          msg: "Failed to Delete Quiz Score",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14,
          backgroundColor: const Color(0xFF4F646F));
    }
  }
}
