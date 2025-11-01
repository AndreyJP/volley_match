import 'package:flutter/material.dart';
import '../services/hive_service.dart';
import '../services/team_generator.dart';
import '../models/team.dart';

class TeamsScreen extends StatefulWidget {
  const TeamsScreen({super.key});
  @override
  State<TeamsScreen> createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<TeamsScreen> {
  final _sizeCtrl = TextEditingController(text: '3');

  void _drawTeams() async {
    final size = int.tryParse(_sizeCtrl.text) ?? 6;
    final players = HiveService.playersBox.values.toList();
    if (players.isEmpty) return;

    final teams = TeamGenerator.generateTeams(players, size);
    final box = HiveService.teamsBox;
    await box.clear();
    for (var t in teams) {
      await box.add(t);
    }
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Times sorteados com sucesso!'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final teams = HiveService.teamsBox.values.toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],

      // Navbar padrão
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const Text(
          'VolleyMatch - Times',
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

      body: Column(
        children: [
          const SizedBox(height: 20),

          // Card de input flutuante
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _sizeCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.people, size: 28),
                        labelText: 'Jogadores por time',
                        labelStyle: TextStyle(fontSize: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _drawTeams,
                      icon: const Icon(Icons.shuffle, size: 28),
                      label: const Text('Sortear Times', style: TextStyle(fontSize: 20)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Lista de times
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView.builder(
                itemCount: teams.length,
                itemBuilder: (_, i) {
                  final Team t = teams[i];
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
                          offset: Offset(2, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: t.players
                              .map((p) => Chip(
                                    label: Text(p.name),
                                    avatar: Icon(
                                      p.gender == 'M' ? Icons.male : Icons.female,
                                      color: p.gender == 'M' ? Colors.blueAccent : Colors.pinkAccent,
                                      size: 20,
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
