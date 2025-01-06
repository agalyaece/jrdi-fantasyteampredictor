


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
}


