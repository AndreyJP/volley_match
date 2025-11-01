import 'package:flutter/material.dart';
import '../models/match_model.dart';
import '../services/hive_service.dart';
import '../models/player.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});

  Widget _buildPlayerChips(List<Player> players, bool isMale) {
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: players
          .map((p) => Chip(
                label: Text(p.name),
                backgroundColor: isMale ? Colors.blue[50] : Colors.pink[50],
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final matches = HiveService.matchesBox.values.toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const Text(
          'VolleyMatch - Partidas',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 4,
        toolbarHeight: 80,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: matches.length,
          itemBuilder: (_, i) {
            final MatchModel m = matches[i];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(2, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${m.teamA.name} vs ${m.teamB.name}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${m.scoreA} x ${m.scoreB}',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildPlayerChips(m.teamA.players, true),
                  _buildPlayerChips(m.teamB.players, false),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}