class Topic {
  String? topicId;
  String? topicTitle;
  String? subtopicId;
  String? subtopicTitle;
  String? subtopicDescription;
  String? subtopicVideoLink;

  Topic(
      {this.topicId,
      this.topicTitle,
      this.subtopicId,
      this.subtopicTitle,
      this.subtopicDescription,
      this.subtopicVideoLink});

  Topic.fromJson(Map<String, dynamic> json) {
    topicId = json['topic_id'];
    topicTitle = json['topic_title'];
    subtopicId = json['subtopic_id'];
    subtopicTitle = json['subtopic_title'];
    subtopicDescription = json['subtopic_description'];
    subtopicVideoLink = json['subtopic_videolink'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['topic_id'] = topicId;
    data['topic_title'] = topicTitle;
    data['subtopic_id'] = subtopicId;
    data['subtopic_title'] = subtopicTitle;
    data['subtopic_description'] = subtopicDescription;
    data['subtopic_videolink'] = subtopicVideoLink;
    return data;
  }
}
