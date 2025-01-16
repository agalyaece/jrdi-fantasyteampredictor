class AddTournament {
  const AddTournament({
    required this.id,
    required this.name,
    required this.organizer,
    required this.tournamentStart,
    required this.tournamentEnd,
    required this.venue,
  });

  final String id;
  final String name;
  final String venue;
  final String organizer;
  final DateTime tournamentStart;
  final DateTime tournamentEnd;

  factory AddTournament.fromJson(Map<String, dynamic> json) {
    return AddTournament(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      organizer: json['organizer'] ?? '',
      venue: json['venue'] ?? '',
      tournamentStart: DateTime.parse(json['date_start']),
      tournamentEnd: DateTime.parse(json['date_end']),
    );
  }
}
