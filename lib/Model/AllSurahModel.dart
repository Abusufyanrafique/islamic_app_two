
class SurahModel {
  int? code;
  String? status;
  List<Data>? data;

  SurahModel({this.code, this.status, this.data});

  SurahModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? number;
  String? name;
  String? englishName;
  String? englishNameTranslation;
  int? numberOfAyahs;
  String? revelationType;

  Data(
      {this.number,
        this.name,
        this.englishName,
        this.englishNameTranslation,
        this.numberOfAyahs,
        this.revelationType});

  Data.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    name = json['name'];
    englishName = json['englishName'];
    englishNameTranslation = json['englishNameTranslation'];
    numberOfAyahs = json['numberOfAyahs'];
    revelationType = json['revelationType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['number'] = this.number;
    data['name'] = this.name;
    data['englishName'] = this.englishName;
    data['englishNameTranslation'] = this.englishNameTranslation;
    data['numberOfAyahs'] = this.numberOfAyahs;
    data['revelationType'] = this.revelationType;
    return data;
  }
}
class SurahDetailModel {
  int? code;
  String? status;
  SurahDetailData? data;

  SurahDetailModel({this.code, this.status, this.data});

  SurahDetailModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    data = json['data'] != null ? SurahDetailData.fromJson(json['data']) : null;
  }
}

class SurahDetailData {
  int? number;
  String? name;
  String? englishName;
  String? englishNameTranslation;
  String? revelationType;
  List<Ayah>? ayahs;

  SurahDetailData.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    name = json['name'];
    englishName = json['englishName'];
    englishNameTranslation = json['englishNameTranslation'];
    revelationType = json['revelationType'];
    if (json['ayahs'] != null) {
      ayahs = <Ayah>[];
      json['ayahs'].forEach((v) => ayahs!.add(Ayah.fromJson(v)));
    }
  }
}

class Ayah {
  int? number;
  String? text;
  int? numberInSurah;
  int? juz;
  int? page;

  Ayah.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    text = json['text'];
    numberInSurah = json['numberInSurah'];
    juz = json['juz'];
    page = json['page'];
  }
}





