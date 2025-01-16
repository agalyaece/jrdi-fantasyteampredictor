import 'package:cricket_app/widgets/admin/match.dart';
import 'package:cricket_app/widgets/admin/players.dart';
import 'package:cricket_app/widgets/admin/teams.dart';
import 'package:cricket_app/widgets/admin/tournament.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(40),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (ctx) => const Tournament()),
                );
              },
              child: const Text("+ Add Tournament"),
              // style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (ctx) => const Teams()));
              },
              child: const Text("+ Add Teams"),
              // style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (ctx) => const Players()));
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              ),
              child: const Text("+ Add Players"),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (ctx) => const Match()));
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              ),
              child: const Text("+ Matches"),
            ),
          ],
        ),
      ),
    );
  }
}
