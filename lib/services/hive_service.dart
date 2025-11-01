
import 'package:hive_flutter/hive_flutter.dart';
import '../models/player.dart';
import '../models/team.dart';
import '../models/match_model.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(PlayerAdapter());
    Hive.registerAdapter(TeamAdapter());
    Hive.registerAdapter(MatchModelAdapter());
    await Hive.openBox<Player>('players');
    await Hive.openBox<Team>('teams');
    await Hive.openBox<MatchModel>('matches');
  }

  static Box<Player> get playersBox => Hive.box<Player>('players');
  static Box<Team> get teamsBox => Hive.box<Team>('teams');
  static Box<MatchModel> get matchesBox => Hive.box<MatchModel>('matches');
}
