import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:local_notification/Model/AlHadithChaptersModel.dart';
import 'package:local_notification/Model/AlHadithModel.dart';
import '../Model/AllHadithModel.dart';
import '../Model/AllSurahModel.dart';
import '../Model/AllahNameModel.dart';
import '../Model/SupaBase/AlQuranModel.dart';


class AllApiLink {
  static const String prayerTime = "https://api.aladhan.com/v1/timings";
  static const String Surah = "https://api.alquran.cloud/v1/surah";
  static String getSurahDetail(int surahNumber) =>
      "https://api.alquran.cloud/v1/surah/$surahNumber";
  static const String AyatTranslate =
      "https://api.alquran.cloud/v1/surah/1/ur.jalandhry";
  static const String AllahName = "https://api.aladhan.com/v1/asmaAlHusna";

  // ========== HADITH (UmmahAPI - No Key Required) ==========
  static const String AllHadithBook =
      "https://ummahapi.com/api/hadith/collections";

  // bookSlug = collection key (e.g. "bukhari", "muslim")
  // chapterNumber = hadith number (1, 2, 3...)
  static String AlHadithChapters(String bookSlug) =>
      "https://ummahapi.com/api/hadith/$bookSlug/1"; // pehla hadith se total milega

  static String AlHadithModel = "https://ummahapi.com/api/hadith/random";

  static String getHadithByChapter(String bookSlug, String chapterNumber) =>
      "https://ummahapi.com/api/hadith/$bookSlug/$chapterNumber";
}


class QuranApiService {

  // ===================== QURAN =====================

  static Future<QuranResponseModel?> fetchJuzDetail(int juzNumber) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.alquran.cloud/v1/juz/$juzNumber/ar.alafasy'),
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return QuranResponseModel.fromJson(json);
      }
      return null;
    } catch (e) {
      debugPrint('Juz fetch error: $e');
      return null;
    }
  }

  static Future<QuranResponseModel?> fetchSurahAyahs(int surahNumber) async {
    try {
      final response = await http.get(
        Uri.parse("https://api.alquran.cloud/v1/surah/$surahNumber/ar.alafasy"),
      );
      if (response.statusCode == 200) {
        return QuranResponseModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      debugPrint("Error fetching Surah: $e");
    }
    return null;
  }

  static Future<SurahModel?> fetchAllSurahs() async {
    try {
      final response = await http.get(Uri.parse(AllApiLink.Surah));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return SurahModel.fromJson(jsonData);
      } else {
        print("Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }

  static Future<SurahDetailModel?> fetchSurahDetail(int surahNumber) async {
    try {
      final response = await http.get(
        Uri.parse(AllApiLink.getSurahDetail(surahNumber)),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return SurahDetailModel.fromJson(jsonData);
      }
      return null;
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }

  Future<List<dynamic>> fetchJuz(int juzNumber) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.alquran.cloud/v1/juz/$juzNumber'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data']['ayahs'];
      } else {
        throw Exception('Failed to load Juz');
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  // ===================== ALLAH NAMES =====================

  static Future<AllahNameModel?> fetchAllahNames() async {
    try {
      final response = await http.get(Uri.parse(AllApiLink.AllahName));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AllahNameModel.fromJson(data);
      } else {
        throw Exception('Failed to load Allah Names');
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  // ===================== HADITH (UmmahAPI) =====================

  // Sab Hadith Books/Collections fetch karna
  // URL: https://ummahapi.com/api/hadith/collections
  // Response: { "success": true, "data": { "collections": [...] } }
 Future<AllHadithBookModel?> fetchAllHadithBooks() async {
  try {
    final url = AllApiLink.AllHadithBook;
    print("=== HADITH URL: $url ===");
    final response = await http.get(Uri.parse(url));
    print("=== STATUS CODE: ${response.statusCode} ===");
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      final model = AllHadithBookModel.fromJson(body);
      print("=== BOOKS COUNT: ${model.books?.length} ===");
      return model;
    }
    return null;
  } catch (e) {
    print("Error: $e");
    return null;
  }
}

  // Chapters fetch — UmmahAPI mein chapters nahi hain
  // Isliye pehle hadith fetch karke total_in_collection se pages banate hain
  // URL: https://ummahapi.com/api/hadith/{bookSlug}/1
  // Response: { "success": true, "data": { "total_in_collection": 7580, ... } }
 static Future<AllHadithChaptersModel?> fetchAlHadithChapterModel(
    String bookSlug, {int total = 100}) async {
  try {
    // pehle number 1 try karo, fail ho to 2, phir 3 — sirf total detect karne ke liye
    Map<String, dynamic>? jsonData;
    for (final n in [1, 2, 3]) {
      final response = await http.get(Uri.parse("https://ummahapi.com/api/hadith/$bookSlug/$n"));
      if (response.statusCode == 200) {
        jsonData = json.decode(response.body);
        break;
      }
    }
    if (jsonData == null) return null;
    return AllHadithChaptersModel.fromJson(jsonData, total: total);
  } catch (e) {
    print("Error fetching chapters: $e");
    return null;
  }
}


static Future<AllHadithModel?> fetchHadithsByChapter(
    String bookSlug,
     String chapterNumber,
     
     ) async {
  try {
    final url = "https://ummahapi.com/api/hadith/$bookSlug/$chapterNumber";
    print("=== HADITH URL: $url ===");
    final response = await http.get(Uri.parse(url));
    print("=== HADITH STATUS: ${response.statusCode} ===");
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return AllHadithModel.fromJson(jsonData);
    }
    // 404 = hadith us number pe exist nahi (e.g. nawawi sirf 42 hadiths hai)
    print("=== HADITH NOT FOUND: $chapterNumber ===");
    return null;
  } catch (e) {
    print("Error fetching hadiths: $e");
    return null;
  }
}
// ✅ YEH FUNCTION ADD KARO - start se end tak sari hadiths fetch karta hai
static Future<List<dynamic>> fetchHadithsByRange(
  String bookSlug, {
  required int start,
  required int end,
}) async {
  final List<dynamic> allHadiths = [];

  // 10-10 ka batch banao - sab ek saath fetch ho
  const batchSize = 10;

  for (int i = start; i <= end; i += batchSize) {
    final batchEnd = (i + batchSize - 1) > end ? end : (i + batchSize - 1);

    // ✅ Future.wait - parallel requests, fast loading
    final futures = List.generate(
      batchEnd - i + 1,
      (j) => fetchHadithsByChapter(bookSlug, (i + j).toString()),
    );

    final results = await Future.wait(futures);

    for (final result in results) {
      if (result != null) {
        final data = result.hadiths?.data;
        if (data != null && data.isNotEmpty) {
          allHadiths.addAll(data);
        }
      }
    }
  }

  return allHadiths;
}
}