import 'package:flutter/material.dart';
import 'package:hellojava/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late double screenHeight, screenWidth, resWidth;
  String _message = '';

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
          'Forgot Password',
          style: TextStyle(
            fontSize: 17,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const SizedBox(height: 15.0),
            const Text(
              'Please enter your email address to get your temporary password',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 15.0),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.email),
                      labelText: "Email Address",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      errorStyle: const TextStyle(color: Color(0xFFAB3232)),
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
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: screenWidth,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _resetPassword,
                      child: const Text(
                        "Reset Password",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0))),
                        backgroundColor: MaterialStateProperty.all(
                          const Color(0xFFF9A03F),
                        ),
                      ),
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

  void _resetPassword() {
    String _email = _emailController.text;
    if (_formKey.currentState!.validate()) {
      http.post(
          Uri.parse(CONSTANTS.server + "/hellojava/php/reset_password.php"),
          body: {
            "email": _email,
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
          setState(() {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  data['message'],
                  style: TextStyle(color: Color(0xFFF4FAFF)),
                  textAlign: TextAlign.center,
                ),
                duration: Duration(seconds: 2),
                backgroundColor: Color(0xFFAB3232),
                behavior: SnackBarBehavior
                    .fixed, // Ensures the snackbar sticks to the bottom
              ),
            );
          });
          return;
        }
      });
    }
  }
}
