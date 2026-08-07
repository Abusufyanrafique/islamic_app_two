class QuranResponseModel {
  int? code;
  String? status;
  QuranDataModel? data;

  QuranResponseModel({this.code, this.status, this.data});

  QuranResponseModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    data = json['data'] != null
        ? QuranDataModel.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['code'] = code;
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
class QuranDataModel {
  int? number;
  List<AyahModel>? ayahs;
  SurahMapModel? surahs;
  EditionModel? edition;

  QuranDataModel({this.number, this.ayahs, this.surahs, this.edition});
  QuranDataModel.fromJson(Map<String, dynamic> json) {
    number = json['number'];

    // ✅ Direct ayahs list
    if (json['ayahs'] != null) {
      ayahs = <AyahModel>[];
      json['ayahs'].forEach((v) {
        ayahs!.add(AyahModel.fromJson(v));
      });
    }

    // ✅ Agar ayahs null ho aur data nested ho
    if ((ayahs == null || ayahs!.isEmpty) && json['data'] != null) {
      final innerData = json['data'];
      if (innerData['ayahs'] != null) {
        ayahs = <AyahModel>[];
        innerData['ayahs'].forEach((v) {
          ayahs!.add(AyahModel.fromJson(v));
        });
      }
    }

    surahs = json['surahs'] != null
        ? SurahMapModel.fromJson(json['surahs'])
        : null;

    edition = json['edition'] != null
        ? EditionModel.fromJson(json['edition'])
        : null;
  }

  // QuranDataModel.fromJson(Map<String, dynamic> json) {
  //   number = json['number'];
  //
  //   if (json['ayahs'] != null) {
  //     ayahs = <AyahModel>[];
  //     json['ayahs'].forEach((v) {
  //       ayahs!.add(AyahModel.fromJson(v));
  //     });
  //   }
  //
  //   surahs = json['surahs'] != null
  //       ? SurahMapModel.fromJson(json['surahs'])
  //       : null;
  //
  //   edition = json['edition'] != null
  //       ? EditionModel.fromJson(json['edition'])
  //       : null;
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['number'] = number;

    if (ayahs != null) {
      data['ayahs'] = ayahs!.map((v) => v.toJson()).toList();
    }

    if (surahs != null) {
      data['surahs'] = surahs!.toJson();
    }

    if (edition != null) {
      data['edition'] = edition!.toJson();
    }

    return data;
  }
}
class AyahModel {
  int? number;
  String? audio;
  List<String>? audioSecondary;
  String? text;
  Surahmodelsss? surah;
  int? numberInSurah;
  int? juz;
  int? manzil;
  int? page;
  int? ruku;
  int? hizbQuarter;
  bool? sajda;

  AyahModel({
    this.number,
    this.audio,
    this.audioSecondary,
    this.text,
    this.surah,
    this.numberInSurah,
    this.juz,
    this.manzil,
    this.page,
    this.ruku,
    this.hizbQuarter,
    this.sajda,
  });
  AyahModel.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    audio = json['audio'];
    audioSecondary = json['audioSecondary']?.cast<String>();
    text = json['text'];
    surah = json['surah'] != null ? Surahmodelsss.fromJson(json['surah']) : null;
    numberInSurah = json['numberInSurah'];
    juz = json['juz'];
    manzil = json['manzil'];
    page = json['page'];
    ruku = json['ruku'];
    hizbQuarter = json['hizbQuarter'];

    // ✅ sajda bool bhi ho sakta hai, object bhi — dono handle karo
    final sajdaVal = json['sajda'];
    if (sajdaVal is bool) {
      sajda = sajdaVal;
    } else if (sajdaVal is Map) {
      sajda = true; // object hai matlab sajda hai
    } else {
      sajda = false;
    }
  }
  // AyahModel.fromJson(Map<String, dynamic> json) {
  //   number = json['number'];
  //   audio = json['audio'];
  //   audioSecondary = json['audioSecondary']?.cast<String>();
  //   text = json['text'];
  //
  //   surah = json['surah'] != null
  //       ? Surahmodelsss.fromJson(json['surah'])
  //       : null;
  //
  //   numberInSurah = json['numberInSurah'];
  //   juz = json['juz'];
  //   manzil = json['manzil'];
  //   page = json['page'];
  //   ruku = json['ruku'];
  //   hizbQuarter = json['hizbQuarter'];
  //   sajda = json['sajda'];
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['number'] = number;
    data['audio'] = audio;
    data['audioSecondary'] = audioSecondary;
    data['text'] = text;

    if (surah != null) {
      data['surah'] = surah!.toJson();
    }

    data['numberInSurah'] = numberInSurah;
    data['juz'] = juz;
    data['manzil'] = manzil;
    data['page'] = page;
    data['ruku'] = ruku;
    data['hizbQuarter'] = hizbQuarter;
    data['sajda'] = sajda;

    return data;
  }
}
class Surahmodelsss {
  int? number;
  String? name;
  String? englishName;
  String? englishNameTranslation;
  String? revelationType;
  int? numberOfAyahs;

  Surahmodelsss({
    this.number,
    this.name,
    this.englishName,
    this.englishNameTranslation,
    this.revelationType,
    this.numberOfAyahs,
  });

  Surahmodelsss.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    name = json['name'];
    englishName = json['englishName'];
    englishNameTranslation = json['englishNameTranslation'];
    revelationType = json['revelationType'];
    numberOfAyahs = json['numberOfAyahs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['number'] = number;
    data['name'] = name;
    data['englishName'] = englishName;
    data['englishNameTranslation'] = englishNameTranslation;
    data['revelationType'] = revelationType;
    data['numberOfAyahs'] = numberOfAyahs;
    return data;
  }
}
class SurahMapModel {
  Surahmodelsss? s1;
  Surahmodelsss? s2;

  SurahMapModel({this.s1, this.s2});

  SurahMapModel.fromJson(Map<String, dynamic> json) {
    s1 = json['1'] != null
        ? Surahmodelsss.fromJson(json['1'])
        : null;

    s2 = json['2'] != null
        ? Surahmodelsss.fromJson(json['2'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (s1 != null) data['1'] = s1!.toJson();
    if (s2 != null) data['2'] = s2!.toJson();

    return data;
  }
}
class EditionModel {
  String? identifier;
  String? language;
  String? name;
  String? englishName;
  String? format;
  String? type;
  dynamic direction;

  EditionModel({
    this.identifier,
    this.language,
    this.name,
    this.englishName,
    this.format,
    this.type,
    this.direction,
  });

  EditionModel.fromJson(Map<String, dynamic> json) {
    identifier = json['identifier'];
    language = json['language'];
    name = json['name'];
    englishName = json['englishName'];
    format = json['format'];
    type = json['type'];
    direction = json['direction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['identifier'] = identifier;
    data['language'] = language;
    data['name'] = name;
    data['englishName'] = englishName;
    data['format'] = format;
    data['type'] = type;
    data['direction'] = direction;
    return data;
  }
}
class JuzModel {
  final int number;
  final String name;
  final String subname;

  JuzModel({required this.number, required this.name,required this.subname});
}