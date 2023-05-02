import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hellojava/constants.dart';
import 'package:hellojava/models/quiz.dart';
import 'package:hellojava/models/user.dart';
import 'package:hellojava/views/loginscreen.dart';
import 'package:hellojava/views/mainscreen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class QuizScreen extends StatefulWidget {
  final User user;
  const QuizScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late double screenHeight, screenWidth, resWidth;
  List<Quiz> quizList = <Quiz>[];
  String titlecenter = "";

  @override
  void initState() {
    super.initState();
    _loadQuiz();
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
                  const Text(
                    "Java Quiz",
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
                      children: List.generate(quizList.length, (index) {
                        return InkWell(
                          onTap: () => {_clickQuizButton(index)},
                          child: Card(
                              color: const Color(0xFFDEE7E7),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.quiz_rounded),
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

  void _loadQuiz() {
    http
        .post(
      Uri.parse(CONSTANTS.server + "/hellojava/php/load_quiz.php"),
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
        throw const SocketException("Connection timed out");
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);
      print(jsondata);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        if (extractdata['quiz'] != null) {
          quizList = <Quiz>[];
          extractdata['quiz'].forEach((v) {
            quizList.add(Quiz.fromJson(v));
          });
        } else {
          titlecenter = "No Quiz Available";
          quizList.clear();
        }
        setState(() {});
      } else {
        titlecenter = "No Quiz Available";
        quizList.clear();
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

  _clickQuizButton(int index) {
    if (widget.user.email == "guest@gmail.com") {
      _loadOptions();
    } else {
      _startConfirmation(index);
    }
  }

  _loadOptions() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color(0xFFF4F4F4),
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

  _startConfirmation(int index) {
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
                "Start the quiz now?",
                style: TextStyle(),
              ),
              content: const Text(
                "Please note that the quiz will only have a duration of 15 minutes. Once you click 'Start', the timer will begin and you will have to complete the quiz within the given time.",
                textAlign: TextAlign.justify,
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    "Start",
                    style: TextStyle(),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (content) => QuizQuestionsScreen(
                                  user: widget.user,
                                  index: index,
                                  quizList: quizList,
                                )));
                  },
                ),
                TextButton(
                  child: const Text(
                    "Cancel",
                    style: TextStyle(),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  void _onLogin() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => const LoginScreen()));
  }
}

class QuizQuestionsScreen extends StatefulWidget {
  final User user;
  int index;
  final List<Quiz> quizList;
  QuizQuestionsScreen({
    Key? key,
    required this.user,
    required this.index,
    required this.quizList,
  }) : super(key: key);

  @override
  State<QuizQuestionsScreen> createState() => _QuizQuestionsScreenState();
}

class _QuizQuestionsScreenState extends State<QuizQuestionsScreen> {
  late double screenHeight, screenWidth, resWidth;
  List<QuizQuestion> quizquestionList = <QuizQuestion>[];
  int numCorrectAnswers = 0;
  String titlecenter = "";
  late Timer _timer;
  int _timeRemaining = 900; // 15 minutes in seconds

  @override
  void initState() {
    super.initState();
    _loadQuizQuestion();
    startTimer();
  }

  bool _allAnswered() {
    // Check if all questions have been answered
    for (int i = 0; i < quizquestionList.length; i++) {
      if (!quizquestionList[i].optionSelectedA &&
          !quizquestionList[i].optionSelectedB &&
          !quizquestionList[i].optionSelectedC) {
        return false;
      }
    }
    return true;
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeRemaining > 0) {
          _timeRemaining--;
        } else {
          _timer.cancel();
          // Show the dialog that the time is up
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              backgroundColor: const Color(0xFFF4F4F4),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: const Text('Time is up!'),
              content: const Text(
                  'Your score won\'t be saved. You can do the quiz again.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Exit'),
                ),
              ],
            ),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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

    bool allAnswered = _allAnswered();

    return WillPopScope(
      onWillPop: () async {
        bool confirm = await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFFF4F4F4),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            title: const Text('Are you sure you want to leave?'),
            content: const Text('All progress will be lost.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
        return confirm ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text(
                widget.quizList[widget.index].quizTitle.toString(),
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '(Time Left: ${(_timeRemaining ~/ 60).toString().padLeft(2, '0')}:${(_timeRemaining % 60).toString().padLeft(2, '0')})',
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
        body: quizquestionList.isEmpty
            ? Center(
                child: Text(titlecenter,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)))
            : Padding(
                padding: const EdgeInsets.all(15),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(quizquestionList.length, (index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10.0),
                        child: Card(
                          color: const Color(0xFFDEE7E7),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Question ${index + 1} / ${quizquestionList.length}',
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF4F646F)),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  quizquestionList[index]
                                      .questionTitle
                                      .toString(),
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: 400,
                                  height: quizquestionList[index]
                                              .optionA
                                              .toString()
                                              .length >
                                          38
                                      ? 80
                                      : 40,
                                  child: ElevatedButton(
                                    onPressed:
                                        quizquestionList[index].optionSelectedA
                                            ? null
                                            : () => _selectAnswer(
                                                widget.quizList,
                                                quizquestionList[index].optionA,
                                                index),
                                    child: Text(
                                      quizquestionList[index]
                                          .optionA
                                          .toString(),
                                      style: const TextStyle(fontSize: 13),
                                      textAlign: TextAlign.center,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          quizquestionList[index].buttonColorA,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: 400,
                                  height: quizquestionList[index]
                                              .optionB
                                              .toString()
                                              .length >
                                          38
                                      ? 80
                                      : 40,
                                  child: ElevatedButton(
                                    onPressed:
                                        quizquestionList[index].optionSelectedB
                                            ? null
                                            : () => _selectAnswer(
                                                widget.quizList,
                                                quizquestionList[index].optionB,
                                                index),
                                    child: Text(
                                      quizquestionList[index]
                                          .optionB
                                          .toString(),
                                      style: const TextStyle(fontSize: 13),
                                      textAlign: TextAlign.center,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          quizquestionList[index].buttonColorB,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: 400,
                                  height: quizquestionList[index]
                                              .optionC
                                              .toString()
                                              .length >
                                          38
                                      ? 80
                                      : 40,
                                  child: ElevatedButton(
                                    onPressed:
                                        quizquestionList[index].optionSelectedC
                                            ? null
                                            : () => _selectAnswer(
                                                widget.quizList,
                                                quizquestionList[index].optionC,
                                                index),
                                    child: Text(
                                      quizquestionList[index]
                                          .optionC
                                          .toString(),
                                      style: const TextStyle(fontSize: 13),
                                      textAlign: TextAlign.center,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          quizquestionList[index].buttonColorC,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: 400,
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: (quizquestionList[index]
                                                .optionSelectedA ||
                                            quizquestionList[index]
                                                .optionSelectedB ||
                                            quizquestionList[index]
                                                .optionSelectedC)
                                        ? () => _clearAnswer(index)
                                        : null,
                                    child: const Text(
                                      "Clear",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFF9A03F),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
        bottomNavigationBar: allAnswered
            ? BottomAppBar(
                child: Container(
                  color: const Color(0xFFDEE7E7),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        _timer.cancel();
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => AlertDialog(
                            backgroundColor: const Color(0xFFF4F4F4),
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0))),
                            title:
                                const Text('Are you sure you want to submit?'),
                            content: const Text(
                                'You cannot change your answers after submitting.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _submitQuiz(numCorrectAnswers);
                                },
                                child: const Text('Submit'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  startTimer();
                                },
                                child: const Text('Cancel'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              )
            : null,
      ),
    );
  }

  void _loadQuizQuestion() {
    http.post(
      Uri.parse(CONSTANTS.server + "/hellojava/php/load_quizquestions.php"),
      body: {
        'quiz_id': widget.quizList[widget.index].quizId.toString(),
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
        throw const SocketException("Connection timed out");
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);
      print(jsondata);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        if (extractdata['quizquestion'] != null) {
          quizquestionList = <QuizQuestion>[];
          extractdata['quizquestion'].forEach((v) {
            quizquestionList.add(QuizQuestion.fromJson(v));
          });
        } else {
          titlecenter = "No Question Available";
          quizquestionList.clear();
        }
        setState(() {});
      } else {
        //do something
        titlecenter = "No Question Available";
        quizquestionList.clear();
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

  void _selectAnswer(
      List<Quiz> quizList, String? selectedOption, int questionIndex) {
    if (selectedOption == quizquestionList[questionIndex].correctAnswer) {
      quizquestionList[questionIndex].isCorrect = true;
      numCorrectAnswers++;
    } else {
      quizquestionList[questionIndex].isCorrect = false;
    }
    if (selectedOption == quizquestionList[questionIndex].optionA) {
      quizquestionList[questionIndex].buttonColorA =
          quizquestionList[questionIndex].buttonColor;
      quizquestionList[questionIndex].optionSelectedA = false;
      quizquestionList[questionIndex].optionSelectedB = true;
      quizquestionList[questionIndex].optionSelectedC = true;
    } else if (selectedOption == quizquestionList[questionIndex].optionB) {
      quizquestionList[questionIndex].buttonColorB =
          quizquestionList[questionIndex].buttonColor;
      quizquestionList[questionIndex].optionSelectedA = true;
      quizquestionList[questionIndex].optionSelectedB = false;
      quizquestionList[questionIndex].optionSelectedC = true;
    } else if (selectedOption == quizquestionList[questionIndex].optionC) {
      quizquestionList[questionIndex].buttonColorC =
          quizquestionList[questionIndex].buttonColor;
      quizquestionList[questionIndex].optionSelectedA = true;
      quizquestionList[questionIndex].optionSelectedB = true;
      quizquestionList[questionIndex].optionSelectedC = false;
    }
    setState(() {});
  }

  void _clearAnswer(int questionIndex) {
    if (quizquestionList[questionIndex].isCorrect) {
      numCorrectAnswers--;
    }
    setState(() {
      quizquestionList[questionIndex].optionSelectedA = false;
      quizquestionList[questionIndex].optionSelectedB = false;
      quizquestionList[questionIndex].optionSelectedC = false;
    });
  }

  void _submitQuiz(int totalScore) async {
    http.post(Uri.parse(CONSTANTS.server + "/hellojava/php/submit_quiz.php"),
        body: {
          "user_id": widget.user.id.toString(),
          "quiz_id": widget.quizList[widget.index].quizId.toString(),
          "total_score": totalScore.toString(),
        }).then((response) {
      print(response.body);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        // Show the score and review of the quiz
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
                title: const Text('Quiz Score'),
                content: Text(
                  'Your score is $totalScore / ${quizquestionList.length}',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizReviewScreen(
                          quizQuestions: quizquestionList,
                        ),
                      ),
                    ),
                    child: const Text('Review'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (content) =>
                                MainScreen(user: widget.user))),
                    child: const Text('Exit'),
                  ),
                ],
              ),
            );
          },
        );
      } else {
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
                title: const Text('Error'),
                content: const Text(
                    'An error occurred while saving your quiz score, please try it again.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          },
        );
      }
    });
  }
}

class QuizReviewScreen extends StatelessWidget {
  final List<QuizQuestion> quizQuestions;

  const QuizReviewScreen({Key? key, required this.quizQuestions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final numQuestions = quizQuestions.length;
    final numCorrectAnswers =
        quizQuestions.where((question) => question.isCorrect).toList().length;

    // Define the icons for correct and incorrect answers
    const correctIcon =
        Icon(Icons.check, color: Color.fromARGB(255, 36, 96, 38));
    const incorrectIcon =
        Icon(Icons.close, color: Color.fromARGB(255, 199, 33, 21));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Quiz Review",
          style: TextStyle(
            fontSize: 17,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: numQuestions,
        itemBuilder: (context, index) {
          final question = quizQuestions[index];
          final isCorrect = question.isCorrect;

          // Determine which icon to display based on whether the answer is correct or incorrect
          final icon = isCorrect ? correctIcon : incorrectIcon;

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Question ${index + 1} / $numQuestions',
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4F646F)),
                      ),
                      const SizedBox(width: 8),
                      // Display the icon beside the correct or incorrect text
                      icon,
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${question.questionTitle}",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    question.isCorrect
                        ? "${question.getSelectedOption()}"
                        : "${question.getSelectedOption()}",
                    style: TextStyle(
                      fontSize: 15,
                      color: question.isCorrect
                          ? const Color.fromARGB(255, 36, 96, 38)
                          : const Color.fromARGB(255, 199, 33, 21),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 400,
                    color: const Color(0xFFDEE7E7),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Correct answer: ${question.correctAnswer}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          color: const Color(0xFF4F646F),
          height: 50,
          child: Center(
            child: Text(
              "Your score is $numCorrectAnswers / $numQuestions",
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
