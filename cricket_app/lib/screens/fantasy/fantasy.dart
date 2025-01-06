import 'package:cricket_app/backend_config/config.dart';
import 'package:cricket_app/widgets/fantasy/team_players.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FantasyScreen extends StatefulWidget {
  const FantasyScreen({super.key});

  @override
  State<FantasyScreen> createState() => _FantasyScreenState();
}

class _FantasyScreenState extends State<FantasyScreen> {
  List<Map<String, dynamic>> _matches = [];

  void _fetchTeams() async {
    final url = Uri.parse(getTeamsUrl);
    final response = await http.get(url);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> extractedData = json.decode(response.body);
      // print(extractedData);
      setState(() {
        _matches = extractedData.map((match) {
          return {
            'teamA': match['team_A'],
            'teamB': match['team_B'],
            'tournamentName': match['tournament_name'],
            'dateStart': DateTime.parse(match['date_start']),
            'timeStart': match['time'],
          };
        }).toList();
        _matches.sort((a, b) => b['dateStart'].compareTo(a['dateStart']));
        // print(_matches);
      });
    } else {
      throw Exception('Failed to load teams');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTeams();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _matches.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _matches.length,
              itemBuilder: (ctx, index) {
                return Card(
                  child: ListTile(
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _matches[index]['tournamentName'] ??
                              'Tournament Name',
                          style: TextStyle(fontSize: 12),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${_matches[index]['teamA']} vs ${_matches[index]['teamB']}',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${_matches[index]['dateStart'].toString().split(" ")[0]}  ',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.timer, size: 16),
                        SizedBox(width: 4),
                        Text(
                          _matches[index]['timeStart'],
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => TeamPlayers(
                            teamA: _matches[index]['teamA'],
                            teamB: _matches[index]['teamB'],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
    );
  }
}
