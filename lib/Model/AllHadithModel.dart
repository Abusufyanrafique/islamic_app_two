class AllHadithBookModel {
  int? status;
  String? message;
  List<Books>? books;

  AllHadithBookModel({this.status, this.message, this.books});

  AllHadithBookModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['books'] != null) {
      books = <Books>[];
      json['books'].forEach((v) {
        books!.add(new Books.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.books != null) {
      data['books'] = this.books!.map((v) => v.toJson()).toList();
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
  String? bookSlug;
  String? hadithsCount;
  String? chaptersCount;

  Books(
      {this.id,
        this.bookName,
        this.writerName,
        this.aboutWriter,
        this.writerDeath,
        this.bookSlug,
        this.hadithsCount,
        this.chaptersCount});

  Books.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookName = json['bookName']?.toString();
  writerName = json['writerName']?.toString();
  aboutWriter = json['aboutWriter']?.toString();
  writerDeath = json['writerDeath']?.toString();
  bookSlug = json['bookSlug']?.toString();
  hadithsCount = json['hadiths_count']?.toString();
  chaptersCount = json['chapters_count']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['bookName'] = this.bookName;
    data['writerName'] = this.writerName;
    data['aboutWriter'] = this.aboutWriter;
    data['writerDeath'] = this.writerDeath;
    data['bookSlug'] = this.bookSlug;
    data['hadiths_count'] = this.hadithsCount;
    data['chapters_count'] = this.chaptersCount;
    return data;
  }
}
