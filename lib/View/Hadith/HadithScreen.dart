
import 'package:flutter/material.dart';
import 'package:local_notification/Utils/Constants/AllColors.dart';
import 'package:local_notification/Utils/Constants/SizeConfig.dart';
import '../../Model/AlHadithChaptersModel.dart';
import '../../Model/AlHadithModel.dart';
import '../../Model/AllHadithModel.dart';
import '../../Utils/Constants/AllImages.dart';
import '../../AllApiLink/AllApiLink.dart';
import '../../Utils/Constants/userFeedback.dart';

class HadithScreen extends StatelessWidget {
  HadithScreen({super.key});

  // Aapki class ka naam QuranApiService hai
  final QuranApiService apiService = QuranApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Hadith Books",
          style:AppColors().customTextStyle15().copyWith(
            color: AppColors.black,
            fontSize: getFont(16),
          )
          ),
        centerTitle: true,
         bottom: PreferredSize(
    preferredSize: const Size.fromHeight(0.12),
    child: Container(
      color: const Color(0xFF6B7678),
      height: 0.12,
    ),
  ),
      ),

      body: FutureBuilder<AllHadithBookModel?>(
        future: apiService.fetchAllHadithBooks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            debugPrint(snapshot.error.toString());
           debugPrint(snapshot.stackTrace.toString());
           print("URL: ${AllApiLink.AllHadithBook}");

            return Center(child: spinkit);
          }

          if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text("Data loading error!"));
          }

          final booksList = snapshot.data!.books ?? [];

          return ListView.builder(
            itemCount: booksList.length,
            itemBuilder: (context, index) {
              final book = booksList[index];
              return InkWell(

               onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => HadithChaptersScreen(
        bookSlug: book.bookSlug!,
        bookName: book.bookName!,
        totalHadiths: int.tryParse(book.hadithsCount ?? "") ?? 100, // ✅ real count
      ),
    ),
  );
},
                // HadithBookCard ka index fix karo — id null ho sakta hai
  child: HadithBookCard(
  index: index + 1,   // book.id! ki jagah
  name: book.bookName ?? "",
  writerName: book.writerName ?? "",
  hadithCount: book.hadithsCount ?? "",
),

                // Card(
                //   child: ListTile(
                //     leading: Image.asset(AllImages.makkah, width: 50),
                //     title: Text(book.bookName ?? ""),
                //     subtitle: Text(book.writerName ?? ""),
                //     trailing: Text("${book.hadithsCount} Hadiths",style: TextStyle(fontSize: 10),),
                //   ),
                // ),
              );
            },
          );
        },
      ),
    );
  }
}

class HadithChaptersScreen extends StatelessWidget {
  final String bookSlug;
  final String bookName;
  final int? totalHadiths;
  const HadithChaptersScreen({
    super.key, 
    required this.bookSlug, 
    required this.bookName, 
      this.totalHadiths,
    });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          bookName,
          style: TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
            ),),
        foregroundColor: AppColors.primaryColor ,
      ),

      body: FutureBuilder<AllHadithChaptersModel?>(
        future: QuranApiService.fetchAlHadithChapterModel(
          bookSlug,
          total: totalHadiths!,
          ),
        
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            debugPrint("ERROR: ${snapshot.error}");
            debugPrint("STACK: ${snapshot.stackTrace}");
            return Center(child: spinkit);
          }
          if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text("Chapters load nahi ho sakay"));
          }

          final chapters = snapshot.data!.chapters ?? [];

          return ListView.builder(
            itemCount: chapters.length,
            itemBuilder: (context, index) {
              final chapter = chapters[index];
              return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HadithListScreen(
                              bookSlug: chapter.bookSlug!,
                              chapterNumber: chapter.chapterNumber!,
                              chapterName: chapter.chapterUrdu ?? "Hadith",
                            ),
                          ),
                        );
                      },
                  child: HadithChapterCard(index: chapter.chapterNumber!,name:chapter.chapterUrdu ?? "" ,EnglishName:chapter.chapterEnglish ?? "" ,));
            },
          );
        },
      ),
    );
  }
}
class HadithListScreen extends StatelessWidget {
  final String bookSlug;
  final String chapterNumber;
  final String chapterName;

  const HadithListScreen({
    super.key,
    required this.bookSlug,
    required this.chapterNumber,
    required this.chapterName
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
          title: Text(chapterName,style: TextStyle(color: AppColors.primaryColor),),
      foregroundColor: AppColors.primaryColor ,
      ),
      body: FutureBuilder<AllHadithModel?>(
        future: QuranApiService.fetchHadithsByChapter(bookSlug, chapterNumber),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
             print("Error: ${snapshot.error}");
             print("Data: ${snapshot.data}");
            return Center(child: spinkit);
          }
          if (snapshot.hasError || snapshot.data == null || snapshot.data!.hadiths == null) {
            return const Center(child: Text("Hadiths not Available."));
          }

          final hadithList = snapshot.data!.hadiths!.data ?? [];

          return ListView.builder(
            itemCount: hadithList.length,
            padding:  EdgeInsets.symmetric(
              horizontal: getWidth(16),
              vertical: getHeight(12)),
            itemBuilder: (context, index) {
              final hadith = hadithList[index];
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.white
                ),
                child: Card(
                  elevation: 4,
                  margin:  EdgeInsets.only(bottom: getHeight(15)),
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Hadith No: ${hadith.hadithNumber}",
                                style:AppColors().customTextStyle15(
                                  color: AppColors.primaryColor
                                ).copyWith(
                                  fontWeight: FontWeight.bold
                                )
                                  ),
                
                
                            Text(
                              "Chapter No: ${hadith.chapterId}",
                                style:AppColors().customTextStyle15(
                                  color: AppColors.primaryColor
                                ).copyWith(
                                  fontWeight: FontWeight.bold
                                )
                                   ),
                          ],
                        ),
                        const Divider(),
                        // Arabic
                        Text(hadith.hadithArabic ?? "",
                            textAlign: TextAlign.right,
                            style:  TextStyle(fontSize: getFont(24), fontWeight: FontWeight.bold, fontFamily: 'ArabicFont')),
                         SizedBox(height: getHeight(10)),
                        // Urdu
                        Text(hadith.hadithUrdu ?? "",
                            textAlign: TextAlign.right,
                            style:  TextStyle(fontSize: getFont(16), color: Colors.blueGrey)),
                         SizedBox(height: getHeight(10)),
                        // English
                        Text(
                          hadith.hadithEnglish ?? "",
                            textAlign: TextAlign.left,
                            style: AppColors().customTextStyle14(
                
                            ).copyWith(
                              height: 1.3,
                              fontStyle: FontStyle.italic
                            )
                               ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
class HadithBookCard extends StatelessWidget {
  final int index;
  final String name;
  final String writerName;
  final String hadithCount;

  const HadithBookCard({
    super.key,
    required this.index,
    required this.name,
    required this.writerName,
    required this.hadithCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(
        vertical: getHeight(8), 
        horizontal: getWidth(16)),
      // 1. IntrinsicHeight add kiya gaya hai
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch, // 2. Isse children full height le lenge
          children: [
            // Left vertical line
            Container(
              width: getWidth(6),
              // height ab dene ki zaroorat nahi, stretch khud manage karega
              decoration: BoxDecoration(
                color: const Color(0xff5BC0BE),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
             SizedBox(width: getWidth(12)),

            // Card
            Expanded(
              child: Container(
                padding:  EdgeInsets.symmetric(
                  horizontal: getWidth(16),
                 vertical: getHeight(14)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 6,
                    )
                  ],
                ),
                child: Row(
                  children: [
                    // Number with image background
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Agar AllImages.paranum error de to path check karein
                        Image.asset(AllImages.paranum, 
                        height: getHeight(40), 
                        width: getWidth(40)),
                        Text(
                          index.toString(),
                          style:  TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: getFont(16),
                          ),
                        ),
                      ],
                    ),
                     SizedBox(width: getWidth(16)),

                    // Book Name + Writer info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center, // Center aligned
                        children: [
                          Text(
                            name,
                            style:  TextStyle(
                              fontSize: getFont(16),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                           SizedBox(height: getHeight(4)),
                          Text(
                            writerName,
                            style:  TextStyle(
                              fontSize: getFont(12),
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Hadith Count
                    Text(
                      "Hadith \n $hadithCount",
                      style:  TextStyle(
                        fontSize: getFont(10),
                        color: Color(0xff5BC0BE),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class HadithChapterCard extends StatelessWidget {
  final String index;
  final String name;
  final String EnglishName;


  const HadithChapterCard({
    super.key,
    required this.index,
    required this.name,
    required this.EnglishName,

  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(
        vertical: getHeight(8),
         horizontal: getWidth(16)),
      // 1. IntrinsicHeight add kiya gaya hai
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch, // 2. Isse children full height le lenge
          children: [
            // Left vertical line
            Container(
              width: getWidth(6),
              // height ab dene ki zaroorat nahi, stretch khud manage karega
              decoration: BoxDecoration(
                color: const Color(0xff5BC0BE),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
             SizedBox(width: getWidth(12)),

            // Card
            Expanded(
              child: Container(
                padding:  EdgeInsets.symmetric(
                  horizontal: getWidth(16), 
                  vertical: getHeight(14)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 6,
                    )
                  ],
                ),
                child: Row(
                  children: [
                    // Number with image background
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Agar AllImages.paranum error de to path check karein
                        Image.asset(AllImages.paranum, 
                        height: getHeight(40), 
                        width: getWidth(40)),
                        Text(
                          index.toString(),
                          style:  TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: getFont(16),
                          ),
                        ),
                      ],
                    ),
                     SizedBox(width:getWidth(16)),

                    // Book Name + Writer info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center, // Center aligned
                        children: [
                          Text(
                            name,
                            style:  TextStyle(
                              fontSize: getFont(16),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                           SizedBox(height: getHeight(4)),
                          Text(
                            EnglishName,
                            style:  TextStyle(
                              fontSize: getFont(12),
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                 Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xff5BC0BE),),
                    // Hadith Count
                    // Text("",
                    //  // "Hadith \n $hadithCount",
                    //   style: const TextStyle(
                    //     fontSize: 10,
                    //     color: Color(0xff5BC0BE),
                    //     fontWeight: FontWeight.w600,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

