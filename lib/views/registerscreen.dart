import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hellojava/views/loginscreen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late double screenHeight, screenWidth, resWidth;
  bool remember = false;
  var _image;
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordController2 = TextEditingController();
  bool passwordVisible = true;
  bool password2Visible = true;
  final _formKey = GlobalKey<FormState>();

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
      backgroundColor: const Color(0xFF4F646F),
      appBar: AppBar(
        title: const Text(
          'User Registration',
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
                        SizedBox(
                            height: screenHeight / 4,
                            width: screenWidth,
                            child: Image.asset('assets/images/logo.png')),
                        const SizedBox(height: 15),
                        const Text(
                          "Your information must be true to avoid any issues with account verification",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        Card(
                          child: GestureDetector(
                            onTap: () => {_takePictureDialog()},
                            child: Container(
                              decoration: _image == null
                                  ? BoxDecoration(
                                      border: Border.all(
                                          color: const Color(0xFFF9A03F),
                                          width: 3),
                                    )
                                  : null,
                              child: SizedBox(
                                height: screenHeight / 3,
                                width: screenWidth,
                                child: _image == null
                                    ? Image.asset('assets/images/camera.png')
                                    : Image.file(
                                        _image,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: nameController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  prefixIcon: const Icon(Icons.person),
                                  labelText: 'Name',
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  errorStyle:
                                      const TextStyle(color: Color(0xFFF7D488)),
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
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: emailController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  prefixIcon: const Icon(Icons.email),
                                  labelText: "Email Address",
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  errorStyle:
                                      const TextStyle(color: Color(0xFFF7D488)),
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
                                    return 'Please enter your email address';
                                  }
                                  bool emailValid = RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value);
                                  if (!emailValid) {
                                    return 'Please enter a valid email address';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: phoneController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                  isDense: true,
                                  prefixIcon: const Icon(Icons.phone),
                                  labelText: 'Phone Number',
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  errorStyle:
                                      const TextStyle(color: Color(0xFFF7D488)),
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
                                    return 'Please enter your phone number';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: passwordController,
                                obscureText: passwordVisible,
                                decoration: InputDecoration(
                                    isDense: true,
                                    prefixIcon: const Icon(Icons.lock),
                                    labelText: "Password",
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    errorStyle: const TextStyle(
                                        color: Color(0xFFF7D488)),
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
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        passwordVisible
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          passwordVisible = !passwordVisible;
                                        });
                                      },
                                    )),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  if (value.length < 6) {
                                    return "Password must be at least 6 characters";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: passwordController2,
                                obscureText: password2Visible,
                                decoration: InputDecoration(
                                    isDense: true,
                                    prefixIcon: const Icon(Icons.lock),
                                    labelText: "Re-enter Password",
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    errorStyle: const TextStyle(
                                        color: Color(0xFFF7D488)),
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
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        password2Visible
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          password2Visible = !password2Visible;
                                        });
                                      },
                                    )),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please reenter your password';
                                  }
                                  if (passwordController.text !=
                                      passwordController2.text) {
                                    return "Your password does not match";
                                  }
                                  if (value.length < 6) {
                                    return "Password must be at least 6 characters";
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
                                      "Register Now",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: _registerUserdialog,
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
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const Text(
                                    "Already register? ",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      " Login here",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFF7D488)),
                                    ),
                                  )
                                ],
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
          color: const Color(0xFFF4FAFF),
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
          CropAspectRatioPreset.square,
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

  void _registerUserdialog() {
    if (_formKey.currentState!.validate() && _image != null) {
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
                "Register new account",
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              content: const Text("Are you sure?", style: TextStyle()),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    "Yes",
                    style: TextStyle(),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    _registerUser();
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

  void _registerUser() {
    String name = nameController.text;
    String email = emailController.text;
    String phone = phoneController.text;
    String password = passwordController.text;
    String base64Image = base64Encode(_image!.readAsBytesSync());
    http.post(
        Uri.parse(CONSTANTS.server + "/hellojava/php/registration_user.php"),
        body: {
          "name": name,
          "email": email,
          "phone": phone,
          "password": password,
          "user_image": base64Image,
        }).then((response) {
      print(response.body);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        setState(() {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                data['message'],
                style: TextStyle(color: Color(0xFF4F646F)),
                textAlign: TextAlign.center,
              ),
              duration: Duration(seconds: 2),
              backgroundColor: Color(0xFFF4FAFF),
              behavior: SnackBarBehavior
                  .fixed, // Ensures the snackbar sticks to the bottom
            ),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data['message'],
              style: const TextStyle(color: Color(0xFFF4FAFF)),
              textAlign: TextAlign.center,
            ),
            duration: Duration(seconds: 2),
            backgroundColor: Color(0xFFAB3232),
            behavior: SnackBarBehavior
                .fixed, // Ensures the snackbar sticks to the bottom
          ),
        );
      }
    });
  }
}
