class AllHadithChaptersModel {
  int? status;
  String? message;
  List<Chapters>? chapters;

  AllHadithChaptersModel({this.status, this.message, this.chapters});

  AllHadithChaptersModel.fromJson(Map<String, dynamic> json, {int total = 100}) {
    status = (json['success'] == true) ? 200 : 0;
    message = "OK";
    chapters = <Chapters>[];

    final data = json['data'];
    if (data == null) return;

    final String slug = data['collection']?.toString() ?? "";
    const int perPage = 50;
    final int totalPages = (total / perPage).ceil().clamp(1, 999);

    for (int i = 0; i < totalPages; i++) {
      final int start = (i * perPage) + 1;
      final int end = ((i + 1) * perPage).clamp(1, total);
      chapters!.add(Chapters(
        id: i + 1,
        chapterNumber: start.toString(),
        chapterEnglish: "Hadiths $start – $end",
        chapterUrdu: "احادیث $start – $end",
        chapterArabic: "",
        bookSlug: slug,
      ));
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      if (chapters != null)
        'chapters': chapters!.map((v) => v.toJson()).toList(),
    };
  }
}

class Chapters {
  int? id;
  String? chapterNumber;
  String? chapterEnglish;
  String? chapterUrdu;
  String? chapterArabic;
  String? bookSlug;

  Chapters({
    this.id,
    this.chapterNumber,
    this.chapterEnglish,
    this.chapterUrdu,
    this.chapterArabic,
    this.bookSlug,
  });

  Chapters.fromJson(Map<String, dynamic> json) {
    id             = json['id'];
    chapterNumber  = json['chapterNumber']?.toString();
    chapterEnglish = json['chapterEnglish']?.toString();
    chapterUrdu    = json['chapterUrdu']?.toString();
    chapterArabic  = json['chapterArabic']?.toString();
    bookSlug       = json['bookSlug']?.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chapterNumber': chapterNumber,
      'chapterEnglish': chapterEnglish,
      'chapterUrdu': chapterUrdu,
      'chapterArabic': chapterArabic,
      'bookSlug': bookSlug,
    };
  }
}