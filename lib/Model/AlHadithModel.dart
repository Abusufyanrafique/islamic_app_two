class AllHadithModel {
  int? status;
  String? message;
  Hadiths? hadiths;

  AllHadithModel({this.status, this.message, this.hadiths});

  AllHadithModel.fromJson(Map<String, dynamic> json) {
    status  = (json['success'] == true) ? 200 : 0;
    message = "OK";
    if (json['data'] != null) {
      hadiths = Hadiths.fromSingleJson(json['data']);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      if (hadiths != null) 'hadiths': hadiths!.toJson(),
    };
  }
}

class Hadiths {
  int? currentPage;
  List<Data>? data;

  Hadiths({this.currentPage, this.data});

  Hadiths.fromSingleJson(Map<String, dynamic> json) {
    currentPage = 1;
    data        = [Data.fromJson(json)];
  }

  Map<String, dynamic> toJson() => {
    'current_page': currentPage,
    'data': data?.map((v) => v.toJson()).toList(),
  };
}

class Data {
  int? id;
  String? hadithNumber;
  String? englishNarrator;
  String? hadithEnglish;
  String? hadithUrdu;
  String? urduNarrator;
  String? hadithArabic;
  String? headingArabic;
  String? headingUrdu;
  String? headingEnglish;
  String? chapterId;
  String? bookSlug;
  String? volume;
  String? status;
  Book? book;
  Chapter? chapter;

  Data({
    this.id, this.hadithNumber, this.englishNarrator,
    this.hadithEnglish, this.hadithUrdu, this.urduNarrator,
    this.hadithArabic, this.headingArabic, this.headingUrdu,
    this.headingEnglish, this.chapterId, this.bookSlug,
    this.volume, this.status, this.book, this.chapter,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id             = json['hadithnumber'] is int
        ? json['hadithnumber']
        : int.tryParse(json['hadithnumber']?.toString() ?? '');
    hadithNumber   = json['hadithnumber']?.toString();
    hadithArabic   = json['arabic']?.toString();
    status         = json['grade']?.toString();
    bookSlug       = json['collection']?.toString();
    headingEnglish = json['collection_name']?.toString();
    hadithUrdu     = null;
    urduNarrator   = null;
    headingUrdu    = null;
    headingArabic  = null;
    chapterId      = null;
    volume         = null;
    book           = null;
    chapter        = null;

    // English text se narrator alag karo
    final String raw = json['english']?.toString() ?? "";
    if (raw.startsWith("Narrated ")) {
      final int colon = raw.indexOf(':');
      if (colon != -1) {
        englishNarrator = raw.substring(9, colon).trim();
        hadithEnglish   = raw.substring(colon + 1).trim();
      } else {
        hadithEnglish = raw;
      }
    } else {
      hadithEnglish = raw;
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'hadithNumber': hadithNumber,
    'hadithEnglish': hadithEnglish,
    'hadithArabic': hadithArabic,
    'bookSlug': bookSlug,
    'status': status,
  };
}

class Book {
  int? id;
  String? bookName;
  String? writerName;
  String? aboutWriter;
  String? writerDeath;
  String? bookSlug;

  Book({this.id, this.bookName, this.writerName,
        this.aboutWriter, this.writerDeath, this.bookSlug});

  Book.fromJson(Map<String, dynamic> json) {
    bookName = json['bookName']?.toString();
    bookSlug = json['bookSlug']?.toString();
  }

  Map<String, dynamic> toJson() =>
      {'bookName': bookName, 'bookSlug': bookSlug};
}

class Chapter {
  int? id;
  String? chapterNumber;
  String? chapterEnglish;
  String? chapterUrdu;
  String? chapterArabic;
  String? bookSlug;

  Chapter({this.id, this.chapterNumber, this.chapterEnglish,
           this.chapterUrdu, this.chapterArabic, this.bookSlug});

  Chapter.fromJson(Map<String, dynamic> json) {
    chapterNumber  = json['number']?.toString();
    chapterEnglish = json['english']?.toString();
    chapterArabic  = json['arabic']?.toString();
  }

  Map<String, dynamic> toJson() => {
    'chapterNumber': chapterNumber,
    'chapterEnglish': chapterEnglish,
    'bookSlug': bookSlug,
  };
}

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url    = json['url'];
    label  = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() =>
      {'url': url, 'label': label, 'active': active};
}