import 'package:cricket_app/backend_config/config.dart';
import 'package:cricket_app/widgets/admin/teams.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddTeamsScreen extends StatefulWidget {
  @override
  State<AddTeamsScreen> createState() {
    return _AddTeamsScreenState();
  }
}

class _AddTeamsScreenState extends State<AddTeamsScreen> {
  final _formKey = GlobalKey<FormState>();

  var _enteredTeamA = '';
  var _enteredTeamB = '';
  String? _selectedTournament;
  DateTime? _matchStartDate;
  DateTime? _matchEndDate;
  TimeOfDay? _matchTime;
  final List<String> _tournaments = [];

  var _isSending = false;

  @override
  void initState() {
    super.initState();
    _fetchTournaments();
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

  void _submitForm() async {
    if (_formKey.currentState!.validate() &&
        _matchStartDate != null &&
        _matchEndDate != null &&
        _matchTime != null) {
      _formKey.currentState!.save();
      setState(() {
        _isSending = true;
      });

      final url = Uri.parse(addTeamsUrl);
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "team_A": _enteredTeamA,
          "team_B": _enteredTeamB,
          "tournament_name": _selectedTournament,
          "date_start": _matchStartDate.toString(),
          "date_end": _matchEndDate.toString(),
          "time": _matchTime!.hour.toString().padLeft(2, '0') +
              ':' +
              _matchTime!.minute.toString().padLeft(2, '0'),
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
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context, const Teams());
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
                  const Text("Failed to add match details. Please try again.", style: TextStyle(color: Colors.white)),
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
        title: Text('Adding Match Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Team A'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Team A';
                  }
                  return null;
                },
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Theme.of(context).colorScheme.onSurface),
                onSaved: (value) {
                  _enteredTeamA = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Team B'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Team B';
                  }
                  return null;
                },
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Theme.of(context).colorScheme.onSurface),
                onSaved: (newValue) => _enteredTeamB = newValue!,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Tournament'),
                value: _selectedTournament,
                items: _tournaments.map((String tournament) {
                  return DropdownMenuItem<String>(
                    value: tournament,
                    child: Text(tournament),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedTournament = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a tournament';
                  }
                  return null;
                },
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
              ListTile(
                title: Text(
                    ' ${_matchStartDate != null ? _matchStartDate.toString().split(' ')[0] : 'Select Date'}'),
                leading: Text(
                  "Match Start Date:",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Theme.of(context).colorScheme.onSurface),
                ),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != _matchStartDate) {
                    setState(() {
                      _matchStartDate = picked;
                    });
                  }
                },
              ),
              ListTile(
                title: Text(
                    ' ${_matchEndDate != null ? _matchEndDate.toString().split(' ')[0] : 'Select Date'}'),
                leading: Text(
                  "Match End Date:",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Theme.of(context).colorScheme.onSurface),
                ),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != _matchEndDate) {
                    setState(() {
                      _matchEndDate = picked;
                    });
                  }
                },
              ),
              ListTile(
                title: Text(
                    ' ${_matchTime != null ? _matchTime!.format(context) : 'Select Time'}'),
                leading: Text(
                  "Match Time:",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Theme.of(context).colorScheme.onSurface),
                ),
                trailing: Icon(Icons.access_time),
                onTap: () async {
                  TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null && picked != _matchTime) {
                    setState(() {
                      _matchTime = picked;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                TextButton(
                  onPressed: _isSending
                      ? null
                      : () {
                          _formKey.currentState!.reset();
                          setState(() {
                            _selectedTournament = null;
                            _matchStartDate = null;
                            _matchEndDate = null;
                            _matchTime = null;
                          });
                        },
                  child: Text("Reset"),
                ),
                const SizedBox(
                  width: 16,
                ),
                ElevatedButton(
                  onPressed: _isSending ? null : _submitForm,
                  child: _isSending
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(),
                        )
                      : Text('Submit'),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
