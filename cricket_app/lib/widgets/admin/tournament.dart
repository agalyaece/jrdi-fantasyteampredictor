import 'package:cricket_app/backend_config/config.dart';
import 'package:cricket_app/models/add_tournament.dart';
import 'package:cricket_app/screens/admin/add_tournament.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Tournament extends StatefulWidget {
  const Tournament({super.key});
  @override
  State<Tournament> createState() {
    return _Tournament();
  }
}

class _Tournament extends State<Tournament> {
    List<AddTournament> _tournament = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTournaments();
  }

  Future<void> _fetchTournaments() async {
    final url = Uri.parse(getTournamentUrl);
    final response = await http.get(url);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to load tournaments');
    }

    final List<dynamic> extractedData = json.decode(response.body);
    final List<AddTournament> _loadedItems = [];
    for (final item in extractedData) {
      _loadedItems.add(AddTournament(
        id: item["_id"] ?? '',
        name: item["name"] ?? '',
        organizer: item["organizer"] ?? '',
        venue: item["venue"] ?? '',
        tournamentStart: DateTime.parse(item["date_start"]),
        tournamentEnd: DateTime.parse(item["date_end"]),
      ));
    }

    setState(() {
      _tournament = _loadedItems;
      _isLoading = false;
      _tournament.sort((a, b) => b.tournamentStart.compareTo(a.tournamentStart));
    });
  }

  void _addNewTournament() async {
    final newItem = await Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => const AddTournamentScreen(),
    ));

    if (newItem == null) {
      return;
    }

    setState(() {
      _tournament.add(AddTournament.fromJson(newItem));
      
    });
  }


 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Tournament"),
        actions: [
          IconButton(
            onPressed: _addNewTournament,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _tournament.isEmpty
              ? const Center(child: Text("No tournaments added yet."))
              : ListView.builder(
                  itemCount: _tournament.length,
                  itemBuilder: (ctx, index) => Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(_tournament[index].name),
                      subtitle: Text(_tournament[index].venue),
                      leading: Text(_tournament[index]
                          .tournamentStart
                          .toString()
                          .split(" ")[0]),
                      // trailing: IconButton(
                      //     onPressed: () {
                      //         _removeItem(_tournament[index]);
                      //     },
                      //     icon: const Icon(Icons.delete),
                      // ),
                    ),
                  ),
                ),
    );
  }
}
