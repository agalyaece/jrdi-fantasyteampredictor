

class AddTeams {
  const AddTeams({
    required this.id,
    required this.tournamentName,
    required this.teamA,
    required this.teamB,
    required this.dateStart,
    required this.dateEnd,
    required this.timeStart,
  });

  final String id;
  final String tournamentName;
  final String teamA;
  final String teamB;
  final String dateStart;
  final String dateEnd;
  final String timeStart;

  factory AddTeams.fromJson(Map<String, dynamic> json) {
    return AddTeams(
      id: json['_id'] ?? '',
      teamA: json['team_A'] ?? '',
      teamB: json['team_B'] ?? '',
      dateStart: json['date_start'] ?? '',
      dateEnd: json['date_end'] ?? '',
      timeStart: json['time'] ?? '',
      tournamentName: json['tournament_name'] ?? '',
    );
  }
}
