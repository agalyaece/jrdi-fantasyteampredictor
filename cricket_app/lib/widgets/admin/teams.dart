import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:cricket_app/backend_config/config.dart';
import 'package:cricket_app/models/add_teams.dart';
import 'package:cricket_app/screens/admin/add_teams.dart';

class Teams extends StatefulWidget {
  const Teams({super.key});
  @override
  State<Teams> createState() {
    return _Teams();
  }
}

class _Teams extends State<Teams> {
  List<AddTeams> _teams = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTeams();
  }

  Future<void> _fetchTeams() async {
    final url = Uri.parse(getTeamsUrl);
    try {
      final response = await http.get(url);
      // print(response.body);
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to load teams');
      }
      final List<dynamic> extractedData = json.decode(response.body);
      final List<AddTeams> _loadedItems =
          extractedData.map((item) => AddTeams.fromJson(item)).toList();

      setState(() {
        _teams = _loadedItems;
        _isLoading = false;
        _teams.sort((a, b) => b.dateStart.compareTo(a.dateStart));
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        
      });
    }
  }

  void _addNewTeams() async {
    final newItem = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => AddTeamsScreen()));

    if (newItem == null) {
      return;
    }

    setState(() {
      _teams.add(AddTeams.fromJson(newItem));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Teams'),
        actions: [
          IconButton(
            onPressed: _addNewTeams,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _teams.isEmpty
              ? const Center(
                  child: Text('No teams added yet'),
                )
              : ListView.builder(
                  itemCount: _teams.length,
                  itemBuilder: (ctx, index) => Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(
                          '${_teams[index].teamA} vs ${_teams[index].teamB}'),
                      subtitle: Text(_teams[index].tournamentName),
                      trailing: Text(
                        _teams[index].dateStart.split("T")[0],
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                ),
    );
  }
}
