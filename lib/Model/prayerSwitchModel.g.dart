// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayerSwitchModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PrayerSwitchStateAdapter extends TypeAdapter<PrayerSwitchState> {
  @override
  final int typeId = 1;

  @override
  PrayerSwitchState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PrayerSwitchState(
      fajr: fields[0] as bool,
      dhuhr: fields[1] as bool,
      asr: fields[2] as bool,
      maghrib: fields[3] as bool,
      isha: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, PrayerSwitchState obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.fajr)
      ..writeByte(1)
      ..write(obj.dhuhr)
      ..writeByte(2)
      ..write(obj.asr)
      ..writeByte(3)
      ..write(obj.maghrib)
      ..writeByte(4)
      ..write(obj.isha);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrayerSwitchStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
