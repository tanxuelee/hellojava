import 'package:flutter/material.dart';

class Topic {
  String? topicId;
  String? topicTitle;
  String? subtopicId;
  String? subtopicTitle;
  String? subtopicDescription;
  String? subtopicVideoLink;
  List<Exercise>? exercises;

  Topic({
    this.topicId,
    this.topicTitle,
    this.subtopicId,
    this.subtopicTitle,
    this.subtopicDescription,
    this.subtopicVideoLink,
    this.exercises,
  });

  Topic.fromJson(Map<String, dynamic> json) {
    topicId = json['topic_id'];
    topicTitle = json['topic_title'];
    subtopicId = json['subtopic_id'];
    subtopicTitle = json['subtopic_title'];
    subtopicDescription = json['subtopic_description'];
    subtopicVideoLink = json['subtopic_videolink'];
    if (json['exercises'] != null) {
      exercises = <Exercise>[];
      json['exercises'].forEach((v) {
        exercises!.add(Exercise.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['topic_id'] = topicId;
    data['topic_title'] = topicTitle;
    data['subtopic_id'] = subtopicId;
    data['subtopic_title'] = subtopicTitle;
    data['subtopic_description'] = subtopicDescription;
    data['subtopic_videolink'] = subtopicVideoLink;
    if (exercises != null) {
      data['exercises'] = exercises!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Exercise {
  String? exerciseId;
  String? exerciseTitle;
  List<Question>? questions;

  Exercise({
    this.exerciseId,
    this.exerciseTitle,
    this.questions,
  });

  Exercise.fromJson(Map<String, dynamic> json) {
    exerciseId = json['exercise_id'];
    exerciseTitle = json['exercise_title'];
    if (json['questions'] != null) {
      questions = <Question>[];
      json['questions'].forEach((v) {
        questions!.add(Question.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['exercise_id'] = exerciseId;
    data['exercise_title'] = exerciseTitle;
    if (questions != null) {
      data['questions'] = questions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Question {
  String? questionId;
  String? questionTitle;
  String? hint;
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

  Question({
    this.questionId,
    this.questionTitle,
    this.hint,
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
  });

  Question.fromJson(Map<String, dynamic> json) {
    questionId = json['question_id'];
    questionTitle = json['question_title'];
    hint = json['question_hint'];
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
    data['question_hint'] = hint;
    data['option_a'] = optionA;
    data['option_b'] = optionB;
    data['option_c'] = optionC;
    data['correct_answer'] = correctAnswer;
    return data;
  }
}
