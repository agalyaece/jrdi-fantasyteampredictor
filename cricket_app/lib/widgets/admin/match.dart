import 'package:cricket_app/backend_config/config.dart';
import 'package:cricket_app/models/add_players.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

extension StringExtension on String {
  String capitalize() {
    return this.length > 0
        ? '${this[0].toUpperCase()}${this.substring(1)}'
        : '';
  }
}

class Match extends StatefulWidget {
  const Match({super.key});
  @override
  State<Match> createState() {
    return _MatchState();
  }
}

class _MatchState extends State<Match> {
  final List<String> _team = [];
  List<AddPlayers> _playersTeamA = [];
  List<AddPlayers> _playersTeamB = [];
  List<dynamic> _selectedPlayersTeamA = [];
  List<dynamic> _selectedPlayersTeamB = [];
  var _isLoading = true;

  final TextEditingController _team1Controller = TextEditingController();
  final TextEditingController _team2Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchTeams();
    _fetchTeamAPlayers();
    _fetchTeamBPlayers();
  }

  void _fetchTeams() async {
    final url = Uri.parse(getTeamsUrl);
    final response = await http.get(url);
    // print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> teamsJson = json.decode(response.body);

      setState(() {
        _team.clear();
        _team.addAll(
            teamsJson.map((team) => team['team_A'].toString()).toList());
        _team.addAll(
            teamsJson.map((team) => team['team_B'].toString()).toList());
        // print(_team);
      });
    }
  }

  void _fetchTeamAPlayers() async {
    final teamAName = _team1Controller.text.capitalize();
    final getPlayersUrl = '${baseUrl}fantasy/$teamAName/players';
    final url = Uri.parse(getPlayersUrl);
    try {
      final response = await http.get(url);
      // print(response.body);
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to load players');
      }
      final List<dynamic> extractedData = json.decode(response.body);
      final List<AddPlayers> _loadedItems =
          extractedData.map((item) => AddPlayers.fromJson(item)).toList();

      setState(() {
        _playersTeamA = _loadedItems;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _fetchTeamBPlayers() async {
    final teamBName = _team2Controller.text.capitalize();
    final getPlayersUrl = '${baseUrl}fantasy/$teamBName/players';
    final url = Uri.parse(getPlayersUrl);
    try {
      final response = await http.get(url);
      // print(response.body);
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to load players');
      }
      final List<dynamic> extractedData = json.decode(response.body);
      final List<AddPlayers> _loadedItems =
          extractedData.map((item) => AddPlayers.fromJson(item)).toList();

      setState(() {
        _playersTeamB = _loadedItems;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _togglePlayerSelection(dynamic player, dynamic _selectedPlayers) {
    setState(() {
      if (_selectedPlayers.contains(player)) {
        _selectedPlayers.remove(player);
      } else {
        _selectedPlayers.add(player);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Match'),
        actions: [
          IconButton(
            icon: Icon(Icons.check_circle,
                color: Theme.of(context).colorScheme.primaryContainer),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(
                    'Selected Players Team 1',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _selectedPlayersTeamA.isEmpty
                        ? [
                            Text("No players selected, select players!",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary))
                          ]
                        : _selectedPlayersTeamA
                            .map((player) => Text(
                                  '${player.playerName} - ${player.role}',
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
          IconButton(
            icon: Icon(Icons.check_circle_outline,
                color: Theme.of(context).colorScheme.secondaryContainer),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(
                    'Selected Players Team 2',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _selectedPlayersTeamB.isEmpty
                        ? [
                            Text("No players selected, select players!",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary))
                          ]
                        : _selectedPlayersTeamB
                            .map((player) => Text(
                                  '${player.playerName} - ${player.role}',
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
      body: Form(
        child: Column(
          children: [
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
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                          ),
                          child: ValueListenableBuilder<TextEditingValue>(
                            valueListenable: _team1Controller,
                            builder: (context, value, child) {
                              bool isValid = _team.contains(value.text
                                  .split(' ')
                                  .map(
                                      (word) => word.toLowerCase().capitalize())
                                  .join(' '));
                              if (isValid) {
                                _fetchTeamAPlayers();
                              }
                              return Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _team1Controller,
                                      decoration: InputDecoration(
                                        labelText: 'Team 1 Name',
                                        suffixIcon: isValid
                                            ? Icon(Icons.check,
                                                color: Colors.green)
                                            : Icon(Icons.close,
                                                color: Colors.red),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _playersTeamA.length,
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
                                          value: _selectedPlayersTeamA
                                              .contains(_playersTeamA[index]),
                                          onChanged: (bool? value) {
                                            _togglePlayerSelection(
                                                _playersTeamA[index],
                                                _selectedPlayersTeamA);
                                          },
                                        ),
                                        title: Text(
                                            '${_playersTeamA[index].playerName} (${_playersTeamA[index].role}) '),
                                        onTap: () {
                                          _togglePlayerSelection(
                                              _playersTeamA[index],
                                              _selectedPlayersTeamA);
                                        },
                                      ),
                                    );
                            },
                          ),
                        )
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
                            color:
                                Theme.of(context).colorScheme.secondaryContainer,
                          ),
                          child: ValueListenableBuilder<TextEditingValue>(
                            valueListenable: _team2Controller,
                            builder: (context, value, child) {
                              bool isValid = _team.contains(value.text
                                  .split(' ')
                                  .map(
                                      (word) => word.toLowerCase().capitalize())
                                  .join(' '));
                              if (isValid) {
                                _fetchTeamBPlayers();
                              }
                              return Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _team2Controller,
                                      decoration: InputDecoration(
                                        labelText: 'Team 2 Name',
                                        suffixIcon: isValid
                                            ? Icon(Icons.check,
                                                color: Colors.green)
                                            : Icon(Icons.close,
                                                color: Colors.red),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _playersTeamB.length,
                            itemBuilder: (ctx, index) {
                              return _isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : Card(
                                      color: const Color.fromARGB(255, 39, 64, 65),
                                      margin: EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 9),
                                      child: ListTile(
                                        leading: Checkbox(
                                          value: _selectedPlayersTeamB
                                              .contains(_playersTeamB[index]),
                                          onChanged: (bool? value) {
                                            _togglePlayerSelection(
                                                _playersTeamB[index],
                                                _selectedPlayersTeamB);
                                          },
                                        ),
                                        title: Text(
                                            '${_playersTeamB[index].playerName} (${_playersTeamB[index].role}) '),
                                        onTap: () {
                                          _togglePlayerSelection(
                                              _playersTeamB[index],
                                              _selectedPlayersTeamB);
                                        },
                                      ),
                                    );
                            },
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}



// TextFormField(
//               decoration: const InputDecoration(labelText: 'Team 1 Name'),
//             ),
//             TextFormField(
//               decoration: const InputDecoration(labelText: 'Team 2 Name'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 // Fetch players from backend and show dropdowns
//               },
//               child: const Text('Fetch Players'),
//             ),
//             DropdownButtonFormField<String>(
//               items: [], // Populate with players from backend
//               onChanged: (value) {
//                 // Handle player selection
//               },
//               decoration:
//                   const InputDecoration(labelText: 'Select Players for Team 1'),
//             ),
//             DropdownButtonFormField<String>(
//               items: [], // Populate with players from backend
//               onChanged: (value) {
//                 // Handle player selection
//               },
//               decoration:
//                   const InputDecoration(labelText: 'Select Players for Team 2'),
//             ),
//             // Display selected players