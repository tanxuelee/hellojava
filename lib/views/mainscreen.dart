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
                  accountEmail: Text(widget.user.email.toString()),
                  currentAccountPicture: ClipOval(
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
                if (widget.user.email == "guest@gmail.com")
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
                if (widget.user.email == "guest@gmail.com")
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
                if (widget.user.email == "guest@gmail.com")
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
                if (widget.user.email != "guest@gmail.com")
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
                if (widget.user.email != "guest@gmail.com")
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
                if (widget.user.email != "guest@gmail.com")
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
    showDialog(
      context: context,
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
                      style: TextStyle(fontSize: 18, color: Colors.black),
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

class UserManualScreen extends StatefulWidget {
  const UserManualScreen({Key? key}) : super(key: key);

  @override
  State<UserManualScreen> createState() => _UserManualScreenState();
}

class _UserManualScreenState extends State<UserManualScreen> {
  late double screenHeight, screenWidth, resWidth;
  int _currentPage = 0;
  final _controller = PageController(initialPage: 0);

  final List<String> _functionNames = [
    'Note',
    'Exercise',
    'Quiz',
    'Game',
    'Profile'
  ];

  final List<String> _functionDescriptions = [
    'You can read the notes with or without logging in to the account. There are several subtopics available for every main topic for Java. For every subtopic, there are descriptions, image and video available to help you understand the topic better.',
    'You need to login to your account in order to do the exercises. You can choose a main topic from the list and the system will display several exercises related to the selected topic. You can view a hint that will provide some guidance for every question. After answering each question, the system will show whether your answer is correct or not. The system will also keep track of the number of questions that you have answered correctly. If you leave the session, your progress will be lost.',
    'You need to login to your account in order to so the quizzes. Each quiz has a duration of 15 minutes. Once you start the quiz, a timer will appear on the screen to show you how much time is left. You can answer each question by selecting one of the options provided. If you want to change your answer, you can click on the "Clear" button for that question and select a different option. Once you have answered all the questions, you can submit the quiz. After you submit the quiz, you can view your score and review the quiz to see which questions you got right or wrong. The correct answers will be provided. If you leave the quiz without submitting or if the time is up, your progress will be lost.',
    'To play the game, you need to login first. After logging in, you can select the game mode you want to play. You will be presented with a set of keywords that you need to rearrange in the correct order. To rearrange the keywords, long press on a keyword and drag it to the desired position. There are three game modes available: Easy, Medium, and Hard. Each mode has 5 rounds of the game, and each round will have a different duration of time and number of keywords that need to be rearranged. After each round, the system will show you whether your answer was correct or not. You can view your score and the leaderboard to see the top five of the day who have scored at least 1 mark for the selected game mode. At the main screen of the game, you also can view the leaderboard for every game mode. If you leave the game without finishing or the time runs out, your progress will be lost.',
    'To access your personal information, you need to log in using your registered email address and password. Once you have logged in, you can view your personal information such as your name, email, phone number and profile picture. You can also edit your profile information except for your email address. You can view your own quiz and game scores. To logout from your account, click on the "Logout" button. This will log you out and take you back to the guest mode screen.'
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
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Color(0xFFF9A03F),
                            ),
                            child: Text(
                              _functionNames[index],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
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
                'Hello Java is a mobile application designed to help beginners learn the theory of Java programming language. Our app provides a user-friendly interface and comprehensive learning materials to guide you through the fundamental concepts of Java. Hello Java offers various features such as notes, exercises, quizzes, and engaging games to make your learning experience enjoyable and interactive.',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFFF4FAFF),
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 20),
              const Text(
                'For any queries or feedback, please feel free to reach out to us at the email below: adminhellojava@moneymoney12345.com',
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
