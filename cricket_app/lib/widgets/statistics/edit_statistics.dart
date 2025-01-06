import 'package:cricket_app/backend_config/config.dart';
import 'package:cricket_app/models/add_players.dart';
import 'package:cricket_app/screens/statistics/statistics.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditStatistics extends StatefulWidget {
  final AddPlayers data;

  const EditStatistics({super.key, required this.data});
  @override
  State<EditStatistics> createState() {
    return _EditStatistics();
  }
}

class _EditStatistics extends State<EditStatistics> {
  final _formKey = GlobalKey<FormState>();
  int? _enteredMatches;
  int? _enteredRuns;
  int? _enteredWickets;
  String? _enteredName;
  String? _enteredNationality;
  String? _selectedRole;
  String? _selectedTournament;
  String? _selectedTeam;

  var _isSending = false;
  @override
  void initState() {
    super.initState();
    _enteredMatches = widget.data.matchesPlayed;
    _enteredRuns = widget.data.runs;
    _enteredWickets = widget.data.wickets;
    _enteredName = widget.data.playerName;
    _enteredNationality = widget.data.nationality;
    _selectedRole = widget.data.role;
    _selectedTournament = widget.data.tournamentName;
    _selectedTeam = widget.data.teamName;
  }

  void _updateStatistics() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isSending = true;
    });
    _formKey.currentState!.save();

    final url =
        Uri.parse("${baseUrl}administration/add_stats/${widget.data.id}");
    final response = await http.put(
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
    if (response.statusCode == 200 || response.statusCode == 201) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Success", style: TextStyle(color: Colors.green)),
            content: const Text(
              " updating details  Successful",
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, const StatisticsScreen());
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error", style: TextStyle(color: Colors.red)),
            content: const Text("Failed to update details", style: TextStyle(color: Colors.white)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' Edit Statistics'),
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
                initialValue: _enteredName,
                readOnly: true,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Nationality'),
                ),
                initialValue: _enteredNationality,
                readOnly: true,
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
                    child: TextFormField(
                      maxLength: 50,
                      decoration: const InputDecoration(
                        label: Text('Role'),
                      ),
                      initialValue: _selectedRole,
                      readOnly: true,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: TextFormField(
                      maxLength: 50,
                      decoration: const InputDecoration(
                        label: Text('Tournament'),
                      ),
                      initialValue: _selectedTournament,
                      readOnly: true,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Team'),
                ),
                initialValue: _selectedTeam,
                readOnly: true,
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
                initialValue: _enteredMatches?.toString(),
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
                      maxLength: 4,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Runs',
                      ),
                      initialValue: _enteredRuns?.toString(),
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
                      initialValue: _enteredWickets?.toString(),
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
                                _enteredMatches = widget.data.matchesPlayed;
                                _enteredRuns = widget.data.runs;
                                _enteredWickets = widget.data.wickets;
                              });
                            },
                      child: const Text("Reset")),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _isSending ? null : _updateStatistics,
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
