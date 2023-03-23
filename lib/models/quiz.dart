import 'package:flutter/material.dart';

class Quiz {
  String? quizId;
  String? quizTitle;
  List<QuizQuestion>? quizquestions;
  String? scoreId;
  String? totalScore;

  Quiz({
    this.quizId,
    this.quizTitle,
    this.quizquestions,
    this.scoreId,
    this.totalScore,
  });

  Quiz.fromJson(Map<String, dynamic> json) {
    quizId = json['quiz_id'];
    quizTitle = json['quiz_title'];
    if (json['quizquestions'] != null) {
      quizquestions = <QuizQuestion>[];
      json['quizquestions'].forEach((v) {
        quizquestions!.add(QuizQuestion.fromJson(v));
      });
    }
    scoreId = json['score_id'];
    totalScore = json['total_score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['quiz_id'] = quizId;
    data['quiz_title'] = quizTitle;
    if (quizquestions != null) {
      data['quizquestions'] = quizquestions!.map((v) => v.toJson()).toList();
    }
    data['score_id'] = scoreId;
    data['total_score'] = totalScore;
    return data;
  }
}

class QuizQuestion {
  String? questionId;
  String? questionTitle;
  String? optionA;
  String? optionB;
  String? optionC;
  String? correctAnswer;
  Color? buttonColor;
  Color? buttonColorA;
  Color? buttonColorB;
  Color? buttonColorC;
  bool optionSelectedA = false;
  bool optionSelectedB = false;
  bool optionSelectedC = false;
  bool isCorrect = false;

  QuizQuestion({
    this.questionId,
    this.questionTitle,
    this.optionA,
    this.optionB,
    this.optionC,
    this.correctAnswer,
    this.buttonColor,
    this.buttonColorA,
    this.buttonColorB,
    this.buttonColorC,
    this.optionSelectedA = false,
    this.optionSelectedB = false,
    this.optionSelectedC = false,
    this.isCorrect = false,
  });

  String? getSelectedOption() {
    if (!optionSelectedA) {
      return optionA;
    } else if (!optionSelectedB) {
      return optionB;
    } else if (!optionSelectedC) {
      return optionC;
    } else {
      return "";
    }
  }

  QuizQuestion.fromJson(Map<String, dynamic> json) {
    questionId = json['question_id'];
    questionTitle = json['question_title'];
    optionA = json['option_a'];
    optionB = json['option_b'];
    optionC = json['option_c'];
    correctAnswer = json['correct_answer'];
    buttonColor = const Color(0xFF4F646F);
    buttonColorA = const Color(0xFF4F646F);
    buttonColorB = const Color(0xFF4F646F);
    buttonColorC = const Color(0xFF4F646F);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['question_id'] = questionId;
    data['question_title'] = questionTitle;
    data['option_a'] = optionA;
    data['option_b'] = optionB;
    data['option_c'] = optionC;
    data['correct_answer'] = correctAnswer;
    return data;
  }
}
