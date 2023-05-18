import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:hellojava/main.dart';
import 'package:hellojava/models/user.dart';
import 'package:hellojava/views/exercisescreen.dart';
import 'package:hellojava/views/gamescreen.dart';
import 'package:hellojava/views/loginscreen.dart';
import 'package:hellojava/views/notescreen.dart';
import 'package:hellojava/views/profilescreen.dart';
import 'package:hellojava/views/quizscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<User> userList = <User>[];
  late double screenHeight, screenWidth, resWidth;
  late int val;
  Random random = Random();

  @override
  void initState() {
    super.initState();
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
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4FAFF),
        appBar: AppBar(
          title: const Text(
            'Hello Java',
            style: TextStyle(
              fontSize: 17,
            ),
          ),
          bottom: const TabBar(
            isScrollable: true,
            tabs: <Widget>[
              Tab(text: 'Note'),
              Tab(text: 'Exercise'),
              Tab(text: 'Quiz'),
              Tab(text: 'Game'),
              Tab(text: 'Profile')
            ],
          ),
        ),
        drawer: Container(
          width: screenWidth / 1.2,
          child: Drawer(
            child: ListView(
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(widget.user.name.toString()),
                  accountEmail:
                      widget.user.email.toString() != 'guest@hellojava.com'
                          ? Text(widget.user.email.toString())
                          : const Text(""),
                  currentAccountPicture: ClipOval(
                    child: GestureDetector(
                      onTap: () {
                        showGeneralDialog(
                          context: context,
                          barrierDismissible:
                              true, // Allow dismissing by tapping outside
                          barrierLabel: MaterialLocalizations.of(context)
                              .modalBarrierDismissLabel,
                          pageBuilder: (BuildContext context,
                              Animation<double> animation,
                              Animation<double> secondaryAnimation) {
                            return Dialog(
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
                            );
                          },
                          transitionBuilder: (BuildContext context,
                              Animation<double> animation,
                              Animation<double> secondaryAnimation,
                              Widget child) {
                            return ScaleTransition(
                              scale: Tween<double>(begin: 0.5, end: 1.0)
                                  .animate(animation),
                              child: child,
                            );
                          },
                        );
                      },
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
                if (widget.user.email == "guest@hellojava.com")
                  _createDrawerItem(
                    icon: Icons.location_on_rounded,
                    text: 'User Manual',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (content) => const UserManualScreen()));
                    },
                  ),
                if (widget.user.email == "guest@hellojava.com")
                  _createDrawerItem(
                    icon: Icons.info_outline_rounded,
                    text: 'About Hello Java',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (content) => const AboutScreen()));
                    },
                  ),
                if (widget.user.email == "guest@hellojava.com")
                  _createDrawerItem(
                    icon: Icons.login,
                    text: 'Login',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (content) => const LoginScreen()));
                    },
                  ),
                if (widget.user.email != "guest@hellojava.com")
                  _createDrawerItem(
                    icon: Icons.location_on_rounded,
                    text: 'User Manual',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (content) => const UserManualScreen()));
                    },
                  ),
                if (widget.user.email != "guest@hellojava.com")
                  _createDrawerItem(
                    icon: Icons.info_outline_rounded,
                    text: 'About Hello Java',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (content) => const AboutScreen()));
                    },
                  ),
                if (widget.user.email != "guest@hellojava.com")
                  _createDrawerItem(
                    icon: Icons.logout,
                    text: 'Logout',
                    onTap: () {
                      _logoutDialog();
                    },
                  ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            NoteScreen(user: widget.user),
            ExerciseScreen(user: widget.user),
            QuizScreen(user: widget.user),
            GameScreen(user: widget.user),
            ProfileScreen(user: widget.user),
          ],
        ),
      ),
    );
  }

  Widget _createDrawerItem(
      {required IconData icon,
      required String text,
      required GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  void _logoutDialog() {
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
                      "Logout?",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 25),
                    child: Text(
                      "Are you sure you want to logout?",
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyApp()),
                            );
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

class UserManualScreen extends StatefulWidget {
  const UserManualScreen({Key? key}) : super(key: key);

  @override
  State<UserManualScreen> createState() => _UserManualScreenState();
}

class _UserManualScreenState extends State<UserManualScreen> {
  late double screenHeight, screenWidth, resWidth;
  int _currentPage = 0;
  final _controller = PageController(initialPage: 0);

  final List<IconData> _functionIcons = [
    Icons.code,
    Icons.flag,
    Icons.timer,
    Icons.swap_vert_circle,
    Icons.person,
  ];

  final List<String> _functionNames = [
    'Note',
    'Exercise',
    'Quiz',
    'Game',
    'Profile'
  ];

  final List<String> _functionDescriptions = [
    'You can read the notes with or without logging in to the account. There are several subtopics available for every main topic for Java. For every subtopic, there are descriptions, image and video available to help you understand better.',
    'To access the exercises, log in to your account. Choose a main topic and the system will display related exercises. Hints are available for each question. the system will verify correctness after each question. Progress is lost if you leave.',
    'To take the quizzes, log in and complete each quiz within 15 minutes using the timer. Modify answers using the "Clear" button. Submit the quiz to review your score, correct answers, and quiz content. Progress is lost if you leave or time out.',
    'To play the game, log in and choose Easy, Medium, or Hard mode. The system will verify correctness after each round. Check the leaderboard for the daily top five. Progress is lost if you leave or time out.',
    'To access your personal info, log in with your registered email and password. After logging in, view/edit your profile (excluding email). Check/delete your quiz and game scores. Click "Logout" to log out and return to guest mode.'
  ];

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
      backgroundColor: const Color(0xFFF4FAFF),
      appBar: AppBar(
          title: const Text(
        'User Manual',
        style: TextStyle(
          fontSize: 17,
        ),
      )),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _functionNames.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(15),
                            width: 140,
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              color: Color(0xFFF9A03F),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  _functionIcons[
                                      index], // Use the corresponding icon for the function
                                  size: 40,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  height: 5,
                                ), // Add some spacing between the icon and the text
                                Text(
                                  _functionNames[index],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      _functionDescriptions[index],
                                      textAlign: TextAlign.justify,
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  onPageChanged: (int index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        if (_currentPage > 0) {
                          _controller.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "No more pages before this page",
                                style: TextStyle(color: Color(0xFFF4FAFF)),
                                textAlign: TextAlign.center,
                              ),
                              duration: Duration(seconds: 2),
                              backgroundColor: Color(0xFF4F646F),
                              behavior: SnackBarBehavior
                                  .fixed, // Ensures the snackbar sticks to the bottom
                            ),
                          );
                        }
                      },
                    ),
                    DotsIndicator(
                      dotsCount: _functionNames.length,
                      position: _currentPage,
                      decorator: DotsDecorator(
                        size: const Size.square(10.0),
                        activeSize: const Size.square(10.0),
                        activeShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () {
                        if (_currentPage < _functionNames.length - 1) {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "No more pages after this page",
                                style: TextStyle(color: Color(0xFFF4FAFF)),
                                textAlign: TextAlign.center,
                              ),
                              duration: Duration(seconds: 2),
                              backgroundColor: Color(0xFF4F646F),
                              behavior: SnackBarBehavior
                                  .fixed, // Ensures the snackbar sticks to the bottom
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60.0),
            ],
          ),
        ),
      ),
    );
  }
}

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
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
      backgroundColor: const Color(0xFF4F646F),
      appBar: AppBar(
        title: const Text(
          'About Hello Java',
          style: TextStyle(
            fontSize: 17,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              SizedBox(
                  height: screenHeight / 4,
                  width: screenWidth,
                  child: Image.asset('assets/images/logo.png')),
              const SizedBox(height: 20),
              const Text(
                'Hello Java is a beginner-friendly app that teaches Java programming theory with comprehensive materials and interactive features, creating an enjoyable learning experience.',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFFF4FAFF),
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 20),
              const Text(
                'For inquiries or feedback, email us at: adminhellojava@moneymoney12345.com',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFFF4FAFF),
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
