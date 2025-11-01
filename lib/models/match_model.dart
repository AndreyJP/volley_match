
import 'package:hive/hive.dart';
import 'team.dart';
part 'match_model.g.dart';

@HiveType(typeId: 2)
class MatchModel extends HiveObject {
  @HiveField(0)
  Team teamA;

  @HiveField(1)
  Team teamB;

  @HiveField(2)
  int scoreA;

  @HiveField(3)
  int scoreB;

  MatchModel({
    required this.teamA,
    required this.teamB,
    this.scoreA = 0,
    this.scoreB = 0,
  });
}
