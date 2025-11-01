
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team.dart';

class TeamAdapter extends TypeAdapter<Team> {
  @override
  final int typeId = 1;

  @override
  Team read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      final key = reader.readByte();
      final value = reader.read();
      fields[key] = value;
    }
    return Team(
      name: fields[0] as String,
      players: (fields[1] as List).cast<Player>(),
    );
  }

  @override
  void write(BinaryWriter writer, Team obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.players);
  }
}
