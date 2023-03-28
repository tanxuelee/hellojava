import 'package:flutter/material.dart';
import 'package:hellojava/models/user.dart';
import 'package:hellojava/views/loginscreen.dart';
import 'package:word_search/word_search.dart';

class GameScreen extends StatefulWidget {
  final User user;
  GameScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
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
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Center(
          child: SizedBox(
            height: 50,
            width: 100,
            child: ElevatedButton(
              onPressed: _clickPlayButton,
              child: const Text(
                "Play Game",
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
        ),
      ),
    );
  }

  void _clickPlayButton() {
    if (widget.user.email == "guest@gmail.com") {
      _loadOptions();
    } else {
      _startConfirmation();
    }
  }

  _loadOptions() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color(0xFFF4FAFF),
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

  _startConfirmation() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {},
            child: AlertDialog(
              backgroundColor: const Color(0xFFF4FAFF),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: const Text(
                "Play game now?",
                style: TextStyle(),
              ),
              content: const Text(
                "",
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
                            builder: (content) => PlayGameScreen(
                                  user: widget.user,
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

class PlayGameScreen extends StatefulWidget {
  final User user;
  PlayGameScreen({
    Key? key,
    required this.user,
  });

  @override
  State<PlayGameScreen> createState() => _PlayGameScreenState();
}

class _PlayGameScreenState extends State<PlayGameScreen> {
  late double screenHeight, screenWidth, resWidth;
  int numBoxPerRow = 5;
  double padding = 3;
  Size sizeBox = Size.zero;
  ValueNotifier<List<List<String>>> listChars =
      new ValueNotifier<List<List<String>>>([]);

  // Save all answers on generate crossword data
  ValueNotifier<List<CrosswordAnswer>> answerList =
      new ValueNotifier<List<CrosswordAnswer>>([]);

  ValueNotifier<CurrentDragObj> currentDragObj =
      new ValueNotifier<CurrentDragObj>(
          new CurrentDragObj(currentTouch: Offset.zero, indexArrayOnTouch: 0));

  ValueNotifier<List<int>> charDone = new ValueNotifier<List<int>>(<int>[]);

  @override
  void initState() {
    super.initState();
    listChars = new ValueNotifier<List<List<String>>>([]);
    answerList = new ValueNotifier<List<CrosswordAnswer>>([]);
    currentDragObj = new ValueNotifier<CurrentDragObj>(
        new CurrentDragObj(currentTouch: Offset.zero, indexArrayOnTouch: 0));
    charDone = new ValueNotifier<List<int>>(<int>[]);
    //generate char array crossword
    generateRandomWord();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }
    return WillPopScope(
      onWillPop: () async {
        bool confirm = await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFFF4FAFF),
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
          title: const Text('Game Screen'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: double.maxFinite,
                    height: size.width - padding * 12,
                    color: const Color(0xFF4F646F),
                    padding: EdgeInsets.all(padding),
                    margin: EdgeInsets.all(padding),
                    child: drawCrosswordBox(),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: drawAnswerList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void generateRandomWord() {
    final List<String> wl = [
      'hello',
      'world',
      'foo',
      'baz',
      'dart',
      'java',
    ];

    //setup configuration to generate crosswords
    final WSSettings ws = WSSettings(
      width: numBoxPerRow,
      height: numBoxPerRow,
      orientations: List.from([
        WSOrientation.horizontal,
        WSOrientation.horizontalBack,
        WSOrientation.vertical,
        WSOrientation.vertical,
        WSOrientation.verticalUp,
        // WSOrientation.diagonal,
        // WSOrientation.diagonalUp,
      ]),
    );

    // Create new instance of the WordSearch class
    final WordSearch wordSearch = WordSearch();

    // Create a new puzzle
    final WSNewPuzzle newPuzzle = wordSearch.newPuzzle(wl, ws);

    // Check if there are errors generated while creating the puzzle
    if (newPuzzle.errors.isEmpty) {
      listChars.value = newPuzzle.puzzle;

      // solve puzzle for given word list
      final WSSolved solved = wordSearch.solvePuzzle(newPuzzle.puzzle, wl);

      answerList.value = solved.found
          .map((solve) => new CrosswordAnswer(solve, numPerRow: numBoxPerRow))
          .toList();
    }
  }

  Widget drawCrosswordBox() {
    return Listener(
      onPointerUp: (event) => onDragEnd(event),
      onPointerMove: (event) => onDragUpdate(event),
      child: LayoutBuilder(builder: (context, constraints) {
        sizeBox = Size(constraints.maxWidth, constraints.maxWidth);
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1,
            crossAxisCount: numBoxPerRow,
            crossAxisSpacing: padding,
            mainAxisSpacing: padding,
          ),
          itemCount: numBoxPerRow * numBoxPerRow,
          physics: ScrollPhysics(),
          itemBuilder: ((context, index) {
            String char = listChars.value.expand((e) => e).toList()[index];
            return Listener(
              onPointerDown: (event) => onDragStart(index),
              child: ValueListenableBuilder(
                valueListenable: currentDragObj,
                builder: ((context, CurrentDragObj value, child) {
                  Color color = const Color(0xFFF4FAFF);

                  if (value.currentDragLine.contains(index)) {
                    color = const Color(0xFF4F646F);
                  } else if (charDone.value.contains(index)) {
                    color = const Color(0xFFF9A03F);
                  } // change color box already path correct

                  return Container(
                    decoration: BoxDecoration(color: color),
                    // decoration: BoxDecoration(color: Color(0xFFF9A03F)),
                    alignment: Alignment.center,
                    child: Text(
                      char.toUpperCase(),
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  );
                }),
              ),
            );
          }),
        );
      }),
    );
  }

  drawAnswerList() {
    return Container(
      child: ValueListenableBuilder(
          valueListenable: answerList,
          builder: (context, List<CrosswordAnswer> value, child) {
            int perColTotal = 3;
            List<Widget> list = List.generate(
                (value.length ~/ perColTotal) +
                    ((value.length % perColTotal) > 0 ? 1 : 0), (int index) {
              int maxColumn = (index + 1) * perColTotal;
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                      maxColumn > value.length
                          ? maxColumn - value.length
                          : perColTotal, ((indexChild) {
                    int indexArray = (index) * perColTotal + indexChild;
                    return Text(
                        "${value[indexArray].wsLocation.word}".toUpperCase(),
                        style: TextStyle(
                          fontSize: 15,
                          color: value[indexArray].done
                              ? Colors.green
                              : Colors.black,
                          decoration: value[indexArray].done
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ));
                  })).toList(),
                ),
              );
            }).toList();

            return Container(
              child: Column(
                children: list,
              ),
            );
          }),
    );
  }

  void onDragEnd(PointerUpEvent event) {
    if (event == null) {
      // handle null event
      return;
    }

    // continue with normal code
    print("PointerUpEvent");
    // check if drag line object got valur or not, if no, no need to clear
    if (currentDragObj.value.currentDragLine == null) return;

    currentDragObj.value.currentDragLine.clear();
    currentDragObj.notifyListeners();
  }

  // bool areAllAnswersSolved() {
  //   final List<int> charDoneList = charDone.value;
  //   for (int i = 0; i < answerList.value.length; i++) {
  //     if (!charDoneList.contains(i)) {
  //       return false;
  //     }
  //   }
  //   return true;
  // }

  void onDragUpdate(PointerMoveEvent event) {
    print("PointerMoveEvent");
    // generate ondragline so we know to hightlight path later
    generateLineOnDrag(event);

    //get index on drag
    int indexFound = answerList.value.indexWhere((answer) {
      return answer.answerLines.join("-") ==
          currentDragObj.value.currentDragLine.join("-");
    });

    if (indexFound >= 0) {
      answerList.value[indexFound].done = true;
      // save answerList which complete
      charDone.value.addAll(answerList.value[indexFound].answerLines);
      charDone.notifyListeners();
      answerList.notifyListeners();
      onDragEnd(event) {
        if (event != null) {
          // call onDragEnd method with event as argument
          onDragEnd(event);
        }
      }
    }

    // bool allAnswersSolved = areAllAnswersSolved();
    // if (allAnswersSolved) {
    //   showFinishDialog();
    // }
  }

  // void showFinishDialog() {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) => AlertDialog(
  //       backgroundColor: const Color(0xFFF4FAFF),
  //       shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.all(Radius.circular(20.0)),
  //       ),
  //       title: const Text('Congratulations!'),
  //       content: const Text('You have solved all the answers.'),
  //       actions: [
  //         TextButton(
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //             Navigator.of(context).pop();
  //           },
  //           child: const Text('OK'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void onDragStart(int indexArray) {
    try {
      List<CrosswordAnswer> indexSelecteds = answerList.value
          .where((answer) => answer.indexArray == indexArray)
          .toList();

      //check indexSelecteds got any match, if 0 no proceed
      if (indexSelecteds.length == 0) return;

      print("PointerDownEvent");
      currentDragObj.value.indexArrayOnTouch = indexArray;
      currentDragObj.notifyListeners();
    } catch (e) {}
  }

  void generateLineOnDrag(PointerMoveEvent event) {
    // if current drag line is null, declare new list for we can save value
    if (currentDragObj.value.currentDragLine == null) {
      currentDragObj.value.currentDragLine = <int>[];
    }

    // we need calculate index array base local position on drag
    int indexBase = calculateIndexBasePosLocal(event.localPosition);

    if (indexBase >= 0) {
      // check drag line already pass 2 box
      if (currentDragObj.value.currentDragLine.length >= 2) {
        //check drag line is straight line
        WSOrientation? wsOrientation;

        if (currentDragObj.value.currentDragLine[0] % numBoxPerRow ==
            currentDragObj.value.currentDragLine[1] % numBoxPerRow) {
          wsOrientation = WSOrientation.vertical;
        } else if (currentDragObj.value.currentDragLine[0] ~/ numBoxPerRow ==
            currentDragObj.value.currentDragLine[1] ~/ numBoxPerRow) {
          wsOrientation = WSOrientation.horizontal;
        }

        if (wsOrientation == WSOrientation.horizontal) {
          if (indexBase ~/ numBoxPerRow !=
              currentDragObj.value.currentDragLine[1] ~/ numBoxPerRow) {
            onDragEnd(event) {
              if (event != null) {
                // call onDragEnd method with event as argument
                onDragEnd(event);
              }
            }
          }
        } else if (wsOrientation == WSOrientation.vertical) {
          if (indexBase % numBoxPerRow !=
              currentDragObj.value.currentDragLine[1] % numBoxPerRow) {
            onDragEnd(event) {
              if (event != null) {
                // call onDragEnd method with event as argument
                onDragEnd(event);
              }
            }
          }
        } else {
          onDragEnd(event) {
            if (event != null) {
              // call onDragEnd method with event as argument
              onDragEnd(event);
            }
          }
        }
      }

      if (!currentDragObj.value.currentDragLine.contains(indexBase)) {
        currentDragObj.value.currentDragLine.add(indexBase);
      } else if (currentDragObj.value.currentDragLine.length >= 2) {
        if (currentDragObj.value.currentDragLine[
                currentDragObj.value.currentDragLine.length - 2] ==
            indexBase) {
          onDragEnd(event) {
            if (event != null) {
              // call onDragEnd method with event as argument
              onDragEnd(event);
            }
          }
        }
      }

      currentDragObj.notifyListeners();
    }
  }

  int calculateIndexBasePosLocal(Offset localPosition) {
    // get size max per box
    double maxSizeBox =
        ((sizeBox.width - (numBoxPerRow - 1) * padding) / numBoxPerRow);

    if (localPosition.dy > sizeBox.width || localPosition.dx > sizeBox.width) {
      return -1;
    }

    int x = 0, y = 0;
    double yAxis = 0, xAxis = 0;
    double yAxisStart = 0, xAxisStart = 0;

    for (var i = 0; i < numBoxPerRow; i++) {
      xAxisStart = xAxis;
      xAxis += maxSizeBox +
          (i == 0 || i == (numBoxPerRow - 1) ? padding / 2 : padding);

      if (xAxisStart < localPosition.dx && xAxis > localPosition.dx) {
        x = i;
        break;
      }
    }

    for (var i = 0; i < numBoxPerRow; i++) {
      yAxisStart = yAxis;
      yAxis += maxSizeBox +
          (i == 0 || i == (numBoxPerRow - 1) ? padding / 2 : padding);

      if (yAxisStart < localPosition.dy && yAxis > localPosition.dy) {
        y = i;
        break;
      }
    }

    return y * numBoxPerRow + x;
  }
}

class CurrentDragObj {
  Offset currentDragPos = Offset.zero;
  Offset currentTouch;
  int indexArrayOnTouch;
  List<int> currentDragLine = <int>[];

  CurrentDragObj({
    required this.indexArrayOnTouch,
    required this.currentTouch,
  });
}

class CrosswordAnswer {
  bool done = false;
  int indexArray = 0;
  WSLocation wsLocation;
  List<int> answerLines = <int>[];

  CrosswordAnswer(this.wsLocation, {required int numPerRow}) {
    this.indexArray = this.wsLocation.y * numPerRow + this.wsLocation.x;
    generateAnswerLine(numPerRow);
  }

  // Get answer index for each character word
  void generateAnswerLine(int numPerRow) {
    this.answerLines = <int>[];

    // push all index based base word array
    this.answerLines.addAll(List<int>.generate(this.wsLocation.overlap,
        (index) => generateIndexBaseOnAxis(this.wsLocation, index, numPerRow)));
  }

  // calculate index base axis x & y
  generateIndexBaseOnAxis(WSLocation wsLocation, int i, int numPerRow) {
    int x = wsLocation.x, y = wsLocation.y;

    if (wsLocation.orientation == WSOrientation.horizontal ||
        wsLocation.orientation == WSOrientation.horizontalBack) {
      x = (wsLocation.orientation == WSOrientation.horizontal) ? x + i : x - i;
    } else {
      y = (wsLocation.orientation == WSOrientation.vertical) ? y + i : y - i;
    }

    return x + y * numPerRow;
  }
}
