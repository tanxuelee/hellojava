class Game {
  String? gameId;
  String? gameMode;
  String? scoreId;
  String? totalScore;
  late String gameDate;
  String? id;
  String? name;

  Game({
    this.gameId,
    this.gameMode,
    this.scoreId,
    this.totalScore,
    required this.gameDate,
    this.id,
    this.name,
  });

  Game.fromJson(Map<String, dynamic> json) {
    gameId = json['game_id'];
    gameMode = json['game_mode'];
    scoreId = json['score_id'];
    totalScore = json['total_score'];
    gameDate = json['game_date'];
    id = json['user_id'];
    name = json['user_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['game_id'] = gameId;
    data['game_mode'] = gameMode;
    data['score_id'] = scoreId;
    data['total_score'] = totalScore;
    data['game_date'] = gameDate;
    data['user_id'] = id;
    data['user_name'] = name;
    return data;
  }
}
