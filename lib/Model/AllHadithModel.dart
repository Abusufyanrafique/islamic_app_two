class AllHadithBookModel {
  int? status;
  String? message;
  List<Books>? books;

  AllHadithBookModel({this.status, this.message, this.books});

  // UmmahAPI response:
  // { "success": true, "data": { "collections": [ {...}, ... ] } }
  AllHadithBookModel.fromJson(Map<String, dynamic> json) {
    status = (json['success'] == true) ? 200 : 0;
    message = json['service']?.toString();
    final data = json['data'];
    if (data != null && data['collections'] != null) {
      books = <Books>[];
      int i = 1;
      data['collections'].forEach((v) {
        final b = Books.fromJson(v);
        b.id = i++;
        books!.add(b);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['message'] = message;
    if (books != null) {
      data['books'] = books!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Books {
  int? id;
  String? bookName;
  String? writerName;
  String? aboutWriter;
  String? writerDeath;
  String? bookSlug;      // = key (e.g. "bukhari")
  String? hadithsCount;  // = total_hadiths
  String? chaptersCount;

  Books({
    this.id,
    this.bookName,
    this.writerName,
    this.aboutWriter,
    this.writerDeath,
    this.bookSlug,
    this.hadithsCount,
    this.chaptersCount,
  });

  // UmmahAPI: { "key": "bukhari", "name": "Sahih al-Bukhari",
  //             "author": "Imam Bukhari", "total_hadiths": 7580 }
  Books.fromJson(Map<String, dynamic> json) {
    bookSlug     = json['key']?.toString();
    bookName     = json['name']?.toString();
    writerName   = json['author']?.toString();
    hadithsCount = json['total_hadiths']?.toString();
    aboutWriter  = json['arabic_name']?.toString();
    writerDeath  = json['reliability']?.toString();
    chaptersCount = null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookName': bookName,
      'writerName': writerName,
      'aboutWriter': aboutWriter,
      'writerDeath': writerDeath,
      'bookSlug': bookSlug,
      'hadiths_count': hadithsCount,
      'chapters_count': chaptersCount,
    };
  }
}