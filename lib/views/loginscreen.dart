import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hellojava/models/admin.dart';
import 'package:hellojava/views/adminmainscreen.dart';
import 'package:hellojava/views/forgotpasswordscreen.dart';
import 'package:hellojava/views/mainscreen.dart';
import 'package:hellojava/views/registerscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late double screenHeight, screenWidth, resWidth;
  final _formKey = GlobalKey<FormState>();
  bool remember = false;
  bool passwordVisible = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadPref();
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
      backgroundColor: const Color(0xFF4F646F),
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(
            fontSize: 20,
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
                    padding: const EdgeInsets.fromLTRB(32, 20, 32, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                            height: screenHeight / 4,
                            width: screenWidth,
                            child: Image.asset('assets/images/logo.png')),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            isDense: true,
                            prefixIcon: const Icon(Icons.email),
                            labelText: "Email Address",
                            filled: true,
                            fillColor: Colors.white,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
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
                          controller: passwordController,
                          obscureText: passwordVisible,
                          decoration: InputDecoration(
                              isDense: true,
                              prefixIcon: const Icon(Icons.lock),
                              labelText: "Password",
                              filled: true,
                              fillColor: Colors.white,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
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
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Checkbox(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2.0),
                              ),
                              side: MaterialStateBorderSide.resolveWith(
                                (states) => const BorderSide(
                                    width: 1.0, color: Colors.white),
                              ),
                              activeColor: Colors.white,
                              value: remember,
                              onChanged: (bool? value) {
                                _onRememberMe(value!);
                              },
                            ),
                            const Text(
                              "Remember me",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            )
                          ],
                        ),
                        const SizedBox(height: 2),
                        Container(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: screenWidth,
                            height: 50,
                            child: ElevatedButton(
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              onPressed: _loginUser,
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0))),
                                backgroundColor: MaterialStateProperty.all(
                                  const Color(0xFFF9A03F),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              "Forgot your password? ",
                              style:
                                  TextStyle(fontSize: 17, color: Colors.white),
                            ),
                            GestureDetector(
                              onTap: () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (content) =>
                                            const ForgotPasswordScreen()))
                              },
                              child: const Text(
                                " Click here",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFF7D488)),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 3),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              "New here? ",
                              style:
                                  TextStyle(fontSize: 17, color: Colors.white),
                            ),
                            GestureDetector(
                              onTap: () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (content) =>
                                            const RegisterScreen()))
                              },
                              child: const Text(
                                " Create an account",
                                style: TextStyle(
                                    fontSize: 17,
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
          ),
        ),
      ),
    );
  }

  void _onRememberMe(bool value) {
    remember = value;
    setState(() {
      if (remember) {
        _saveRemovePref(true);
      } else {
        _saveRemovePref(false);
      }
    });
  }

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    remember = (prefs.getBool('remember')) ?? false;

    if (remember) {
      setState(() {
        emailController.text = email;
        passwordController.text = password;
        remember = true;
      });
    }
  }

  void _loginUser() {
    String _email = emailController.text;
    String _password = passwordController.text;
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      http.post(Uri.parse(CONSTANTS.server + "/hellojava/php/login_user.php"),
          body: {
            "email": _email,
            "password": _password,
          }).then((response) {
        print(response.body);
        var data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['status'] == 'success') {
          var extractdata = data['data'];
          var userType = data['type'];
          if (userType == 'user') {
            Fluttertoast.showToast(
                msg: "Welcome back",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                fontSize: 14,
                backgroundColor: const Color(0xFF4F646F));
            User user = User.fromJson(extractdata);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (content) => MainScreen(user: user)));
          } else if (userType == 'admin') {
            Fluttertoast.showToast(
                msg: "Welcome to admin page",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                fontSize: 14,
                backgroundColor: const Color(0xFF4F646F));
            Admin admin = Admin.fromJson(extractdata);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (content) => AdminMainScreen(admin: admin)));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Login failed",
                style: const TextStyle(color: Color(0xFFF4FAFF)),
                textAlign: TextAlign.center,
              ),
              duration: Duration(seconds: 1),
              backgroundColor: Color(0xFFAB3232),
              behavior: SnackBarBehavior
                  .fixed, // Ensures the snackbar sticks to the bottom
            ),
          );
          return;
        }
      });
    }
  }

  void _saveRemovePref(bool value) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String email = emailController.text;
      String password = passwordController.text;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (value) {
        await prefs.setString('email', email);
        await prefs.setString('pass', password);
        await prefs.setBool('remember', true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Credentials stored success",
              style: TextStyle(color: Color(0xFF4F646F)),
              textAlign: TextAlign.center,
            ),
            duration: Duration(seconds: 1),
            backgroundColor: Color(0xFFF4FAFF),
            behavior: SnackBarBehavior
                .fixed, // Ensures the snackbar sticks to the bottom
          ),
        );
      } else {
        await prefs.setString('email', '');
        await prefs.setString('pass', '');
        await prefs.setBool('remember', false);
        emailController.text = "";
        passwordController.text = "";
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Credentials removed",
              style: TextStyle(color: Color(0xFF4F646F)),
              textAlign: TextAlign.center,
            ),
            duration: Duration(seconds: 1),
            backgroundColor: Color(0xFFF4FAFF),
            behavior: SnackBarBehavior
                .fixed, // Ensures the snackbar sticks to the bottom
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Credentials failed",
            style: const TextStyle(color: Color(0xFFF4FAFF)),
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 1),
          backgroundColor: Color(0xFFAB3232),
          behavior: SnackBarBehavior
              .fixed, // Ensures the snackbar sticks to the bottom
        ),
      );
      remember = false;
    }
  }
}
