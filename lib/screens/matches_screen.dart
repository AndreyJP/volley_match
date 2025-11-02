import 'package:flutter/material.dart';
import '../models/match_model.dart';
import '../services/hive_service.dart';
import '../models/player.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});

  Widget _buildPlayerChips(List<Player> players, bool isMale) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: players
          .map((p) => Chip(
                label: Text(
                  p.name,
                  style: const TextStyle(fontSize: 12),
                ),
                avatar: CircleAvatar(
                  backgroundColor: (isMale ? Colors.blue : Colors.pink)
                      .withOpacity(0.2),
                  radius: 12,
                  child: Icon(
                    p.gender == 'M' ? Icons.male : Icons.female,
                    size: 14,
                    color: isMale ? Colors.blue[700] : Colors.pink[700],
                  ),
                ),
                backgroundColor: (isMale ? Colors.blue : Colors.pink)
                    .withOpacity(0.1),
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final matches = HiveService.matchesBox.values.toList();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Partidas'),
      ),
      body: matches.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhuma partida registrada',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'As partidas salvas aparecerão aqui',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: matches.length,
              itemBuilder: (_, i) {
                final MatchModel m = matches[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${m.teamA.name} vs ${m.teamB.name}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${m.scoreA} x ${m.scoreB}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          m.teamA.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildPlayerChips(m.teamA.players, true),
                        const SizedBox(height: 16),
                        Text(
                          m.teamB.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildPlayerChips(m.teamB.players, false),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}