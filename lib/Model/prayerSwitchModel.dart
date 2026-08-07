import 'package:hive/hive.dart';


part 'prayerSwitchModel.g.dart';
@HiveType(typeId: 1)
class PrayerSwitchState extends HiveObject {
  @HiveField(0)
  bool fajr;

  @HiveField(1)
  bool dhuhr;

  @HiveField(2)
  bool asr;

  @HiveField(3)
  bool maghrib;

  @HiveField(4)
  bool isha;

  PrayerSwitchState({
    this.fajr = false,
    this.dhuhr = false,
    this.asr = false,
    this.maghrib = false,
    this.isha = false,
  });
}