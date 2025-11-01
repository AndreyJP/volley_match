
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_model.dart';

class MatchModelAdapter extends TypeAdapter<MatchModel> {
  @override
  final int typeId = 2;

  @override
  MatchModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      final key = reader.readByte();
      final value = reader.read();
      fields[key] = value;
    }
    return MatchModel(
      teamA: fields[0] as Team,
      teamB: fields[1] as Team,
      scoreA: fields[2] as int,
      scoreB: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, MatchModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.teamA)
      ..writeByte(1)
      ..write(obj.teamB)
      ..writeByte(2)
      ..write(obj.scoreA)
      ..writeByte(3)
      ..write(obj.scoreB);
  }
}
