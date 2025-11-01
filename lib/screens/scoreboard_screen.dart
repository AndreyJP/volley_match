import 'package:flutter/material.dart';
import '../models/team.dart';
import '../models/player.dart';
import '../services/hive_service.dart';
import '../models/match_model.dart';

class ScoreboardScreen extends StatefulWidget {
  const ScoreboardScreen({super.key});

  @override
  State<ScoreboardScreen> createState() => _ScoreboardScreenState();
}

class _ScoreboardScreenState extends State<ScoreboardScreen> {
  int _scoreA = 0;
  int _scoreB = 0;
  Team? _teamA;
  Team? _teamB;

  void _saveMatch() async {
    if (_teamA == null || _teamB == null) return;

    final match = MatchModel(
      teamA: _teamA!,
      teamB: _teamB!,
      scoreA: _scoreA,
      scoreB: _scoreB,
    );

    await HiveService.matchesBox.add(match);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Partida ${_teamA!.name} vs ${_teamB!.name} salva!'),
        backgroundColor: Colors.green,
      ),
    );

    setState(() {
      _scoreA = 0;
      _scoreB = 0;
      _teamA = null;
      _teamB = null;
    });
  }

  Widget _buildPlayerChips(List<Player> players, bool isMale) {
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: players
          .map((p) => Chip(
                label: Text(p.name, style: const TextStyle(fontSize: 14)),
                backgroundColor: isMale ? Colors.blue[50] : Colors.pink[50],
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final teams = HiveService.teamsBox.values.toList();
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmall = screenHeight < 700;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const Text(
          'VolleyMatch - Placar',
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Seleção dos times
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<Team>(
                            value: _teamA,
                            decoration: const InputDecoration(
                              labelText: 'Time A',
                              border: OutlineInputBorder(),
                            ),
                            items: teams
                                .map((t) =>
                                    DropdownMenuItem(value: t, child: Text(t.name)))
                                .toList(),
                            onChanged: (v) => setState(() => _teamA = v),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<Team>(
                            value: _teamB,
                            decoration: const InputDecoration(
                              labelText: 'Time B',
                              border: OutlineInputBorder(),
                            ),
                            items: teams
                                .map((t) =>
                                    DropdownMenuItem(value: t, child: Text(t.name)))
                                .toList(),
                            onChanged: (v) => setState(() => _teamB = v),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    if (_teamA != null && _teamB != null)
                      Column(
                        children: [
                          const SizedBox(height: 8),

                          // Time A
                          Text(
                            _teamA!.name,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          _buildPlayerChips(_teamA!.players, true),
                          Text(
                            '$_scoreA',
                            style: TextStyle(
                              fontSize: isSmall ? 60 : 80,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                iconSize: 40,
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () =>
                                    setState(() => _scoreA = (_scoreA - 1).clamp(0, 999)),
                              ),
                              const SizedBox(width: 12),
                              IconButton(
                                iconSize: 40,
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () =>
                                    setState(() => _scoreA = (_scoreA + 1).clamp(0, 999)),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),
                          const Text(
                            'X',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),

                          // Time B
                          Text(
                            _teamB!.name,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.pinkAccent,
                            ),
                          ),
                          _buildPlayerChips(_teamB!.players, false),
                          Text(
                            '$_scoreB',
                            style: TextStyle(
                              fontSize: isSmall ? 60 : 80,
                              fontWeight: FontWeight.bold,
                              color: Colors.pinkAccent,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                iconSize: 40,
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () =>
                                    setState(() => _scoreB = (_scoreB - 1).clamp(0, 999)),
                              ),
                              const SizedBox(width: 12),
                              IconButton(
                                iconSize: 40,
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () =>
                                    setState(() => _scoreB = (_scoreB + 1).clamp(0, 999)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Botão salvar
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _saveMatch,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 24),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text(
                                'Salvar Partida',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}