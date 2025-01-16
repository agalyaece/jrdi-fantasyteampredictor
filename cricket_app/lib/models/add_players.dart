class AddPlayers {
  const AddPlayers(
      {required this.id,
      required this.playerName,
      required this.tournamentName,
      required this.teamName,
      required this.role,
      required this.nationality,
      required this.matchesPlayed,
      required this.runs,
      required this.wickets});

  final String id;
  final String playerName;
  final String tournamentName;
  final String teamName;
  final String role;
  final String nationality;
  final int matchesPlayed;
  final int runs;
  final int wickets;

  factory AddPlayers.fromJson(Map<String, dynamic> json) {
    return AddPlayers(
      id: json['_id'] ?? '',
      playerName: json['player_name'] ?? '',
      tournamentName: json['tournament_name'] ?? '',
      teamName: json['team_name'] ?? '',
      role: json['role'] ?? '',
      nationality: json['nationality'] ?? '',
      matchesPlayed: json['matches_played'] ?? 0,
      runs: json['runs'] ?? 0,
      wickets: json['wickets'] ?? 0,
    );
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddPlayers &&
        other.playerName == playerName &&
        other.role == role;
  }

  @override
  int get hashCode => playerName.hashCode ^ role.hashCode;
}
