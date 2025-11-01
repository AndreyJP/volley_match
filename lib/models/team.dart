
import 'package:hive/hive.dart';
import 'player.dart';
part 'team.g.dart';

@HiveType(typeId: 1)
class Team extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<Player> players;

  Team({required this.name, required this.players});
}
