class AllahNameModel {
  int? code;
  String? status;
  List<Data>? data;

  AllahNameModel({this.code, this.status, this.data});

  AllahNameModel.fromJson(Map<String, dynamic> json) {
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
  String? name;
  String? transliteration;
  int? number;
  En? en;

  Data({this.name, this.transliteration, this.number, this.en});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    transliteration = json['transliteration'];
    number = json['number'];
    en = json['en'] != null ? new En.fromJson(json['en']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['transliteration'] = this.transliteration;
    data['number'] = this.number;
    if (this.en != null) {
      data['en'] = this.en!.toJson();
    }
    return data;
  }
}

class En {
  String? meaning;

  En({this.meaning});

  En.fromJson(Map<String, dynamic> json) {
    meaning = json['meaning'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['meaning'] = this.meaning;
    return data;
  }
}
