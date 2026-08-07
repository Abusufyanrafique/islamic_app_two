// ─────────────────────────────────────────────────────────────────────────────
// MODELS
// ─────────────────────────────────────────────────────────────────────────────

class SalatTime {
  int? code; String? status; SalatData? data;
  SalatTime({this.code, this.status, this.data});
  SalatTime.fromJson(Map<String, dynamic> json) {
    code = json['code']; status = json['status'];
    data = json['data'] != null ? SalatData.fromJson(json['data']) : null;
  }
  Map<String, dynamic> toJson() => {'code': code, 'status': status, if (data != null) 'data': data!.toJson()};
}

class SalatData {
  Timings? timings; PrayerDate? date; Meta? meta;
  SalatData({this.timings, this.date, this.meta});
  SalatData.fromJson(Map<String, dynamic> json) {
    timings = json['timings'] != null ? Timings.fromJson(json['timings']) : null;
    date    = json['date'] != null ? PrayerDate.fromJson(json['date']) : null;
    meta    = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }
  Map<String, dynamic> toJson() => {
    if (timings != null) 'timings': timings!.toJson(),
    if (date != null) 'date': date!.toJson(),
    if (meta != null) 'meta': meta!.toJson(),
  };
}

class Timings {
  String? fajr, sunrise, dhuhr, asr, sunset, maghrib, isha, imsak, midnight, firstthird, lastthird;
  Timings({this.fajr, this.sunrise, this.dhuhr, this.asr, this.sunset, this.maghrib, this.isha, this.imsak, this.midnight, this.firstthird, this.lastthird});
  Timings.fromJson(Map<String, dynamic> json) {
    fajr = json['Fajr']; sunrise = json['Sunrise']; dhuhr = json['Dhuhr']; asr = json['Asr'];
    sunset = json['Sunset']; maghrib = json['Maghrib']; isha = json['Isha']; imsak = json['Imsak'];
    midnight = json['Midnight']; firstthird = json['Firstthird']; lastthird = json['Lastthird'];
  }
  Map<String, dynamic> toJson() => {
    'Fajr': fajr, 'Sunrise': sunrise, 'Dhuhr': dhuhr, 'Asr': asr, 'Sunset': sunset,
    'Maghrib': maghrib, 'Isha': isha, 'Imsak': imsak, 'Midnight': midnight,
    'Firstthird': firstthird, 'Lastthird': lastthird,
  };
}

class PrayerWeekday {
  String? en, ar;
  PrayerWeekday({this.en, this.ar});
  PrayerWeekday.fromJson(Map<String, dynamic> json) { en = json['en']; ar = json['ar']; }
  Map<String, dynamic> toJson() => {'en': en, if (ar != null) 'ar': ar};
}

class PrayerMonth {
  int? number, days; String? en, ar;
  PrayerMonth({this.number, this.en, this.ar, this.days});
  PrayerMonth.fromJson(Map<String, dynamic> json) {
    number = json['number']; en = json['en']; ar = json['ar']; days = json['days'];
  }
  Map<String, dynamic> toJson() => {'number': number, 'en': en, if (ar != null) 'ar': ar, if (days != null) 'days': days};
}

class Designation {
  String? abbreviated, expanded;
  Designation({this.abbreviated, this.expanded});
  Designation.fromJson(Map<String, dynamic> json) { abbreviated = json['abbreviated']; expanded = json['expanded']; }
  Map<String, dynamic> toJson() => {'abbreviated': abbreviated, 'expanded': expanded};
}

class PrayerDate {
  String? readable, timestamp; Hijri? hijri; Gregorian? gregorian;
  PrayerDate({this.readable, this.timestamp, this.hijri, this.gregorian});
  PrayerDate.fromJson(Map<String, dynamic> json) {
    readable = json['readable']; timestamp = json['timestamp'];
    hijri = json['hijri'] != null ? Hijri.fromJson(json['hijri']) : null;
    gregorian = json['gregorian'] != null ? Gregorian.fromJson(json['gregorian']) : null;
  }
  Map<String, dynamic> toJson() => {
    'readable': readable, 'timestamp': timestamp,
    if (hijri != null) 'hijri': hijri!.toJson(),
    if (gregorian != null) 'gregorian': gregorian!.toJson(),
  };
}

class Hijri {
  String? date, format, day, year, method;
  PrayerWeekday? weekday; PrayerMonth? month; Designation? designation; List<String>? holidays;
  Hijri({this.date, this.format, this.day, this.weekday, this.month, this.year, this.designation, this.holidays, this.method});
  Hijri.fromJson(Map<String, dynamic> json) {
    date = json['date']; format = json['format']; day = json['day'];
    weekday = json['weekday'] != null ? PrayerWeekday.fromJson(json['weekday']) : null;
    month = json['month'] != null ? PrayerMonth.fromJson(json['month']) : null;
    year = json['year'];
    designation = json['designation'] != null ? Designation.fromJson(json['designation']) : null;
    final raw = json['holidays'];
    if (raw != null && raw is List) holidays = raw.map((e) => e.toString()).toList();
    method = json['method'];
  }
  Map<String, dynamic> toJson() => {
    'date': date, 'format': format, 'day': day,
    if (weekday != null) 'weekday': weekday!.toJson(),
    if (month != null) 'month': month!.toJson(),
    'year': year, if (designation != null) 'designation': designation!.toJson(),
    'holidays': holidays, 'method': method,
  };
}

class Gregorian {
  String? date, format, day, year;
  PrayerWeekday? weekday; PrayerMonth? month; Designation? designation; bool? lunarSighting;
  String? get readable => (day != null && month?.en != null && year != null) ? '${month!.en} $day, $year' : date;
  Gregorian({this.date, this.format, this.day, this.weekday, this.month, this.year, this.designation, this.lunarSighting});
  Gregorian.fromJson(Map<String, dynamic> json) {
    date = json['date']; format = json['format']; day = json['day'];
    weekday = json['weekday'] != null ? PrayerWeekday.fromJson(json['weekday']) : null;
    month = json['month'] != null ? PrayerMonth.fromJson(json['month']) : null;
    year = json['year'];
    designation = json['designation'] != null ? Designation.fromJson(json['designation']) : null;
    lunarSighting = json['lunarSighting'];
  }
  Map<String, dynamic> toJson() => {
    'date': date, 'format': format, 'day': day,
    if (weekday != null) 'weekday': weekday!.toJson(),
    if (month != null) 'month': month!.toJson(),
    'year': year, if (designation != null) 'designation': designation!.toJson(),
    'lunarSighting': lunarSighting,
  };
}

class Meta {
  double? latitude, longitude;
  String? timezone, latitudeAdjustmentMethod, midnightMode, school;
  CalcMethod? method; PrayerOffset? offset;
  Meta({this.latitude, this.longitude, this.timezone, this.method, this.latitudeAdjustmentMethod, this.midnightMode, this.school, this.offset});
  Meta.fromJson(Map<String, dynamic> json) {
    latitude = (json['latitude'] as num?)?.toDouble();
    longitude = (json['longitude'] as num?)?.toDouble();
    timezone = json['timezone'];
    method = json['method'] != null ? CalcMethod.fromJson(json['method']) : null;
    latitudeAdjustmentMethod = json['latitudeAdjustmentMethod'];
    midnightMode = json['midnightMode']; school = json['school'];
    offset = json['offset'] != null ? PrayerOffset.fromJson(json['offset']) : null;
  }
  Map<String, dynamic> toJson() => {
    'latitude': latitude, 'longitude': longitude, 'timezone': timezone,
    if (method != null) 'method': method!.toJson(),
    'latitudeAdjustmentMethod': latitudeAdjustmentMethod,
    'midnightMode': midnightMode, 'school': school,
    if (offset != null) 'offset': offset!.toJson(),
  };
}

class CalcMethod {
  int? id; String? name; MethodParams? params; MethodLocation? location;
  CalcMethod({this.id, this.name, this.params, this.location});
  CalcMethod.fromJson(Map<String, dynamic> json) {
    id = json['id']; name = json['name'];
    params = json['params'] != null ? MethodParams.fromJson(json['params']) : null;
    location = json['location'] != null ? MethodLocation.fromJson(json['location']) : null;
  }
  Map<String, dynamic> toJson() => {'id': id, 'name': name, if (params != null) 'params': params!.toJson(), if (location != null) 'location': location!.toJson()};
}

class MethodParams {
  int? fajr, isha;
  MethodParams({this.fajr, this.isha});
  MethodParams.fromJson(Map<String, dynamic> json) { fajr = json['Fajr']; isha = json['Isha']; }
  Map<String, dynamic> toJson() => {'Fajr': fajr, 'Isha': isha};
}

class MethodLocation {
  double? latitude, longitude;
  MethodLocation({this.latitude, this.longitude});
  MethodLocation.fromJson(Map<String, dynamic> json) {
    latitude = (json['latitude'] as num?)?.toDouble();
    longitude = (json['longitude'] as num?)?.toDouble();
  }
  Map<String, dynamic> toJson() => {'latitude': latitude, 'longitude': longitude};
}

class PrayerOffset {
  int? imsak, fajr, sunrise, dhuhr, asr, maghrib, sunset, isha, midnight;
  PrayerOffset({this.imsak, this.fajr, this.sunrise, this.dhuhr, this.asr, this.maghrib, this.sunset, this.isha, this.midnight});
  PrayerOffset.fromJson(Map<String, dynamic> json) {
    imsak = json['Imsak']; fajr = json['Fajr']; sunrise = json['Sunrise']; dhuhr = json['Dhuhr'];
    asr = json['Asr']; maghrib = json['Maghrib']; sunset = json['Sunset']; isha = json['Isha']; midnight = json['Midnight'];
  }
  Map<String, dynamic> toJson() => {
    'Imsak': imsak, 'Fajr': fajr, 'Sunrise': sunrise, 'Dhuhr': dhuhr, 'Asr': asr,
    'Maghrib': maghrib, 'Sunset': sunset, 'Isha': isha, 'Midnight': midnight,
  };
}