import 'package:cricket_app/backend_config/config.dart';
import 'package:cricket_app/widgets/admin/players.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddPlayersScreen extends StatefulWidget {
  const AddPlayersScreen({super.key});

  @override
  State<AddPlayersScreen> createState() {
    return _AddPlayersScreenState();
  }
}

class _AddPlayersScreenState extends State<AddPlayersScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredNationality = '';
  int _enteredMatches = 0;
  int _enteredRuns = 0;
  int _enteredWickets = 0;
  String? _selectedRole;
  String? _selectedTournament;
  String? _selectedTeam;

  final List<String> _role = <String>[
    'Batter',
    'Bowler',
    'Allrounder',
    'Wicketkeeper'
  ];
  final List<String> _tournaments = [];
  final List<String> _team = [];

  var _isSending = false;

  @override
  void initState() {
    super.initState();
    _fetchTournaments();
    _fetchTeams();
  }

  void _fetchTournaments() async {
    final url = Uri.parse(getTournamentUrl);

    final response = await http.get(url);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> tournamentsJson = json.decode(response.body);
      setState(() {
        _tournaments.clear();
        _tournaments.addAll(tournamentsJson
            .map((tournament) => tournament['name'].toString())
            .toList());
      });
    } else {
      // Handle error
    }
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

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isSending = true;
      });

      final url = Uri.parse(addPlayersUrl);
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "tournament_name": _selectedTournament,
          "team_name": _selectedTeam,
          "player_name": _enteredName,
          "role": _selectedRole,
          "nationality": _enteredNationality,
          "matches_played": _enteredMatches,
          "runs": _enteredRuns,
          "wickets": _enteredWickets,
        }),
      );
      // print(response.statusCode);
      // print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (!context.mounted) {
          return;
        }
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Success", style: TextStyle(color: Colors.green)),
              content: const Text("The addition was Successful", style: TextStyle(color: Colors.white)),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context, const Players());
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      } else {
        // Handle error
        setState(() {
          _isSending = false;
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error", style: TextStyle(color: Colors.red)),
              content:
                  const Text("Failed to add player details. Please try again.", style: TextStyle(color: Colors.white)),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Player Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Player Name'),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter valid characters';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredName = value!;
                },
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                maxLength: 20,
                decoration: const InputDecoration(
                  label: Text('Nationality'),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter valid characters';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredNationality = value!;
                },
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selectedRole,
                      items: _role.map((role) {
                        return DropdownMenuItem(
                          value: role,
                          child: Text(role),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedRole = value.toString();
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a role';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        label: Text('Select Role'),
                      ),
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedTournament,
                      items: _tournaments.map((String tournament) {
                        return DropdownMenuItem<String>(
                          value: tournament,
                          child: Text(tournament),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedTournament = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a tournament';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        label: Text('Select Tournament'),
                      ),
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              DropdownButtonFormField<String>(
                value: _selectedTeam,
                items: _team.toSet().map((String team) {
                  return DropdownMenuItem<String>(
                    value: team,
                    child: Text(team),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTeam = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a team';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  label: Text('Select Team'),
                ),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                maxLength: 4,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: const InputDecoration(
                  label: Text('Matches Played'),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter valid Number';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _enteredMatches = int.tryParse(value!) ?? 0;
                },
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Runs',
                      ),
                      onSaved: (value) {
                        _enteredRuns = int.tryParse(value!) ?? 0;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter runs';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: TextFormField(
                      maxLength: 4,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: const InputDecoration(
                        label: Text('Wickets taken'),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter valid Number';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        _enteredWickets = int.tryParse(value!) ?? 0;
                      },
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: _isSending
                          ? null
                          : () {
                              _formKey.currentState!.reset();
                              setState(() {
                                _selectedRole = null;
                                _selectedTournament = null;
                                _selectedTeam = null;
                              });
                            },
                      child: const Text("Reset")),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _isSending ? null : _saveItem,
                    child: _isSending
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(),
                          )
                        : const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
