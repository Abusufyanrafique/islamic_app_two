// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PrayerCacheModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PrayerCacheAdapter extends TypeAdapter<PrayerCache> {
  @override
  final int typeId = 0;

  @override
  PrayerCache read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PrayerCache(
      fajr: fields[0] as String,
      dhuhr: fields[1] as String,
      asr: fields[2] as String,
      maghrib: fields[3] as String,
      isha: fields[4] as String,
      locationName: fields[5] as String,
      isFromGPS: fields[6] as bool,
      hijriDay: fields[7] as String,
      hijriMonth: fields[8] as String,
      hijriYear: fields[9] as String,
      hijriDesignation: fields[10] as String,
      gregorianReadable: fields[11] as String,
      hijriWeekday: fields[12] as String,
      timezone: fields[13] as String,
      savedDate: fields[14] as String,
      latitude: fields[15] == null ? 0.0 : fields[15] as double,   // ← add
      longitude: fields[16] == null ? 0.0 : fields[16] as double,  // ← add

    );
  }

  @override
  void write(BinaryWriter writer, PrayerCache obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.fajr)
      ..writeByte(1)
      ..write(obj.dhuhr)
      ..writeByte(2)
      ..write(obj.asr)
      ..writeByte(3)
      ..write(obj.maghrib)
      ..writeByte(4)
      ..write(obj.isha)
      ..writeByte(5)
      ..write(obj.locationName)
      ..writeByte(6)
      ..write(obj.isFromGPS)
      ..writeByte(7)
      ..write(obj.hijriDay)
      ..writeByte(8)
      ..write(obj.hijriMonth)
      ..writeByte(9)
      ..write(obj.hijriYear)
      ..writeByte(10)
      ..write(obj.hijriDesignation)
      ..writeByte(11)
      ..write(obj.gregorianReadable)
      ..writeByte(12)
      ..write(obj.hijriWeekday)
      ..writeByte(13)
      ..write(obj.timezone)
      ..writeByte(14)
      ..write(obj.savedDate)
      ..writeByte(15)        // ← add
      ..write(obj.latitude)  // ← add
      ..writeByte(16)        // ← add
      ..write(obj.longitude); // ← add
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrayerCacheAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
