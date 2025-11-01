
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:volley_match/screens/scoreboard_screen.dart';
import 'models/player.dart';
import 'models/team.dart';
import 'models/match_model.dart';
import 'screens/home_screen.dart';
import 'screens/players_screen.dart';
import 'screens/teams_screen.dart';
import 'screens/matches_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(PlayerAdapter());
  Hive.registerAdapter(TeamAdapter());
  Hive.registerAdapter(MatchModelAdapter());
  await Hive.openBox<Player>('players');
  await Hive.openBox<Team>('teams');
  await Hive.openBox<MatchModel>('matches');

  runApp(const VolleyMatchApp());
}

class VolleyMatchApp extends StatelessWidget {
  const VolleyMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VolleyMatch',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'NotoSans'
      ),
      home: const HomeScreen(),
      routes: {
        '/players': (_) => const PlayersScreen(),
        '/teams': (_) => const TeamsScreen(),
        '/matches': (_) => const MatchesScreen(),
        '/scoreboard': (_) => const ScoreboardScreen()
      },
    );
  }
}
