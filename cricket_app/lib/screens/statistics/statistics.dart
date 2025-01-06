import 'package:cricket_app/backend_config/config.dart';
import 'package:cricket_app/models/add_players.dart';
import 'package:cricket_app/widgets/statistics/edit_statistics.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _StatisticsScreenState();
  }
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  List<AddPlayers> _players = [];

  var _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.parse(getPlayersUrl);
    try {
      final response = await http.get(url);
      // print(response.body);
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to load teams');
      }
      final List<dynamic> extractedData = json.decode(response.body);
      final List<AddPlayers> _loadedItems =
          extractedData.map((item) => AddPlayers.fromJson(item)).toList();

      setState(() {
        _players = _loadedItems;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : _players.isEmpty
            ? const Center(
                child: Text('No players added yet'),
              )
            : ListView.builder(
                itemCount: _players.length,
                itemBuilder: (ctx, index) {
                  return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _players[index].tournamentName,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              '${_players[index].playerName} ',
                            ),
                            Text(
                              _players[index].teamName,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Table(
                          columnWidths: const {
                            0: FixedColumnWidth(10),
                            1: FixedColumnWidth(10),
                            2: FixedColumnWidth(70),
                          },
                          children: [
                            TableRow(
                              children: [
                                Text('Mat',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(
                                  'Run',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('Wic',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            TableRow(
                              children: [
                                Text(_players[index].matchesPlayed.toString()),
                                Text(_players[index].runs.toString()),
                                Text(_players[index].wickets.toString()),
                              ],
                            ),
                          ],
                        ),
                        leading: CircleAvatar(
                          child: _players[index].role == 'Batter'
                              ? Text('BAT')
                              : _players[index].role == 'Bowler'
                                  ? Text('BWL')
                                  : _players[index].role == 'Allrounder'
                                      ? Text('AR')
                                      : _players[index].role == 'Wicketkeeper'
                                          ? Text('WK')
                                          : Text(''),
                        ),
                        trailing: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => EditStatistics(
                                    data: _players[index],
                                  ),
                                ),
                              );
                              _loadItems();
                            }),
                      ));
                },
              );
  }
}
