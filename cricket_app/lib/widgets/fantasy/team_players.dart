import 'package:cricket_app/backend_config/config.dart' show baseUrl;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TeamPlayers extends StatefulWidget {
  final String teamA;
  final String teamB;

  const TeamPlayers({required this.teamA, required this.teamB});

  @override
  _TeamPlayersState createState() => _TeamPlayersState();
}

class _TeamPlayersState extends State<TeamPlayers> {
  bool _isLoading = false;
  String? _error;
  List<dynamic> _teamAPlayers = [];
  List<dynamic> _teamBPlayers = [];
  List<dynamic> _selectedPlayers = [];
  final int _maxPlayersPerTeam = 7;
  final int _maxTotalPlayers = 11;

  @override
  void initState() {
    super.initState();
    _fetchPlayers();
  }

  Future<void> _fetchPlayers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(
          '${baseUrl}fantasy/${widget.teamA}/vs/${widget.teamB}/players'));
      if (response.statusCode == 200) {
        final players = json.decode(response.body);
        setState(() {
          _teamAPlayers = players
              .where((player) => player['team_name'] == widget.teamA)
              .toList();
          _teamBPlayers = players
              .where((player) => player['team_name'] == widget.teamB)
              .toList();
          _isLoading = false;
        });
        // print(_teamAPlayers);
        // print(_teamBPlayers);
      } else {
        throw Exception('Failed to load teams');
      }
    } catch (error) {
      setState(() {
        _error = error.toString();
        _isLoading = false;
      });
    }
  }

  void _togglePlayerSelection(dynamic player) {
    setState(() {
      if (_selectedPlayers.contains(player)) {
        _selectedPlayers.remove(player);
      } else {
        if (_selectedPlayers.length < _maxTotalPlayers) {
          int teamASelected = _selectedPlayers
              .where((p) => p['team_name'] == widget.teamA)
              .length;
          int teamBSelected = _selectedPlayers
              .where((p) => p['team_name'] == widget.teamB)
              .length;
          if ((player['team_name'] == widget.teamA &&
                  teamASelected < _maxPlayersPerTeam) ||
              (player['team_name'] == widget.teamB &&
                  teamBSelected < _maxPlayersPerTeam)) {
            _selectedPlayers.add(player);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.teamA} vs ${widget.teamB}"),
        actions: [
          IconButton(
            icon: Icon(Icons.people_alt),
            onPressed: () {
              // Show selected players
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(
                    'Selected Players',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _selectedPlayers.isEmpty
                        ? [
                            Text("No players selected please select",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary))
                          ]
                        : _selectedPlayers
                            .map((player) => Text(
                                  '${player['player_name']} - ${player['role']}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                ))
                            .toList(),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            margin: EdgeInsets.all(9),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9.0),
              color: Theme.of(context).colorScheme.secondary,
            ),
            // color: Colors.grey[200],
            child: Text(
              'Selected Players: ${_selectedPlayers.length}/$_maxTotalPlayers',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.0),
                        margin:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 9),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9.0),
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                        // color: Theme.of(context).colorScheme.primaryContainer,
                        child: Text(
                          'Playing XI - ${widget.teamA}',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _teamAPlayers.length,
                          itemBuilder: (ctx, index) {
                            return _isLoading
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : Card(
                                    color: Colors.blueGrey,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 9),
                                    child: ListTile(
                                      leading: Checkbox(
                                        value: _selectedPlayers
                                            .contains(_teamAPlayers[index]),
                                        onChanged: (bool? value) {
                                          _togglePlayerSelection(
                                              _teamAPlayers[index]);
                                        },
                                      ),
                                      title: Text(
                                          '${_teamAPlayers[index]['player_name']} (${_teamAPlayers[index]['role']}) '),
                                      onTap: () {
                                        _togglePlayerSelection(
                                            _teamAPlayers[index]);
                                      },
                                    ),
                                  );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.0),
                        margin:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 9),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9.0),
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                        child: Text(
                          'Playing XI - ${widget.teamB}',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _teamBPlayers.length,
                          itemBuilder: (ctx, index) {
                            return _isLoading
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : Card(
                                    color: Colors.blueGrey,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 9),
                                    child: ListTile(
                                      leading: Checkbox(
                                        value: _selectedPlayers
                                            .contains(_teamBPlayers[index]),
                                        onChanged: (bool? value) {
                                          _togglePlayerSelection(
                                              _teamBPlayers[index]);
                                        },
                                      ),
                                      title: Text(
                                          '${_teamBPlayers[index]['player_name']} (${_teamBPlayers[index]['role']})'),
                                      onTap: () {
                                        _togglePlayerSelection(
                                            _teamBPlayers[index]);
                                      },
                                    ),
                                  );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
