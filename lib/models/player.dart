
import 'package:hive/hive.dart';
part 'player.g.dart';

@HiveType(typeId: 0)
class Player extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String gender;

  Player({required this.name, required this.gender});
}
