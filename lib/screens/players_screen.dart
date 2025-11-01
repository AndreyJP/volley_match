import 'package:flutter/material.dart';
import '../models/player.dart';
import '../services/hive_service.dart';

class PlayersScreen extends StatefulWidget {
  const PlayersScreen({super.key});

  @override
  State<PlayersScreen> createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  final _nameController = TextEditingController();
  String _gender = 'M';

  void _addPlayer() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    final player = Player(name: name, gender: _gender);
    await HiveService.playersBox.add(player);
    _nameController.clear();
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${player.name}" adicionado(a)!'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  void _deletePlayer(int index) async {
    final removed = HiveService.playersBox.getAt(index);
    await HiveService.playersBox.deleteAt(index);
    setState(() {});
    if (removed != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"${removed.name}" removido(a)'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final players = HiveService.playersBox.values.toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const Text(
          'VolleyMatch - Jogadores',
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

          // Card de input com botão abaixo
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
                      controller: _nameController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person, size: 28),
                        labelText: 'Nome do jogador',
                        labelStyle: TextStyle(fontSize: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text('Sexo:', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 12),
                        DropdownButton<String>(
                          value: _gender,
                          items: const [
                            DropdownMenuItem(
                              value: 'M',
                              child: Text('Masculino', style: TextStyle(fontSize: 20)),
                            ),
                            DropdownMenuItem(
                              value: 'F',
                              child: Text('Feminino', style: TextStyle(fontSize: 20)),
                            ),
                          ],
                          onChanged: (v) => setState(() => _gender = v!),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _addPlayer,
                      icon: const Icon(Icons.add, size: 28),
                      label: const Text('Adicionar', style: TextStyle(fontSize: 20)),
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

          // Lista de jogadores
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView.builder(
                itemCount: players.length,
                itemBuilder: (_, i) {
                  final p = players[i];
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  p.gender == 'M' ? Icons.male : Icons.female,
                                  color:
                                      p.gender == 'M' ? Colors.blueAccent : Colors.pinkAccent,
                                  size: 32,
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      p.name,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      p.gender == 'M' ? 'Masculino' : 'Feminino',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deletePlayer(i),
                            ),
                          ],
                        ),
                      ),
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
