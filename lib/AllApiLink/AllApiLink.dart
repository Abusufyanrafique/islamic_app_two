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
import '../View/QuranScreen/QuranScreen.dart';

class AllApiLink {
  static const String prayerTime = "https://api.aladhan.com/v1/timings";
  static const String Surah = "https://api.alquran.cloud/v1/surah";
  static String getSurahDetail(int surahNumber) => "https://api.alquran.cloud/v1/surah/$surahNumber";
  static const String AyatTranslate = "https://api.alquran.cloud/v1/surah/1/ur.jalandhry";
  static const String AllahName = "https://api.aladhan.com/v1/asmaAlHusna";

  // Backslash (\) lagane se $ ka error khatam ho jayega
  static const String AllHadithBook = "https://hadithapi.com/api/books?apiKey=\$2y\$10\$E2lOOeYerEQTHCnW73oLO1oBRg94cwGGVI1QD7SEhQEnIpWM7Vi";

  static String AlHadithChapters (String bookSlug) => "https://hadithapi.com/api/$bookSlug/chapters?apiKey=\$2y\$10\$E2lOOeYerEQTHCnW73oLO1oBRg94cwGGVI1QD7SEhQEnIpWM7Vi";
  static String AlHadithModel = "https://hadithapi.com/api/hadiths/?apiKey=\$2y\$10\$E2lOOeYerEQTHCnW73oLO1oBRg94cwGGVI1QD7SEhQEnIpWM7Vi";


  static String getHadithByChapter(String bookSlug, String chapterNumber) =>
      "https://hadithapi.com/api/hadiths?apiKey=\$2y\$10\$E2lOOeYerEQTHCnW73oLO1oBRg94cwGGVI1QD7SEhQEnIpWM7Vi&book=$bookSlug&chapter=$chapterNumber";
}
class QuranApiService {


  static Future<QuranResponseModel?> fetchJuzDetail(int juzNumber) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.alquran.cloud/v1/juz/$juzNumber/ar.alafasy'),
        //  quran-uthmani ki jagah ar.alafasy use karo — sab 30 juz work karte hain
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
      final response = await http.get(
        Uri.parse(AllApiLink.Surah),
      );

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
        return data['data']['ayahs']; // Return list of ayahs
      } else {
        throw Exception('Failed to load Juz');
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }
  static Future<AllahNameModel?> fetchAllahNames() async {
    try {
      final response = await http.get(
        Uri.parse(AllApiLink.AllahName),
      );

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
  Future<AllHadithBookModel?> fetchAllHadithBooks() async {
    try {
      final response = await http.get(Uri.parse(AllApiLink.AllHadithBook));

      if (response.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(response.body);
        return AllHadithBookModel.fromJson(body);
      } else {
        throw "Data fetch nahi ho saka: ${response.statusCode}";
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
  static Future<AllHadithChaptersModel?> fetchAlHadithChapterModel(String bookSlug) async {
    try {
      // API int ID nahi balkay bookSlug (e.g., 'sahih-bukhari') mangti hai
      final response = await http.get(Uri.parse(AllApiLink.AlHadithChapters(bookSlug)));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return AllHadithChaptersModel.fromJson(jsonData);
      }
      return null;
    } catch (e) {
      print("Error fetching chapters: $e");
      return null;
    }
  }


  static Future<AllHadithModel?> fetchHadithsByChapter(String bookSlug, String chapterNumber) async {
    try {
      final response = await http.get(Uri.parse(AllApiLink.getHadithByChapter(bookSlug, chapterNumber)));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return AllHadithModel.fromJson(jsonData);
      }
      return null;
    } catch (e) {
      print("Error fetching hadiths: $e");
      return null;
    }
  }

}

