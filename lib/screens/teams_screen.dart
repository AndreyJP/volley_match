import 'package:flutter/material.dart';
import '../services/hive_service.dart';
import '../services/team_generator.dart';
import '../models/team.dart';
import '../models/player.dart';

class TeamsScreen extends StatefulWidget {
  const TeamsScreen({super.key});
  @override
  State<TeamsScreen> createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<TeamsScreen> {
  final _sizeCtrl = TextEditingController(text: '3');

  void _drawTeams() async {
    final size = int.tryParse(_sizeCtrl.text) ?? 3;
    if (size <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('O tamanho do time deve ser maior que zero!'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    final players = HiveService.playersBox.values.toList();
    if (players.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Cadastre jogadores primeiro!'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

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
        backgroundColor: Theme.of(context).primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Future<void> _showManualTeamCreation() async {
    final players = HiveService.playersBox.values.toList();
    if (players.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Cadastre jogadores primeiro!'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    final result = await showDialog<List<Team>>(
      context: context,
      builder: (context) => _ManualTeamDialog(players: players),
    );

    if (result != null && result.isNotEmpty) {
      final box = HiveService.teamsBox;
      await box.clear();
      for (var t in result) {
        await box.add(t);
      }
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Times criados manualmente com sucesso!'),
          duration: const Duration(seconds: 2),
          backgroundColor: Theme.of(context).primaryColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final teams = HiveService.teamsBox.values.toList();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Times'),
        actions: teams.isNotEmpty
            ? [
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Limpar times',
                  onPressed: () async {
                    await HiveService.teamsBox.clear();
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Times limpos'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                ),
              ]
            : null,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Criar Times',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _showManualTeamCreation,
                            icon: const Icon(Icons.edit),
                            label: const Text('Manual'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _drawTeams,
                            icon: const Icon(Icons.shuffle),
                            label: const Text('Sortear'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _sizeCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.people),
                        labelText: 'Jogadores por time (para sorteio)',
                        helperText: 'Defina quantos jogadores por time no sorteio automático',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Lista de times
          Expanded(
            child: teams.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.group_outlined,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhum time criado',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Crie times manualmente ou use o sorteio',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: teams.length,
                    itemBuilder: (_, i) {
                      final Team t = teams[i];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ExpansionTile(
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                            child: Text(
                              '${i + 1}',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            t.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text('${t.players.length} jogador(es)'),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: t.players.map((p) {
                                  return Chip(
                                    avatar: CircleAvatar(
                                      backgroundColor: p.gender == 'M'
                                          ? Colors.blue.withOpacity(0.2)
                                          : Colors.pink.withOpacity(0.2),
                                      radius: 12,
                                      child: Icon(
                                        p.gender == 'M' ? Icons.male : Icons.female,
                                        size: 16,
                                        color: p.gender == 'M' ? Colors.blue[700] : Colors.pink[700],
                                      ),
                                    ),
                                    label: Text(p.name),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _ManualTeamDialog extends StatefulWidget {
  final List<Player> players;

  const _ManualTeamDialog({required this.players});

  @override
  State<_ManualTeamDialog> createState() => _ManualTeamDialogState();
}

class _ManualTeamDialogState extends State<_ManualTeamDialog> {
  int _numberOfTeams = 2;
  final List<List<Player>> _teamPlayers = [];
  final List<TextEditingController> _teamNameControllers = [];

  @override
  void initState() {
    super.initState();
    _numberOfTeams = 2;
    _initializeTeams();
  }

  void _initializeTeams() {
    _teamPlayers.clear();
    _teamNameControllers.clear();
    for (int i = 0; i < _numberOfTeams; i++) {
      _teamPlayers.add([]);
      _teamNameControllers.add(TextEditingController(text: 'Time ${i + 1}'));
    }
  }

  void _updateNumberOfTeams(int count) {
    if (count < 2 || count > 10) return;
    setState(() {
      _numberOfTeams = count;
      final currentTeamsCount = _teamPlayers.length;
      if (count > currentTeamsCount) {
        for (int i = currentTeamsCount; i < count; i++) {
          _teamPlayers.add([]);
          _teamNameControllers.add(TextEditingController(text: 'Time ${i + 1}'));
        }
      } else if (count < currentTeamsCount) {
        _teamPlayers.removeRange(count, currentTeamsCount);
        for (int i = count; i < currentTeamsCount; i++) {
          _teamNameControllers[i].dispose();
        }
        _teamNameControllers.removeRange(count, currentTeamsCount);
      }
    });
  }

  bool _canAddPlayerToTeam(int teamIndex, Player player) {
    return !_teamPlayers[teamIndex].contains(player);
  }

  void _addPlayerToTeam(int teamIndex, Player player) {
    if (_canAddPlayerToTeam(teamIndex, player)) {
      setState(() {
        _teamPlayers[teamIndex].add(player);
      });
    }
  }

  void _removePlayerFromTeam(int teamIndex, Player player) {
    setState(() {
      _teamPlayers[teamIndex].remove(player);
    });
  }

  List<Player> _getAvailablePlayers() {
    final allSelected = _teamPlayers.expand((team) => team).toSet();
    return widget.players.where((p) => !allSelected.contains(p)).toList();
  }

  List<Team> _buildTeams() {
    final teams = <Team>[];
    for (int i = 0; i < _numberOfTeams; i++) {
      final name = _teamNameControllers[i].text.trim().isEmpty
          ? 'Time ${i + 1}'
          : _teamNameControllers[i].text.trim();
      teams.add(Team(name: name, players: List.from(_teamPlayers[i])));
    }
    return teams;
  }

  @override
  void dispose() {
    for (var controller in _teamNameControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        child: Column(
          children: [
            AppBar(
              title: const Text('Definir Times Manualmente'),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Text('Número de times:'),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Slider(
                      value: _numberOfTeams.toDouble(),
                      min: 2,
                      max: 10,
                      divisions: 8,
                      label: '$_numberOfTeams times',
                      onChanged: (value) => _updateNumberOfTeams(value.toInt()),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$_numberOfTeams',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  // Lista de times
                  Expanded(
                    flex: 2,
                    child: ListView.builder(
                      itemCount: _numberOfTeams,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.all(8),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  controller: _teamNameControllers[index],
                                  decoration: InputDecoration(
                                    labelText: 'Nome do Time ${index + 1}',
                                    border: const OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Jogadores (${_teamPlayers[index].length})',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: _teamPlayers[index].map((player) {
                                    return Chip(
                                      label: Text(player.name),
                                      deleteIcon: const Icon(Icons.close, size: 18),
                                      onDeleted: () => _removePlayerFromTeam(index, player),
                                      avatar: Icon(
                                        player.gender == 'M' ? Icons.male : Icons.female,
                                        size: 18,
                                        color: player.gender == 'M' ? Colors.blue : Colors.pink,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Jogadores disponíveis
                  Container(
                    width: 250,
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'Jogadores Disponíveis',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            itemCount: _getAvailablePlayers().length,
                            itemBuilder: (context, index) {
                              final player = _getAvailablePlayers()[index];
                              return ListTile(
                                dense: true,
                                leading: Icon(
                                  player.gender == 'M' ? Icons.male : Icons.female,
                                  color: player.gender == 'M' ? Colors.blue : Colors.pink,
                                  size: 20,
                                ),
                                title: Text(player.name, style: const TextStyle(fontSize: 14)),
                                trailing: PopupMenuButton<int>(
                                  icon: const Icon(Icons.add),
                                  itemBuilder: (context) {
                                    return List.generate(_numberOfTeams, (teamIndex) {
                                      return PopupMenuItem(
                                        value: teamIndex,
                                        enabled: _canAddPlayerToTeam(teamIndex, player),
                                        child: Text(
                                          _teamNameControllers[teamIndex].text.isEmpty
                                              ? 'Time ${teamIndex + 1}'
                                              : _teamNameControllers[teamIndex].text,
                                        ),
                                      );
                                    });
                                  },
                                  onSelected: (teamIndex) {
                                    _addPlayerToTeam(teamIndex, player);
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      final teams = _buildTeams();
                      if (teams.any((t) => t.players.isEmpty)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Todos os times precisam ter pelo menos um jogador!'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      Navigator.of(context).pop(teams);
                    },
                    child: const Text('Confirmar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
