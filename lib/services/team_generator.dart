import '../models/player.dart';
import '../models/team.dart';
import 'dart:math';

class TeamGenerator {
  static List<Team> generateTeams(List<Player> players, int teamSize) {
    if (players.isEmpty || teamSize <= 0) return [];

    // Separar jogadores por gênero
    final males = players.where((p) => p.gender == 'M').toList()..shuffle(Random());
    final females = players.where((p) => p.gender == 'F').toList()..shuffle(Random());

    final List<Team> teams = [];
    int teamCount = (players.length / teamSize).ceil();

    // Inicializa os times vazios
    for (int i = 0; i < teamCount; i++) {
      teams.add(Team(name: 'Time ${i + 1}', players: []));
    }

    // Distribui mulheres primeiro
    int fIndex = 0;
    while (fIndex < females.length) {
      for (var team in teams) {
        if (fIndex >= females.length) break;
        if (team.players.length < teamSize) {
          team.players.add(females[fIndex]);
          fIndex++;
        }
      }
    }

    // Distribui homens
    int mIndex = 0;
    while (mIndex < males.length) {
      for (var team in teams) {
        if (mIndex >= males.length) break;
        if (team.players.length < teamSize) {
          team.players.add(males[mIndex]);
          mIndex++;
        }
      }
    }

    return teams;
  }
}
