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
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
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
      runSpacing: 6,
      children: players
          .map((p) => Chip(
                label: Text(
                  p.name,
                  style: const TextStyle(fontSize: 11),
                ),
                avatar: CircleAvatar(
                  backgroundColor: (isMale ? Colors.blue : Colors.pink)
                      .withOpacity(0.2),
                  radius: 10,
                  child: Icon(
                    p.gender == 'M' ? Icons.male : Icons.female,
                    size: 12,
                    color: isMale ? Colors.blue[700] : Colors.pink[700],
                  ),
                ),
                backgroundColor: (isMale ? Colors.blue : Colors.pink)
                    .withOpacity(0.1),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.zero,
                labelPadding: const EdgeInsets.symmetric(horizontal: 6),
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final teams = HiveService.teamsBox.values.toList();
    final screenSize = MediaQuery.of(context).size;
    final isSmall = screenSize.height < 700;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Placar'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Seleção dos times (compacto)
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<Team>(
                        value: _teamA,
                        decoration: InputDecoration(
                          labelText: 'Time A',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        items: teams
                            .map((t) => DropdownMenuItem(
                                  value: t,
                                  child: Text(
                                    t.name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                        onChanged: (v) => setState(() => _teamA = v),
                        isExpanded: true,
                        isDense: true,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<Team>(
                        value: _teamB,
                        decoration: InputDecoration(
                          labelText: 'Time B',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        items: teams
                            .map((t) => DropdownMenuItem(
                                  value: t,
                                  child: Text(
                                    t.name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                        onChanged: (v) => setState(() => _teamB = v),
                        isExpanded: true,
                        isDense: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Placar dos times lado a lado
                if (_teamA != null && _teamB != null) ...[
                  Expanded(
                    child: Row(
                      children: [
                        // Time A
                        Expanded(
                          child: _buildTeamScoreCard(
                            team: _teamA!,
                            score: _scoreA,
                            color: Colors.blue,
                            isSmall: isSmall,
                            onDecrement: () => setState(
                              () => _scoreA = (_scoreA - 1).clamp(0, 999),
                            ),
                            onIncrement: () => setState(
                              () => _scoreA = (_scoreA + 1).clamp(0, 999),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Time B
                        Expanded(
                          child: _buildTeamScoreCard(
                            team: _teamB!,
                            score: _scoreB,
                            color: Colors.pink,
                            isSmall: isSmall,
                            onDecrement: () => setState(
                              () => _scoreB = (_scoreB - 1).clamp(0, 999),
                            ),
                            onIncrement: () => setState(
                              () => _scoreB = (_scoreB + 1).clamp(0, 999),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Botão salvar
                  ElevatedButton.icon(
                    onPressed: _saveMatch,
                    icon: const Icon(Icons.save),
                    label: const Text('Salvar Partida'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                ]
                else
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.sports_volleyball,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Selecione dois times para começar',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTeamScoreCard({
    required Team team,
    required int score,
    required Color color,
    required bool isSmall,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    final isBlue = color == Colors.blue;
    
    // Definir cores baseadas no tipo
    final primaryColor = isBlue ? Colors.blue[700]! : Colors.pink[700]!;
    final lightColor = isBlue ? Colors.blue[50]! : Colors.pink[50]!;
    final borderColor = isBlue ? Colors.blue[300]! : Colors.pink[300]!;
    
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              color.withOpacity(0.15),
              color.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Nome do time
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  team.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              
              // Jogadores
              const SizedBox(height: 10),
              SizedBox(
                height: 36,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: _buildPlayerChips(team.players, isBlue),
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Placar
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  '$score',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isSmall ? 56 : 64,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    height: 1.0,
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Botões de controle
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onDecrement,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: lightColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: borderColor,
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          Icons.remove,
                          size: 24,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onIncrement,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 24,
                          color: Colors.white,
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
  }
}