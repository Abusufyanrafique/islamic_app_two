import 'package:flutter/material.dart';
import 'package:local_notification/Utils/Constants/AllColors.dart';
import 'package:local_notification/Utils/Constants/SizeConfig.dart';

import 'AllDuaScreen.dart';

class Subject {
  final String key;
  final String name;
  final String icon;
  final String subtitle;
  final List<Dua> duas;

  const Subject({
    required this.key,
    required this.name,
    required this.icon,
    required this.subtitle,
    required this.duas,
  });
}


final List<Subject> subjects = [
  Subject(
    key: 'mosque',
    name: 'Mosque',
    icon: '🕌',
    subtitle: 'Supplications for entering and leaving the Mosque',
    duas: [
      Dua(
        label: 'Entering the Mosque',
        labelBg: const Color(0xFFE1F5EE),
        labelColor: const Color(0xFF0F6E56),
        arabic: 'اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ',
        urdu: 'اے اللہ! میرے لیے اپنی رحمت کے دروازے کھول دے',
        translation: 'O Allah! Open for me the doors of Your mercy.',
      ),
      Dua(
        label: 'Leaving the Mosque',
        labelBg: const Color(0xFFFAECE7),
        labelColor: const Color(0xFF993C1D),
        arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ',
        urdu: 'اے اللہ! میں تجھ سے تیرا فضل مانگتا ہوں',
        translation: 'O Allah! I ask You for Your bounty.',
      ),
      Dua(
        label: 'After hearing the Azan',
        labelBg: const Color(0xFFE6F1FB),
        labelColor: const Color(0xFF185FA5),
        arabic: 'اللَّهُمَّ رَبَّ هَذِهِ الدَّعْوَةِ التَّامَّةِ',
        urdu: 'اے اللہ! اس کامل پکار کے رب',
        translation: 'O Allah! Lord of this perfect call, grant Muhammad (SAW) the mediation and excellence.',
      ),
      Dua(
        label: 'After Prayer',
        labelBg: const Color(0xFFEEEDFE),
        labelColor: const Color(0xFF534AB7),
        arabic: 'سُبْحَانَ اللَّهِ وَالْحَمْدُ لِلَّهِ وَاللَّهُ أَكْبَرُ',
        urdu: 'اللہ پاک ہے، تمام تعریفیں اللہ کے لیے ہیں، اللہ سب سے بڑا ہے',
        translation: 'Glory be to Allah, all praise is for Allah, Allah is the Greatest.',
      ),
    ],
  ),
  Subject(
    key: 'travel',
    name: 'Travel',
    icon: '✈️',
    subtitle: 'Supplications to recite during travel',
    duas: [
      Dua(
        label: 'Starting a Journey',
        labelBg: const Color(0xFFE1F5EE),
        labelColor: const Color(0xFF0F6E56),
        arabic: 'سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ',
        urdu: 'پاک ہے وہ ذات جس نے ہمارے لیے اسے مسخر کیا',
        translation: 'Glory be to Him Who has brought this under our control.',
      ),
      Dua(
        label: 'Returning Home',
        labelBg: const Color(0xFFFAECE7),
        labelColor: const Color(0xFF993C1D),
        arabic: 'آيِبُونَ تَائِبُونَ عَابِدُونَ لِرَبِّنَا حَامِدُونَ',
        urdu: 'لوٹنے والے، توبہ کرنے والے، عبادت کرنے والے',
        translation: 'We return, repenting, worshipping, and praising our Lord.',
      ),
      Dua(
        label: 'Reaching the Destination',
        labelBg: const Color(0xFFF1EFE8),
        labelColor: const Color(0xFF5F5E5A),
        arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ خَيْرَهَا وَخَيْرَ أَهْلِهَا',
        urdu: 'اے اللہ! میں اس جگہ اور اس کے لوگوں سے بھلائی مانگتا ہوں',
        translation: 'O Allah! I ask You for the goodness of this place and the goodness of its people.',
      ),
      Dua(
        label: 'Prayer for Journey',
        labelBg: const Color(0xFFE6F1FB),
        labelColor: const Color(0xFF185FA5),
        arabic: 'اللَّهُمَّ هَوِّنْ عَلَيْنَا سَفَرَنَا هَذَا',
        urdu: 'اے اللہ! ہمارے اس سفر کو ہمارے لیے آسان فرما',
        translation: 'O Allah! Make this journey of ours easy for us.',
      ),
      Dua(
        label: 'Boarding a Vehicle',
        labelBg: const Color(0xFFEEEDFE),
        labelColor: const Color(0xFF534AB7),
        arabic: 'بِسْمِ اللَّهِ مَجْرَيهَا وَمُرْسَاهَا',
        urdu: 'اللہ کے نام سے اس کا چلنا اور رکنا hai',
        translation: 'In the name of Allah is its moving and its staying.',
      ),
    ],
  ),
  Subject(
    key: 'food',
    name: 'Food',
    icon: '🍽️',
    subtitle: 'Supplications before and after eating',
    duas: [
      Dua(
        label: 'Before Eating',
        labelBg: const Color(0xFFE1F5EE),
        labelColor: const Color(0xFF0F6E56),
        arabic: 'بِسْمِ اللَّهِ وَعَلَى بَرَكَةِ اللَّهِ',
        urdu: 'اللہ کے نام سے اور اللہ کی برکت کے ساتھ',
        translation: 'In the name of Allah and with the blessings of Allah.',
      ),
      Dua(
        label: 'After Eating',
        labelBg: const Color(0xFFFAECE7),
        labelColor: const Color(0xFF993C1D),
        arabic: 'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنَا وَسَقَانَا وَجَعَلَنَا مُسْلِمِينَ',
        urdu: 'تعریف اللہ کی جس نے ہمیں کھلایا، پلایا اور مسلمان بنایا',
        translation: 'All praise is for Allah Who gave us food and drink and made us Muslims.',
      ),
      Dua(
        label: 'If Bismillah is forgotten',
        labelBg: const Color(0xFFEAF3DE),
        labelColor: const Color(0xFF3B6D11),
        arabic: 'بِسْمِ اللَّهِ فِي أَوَّلِهِ وَآخِرِهِ',
        urdu: 'اللہ کے نام سے اس کے اول اور آخر میں',
        translation: 'In the name of Allah, in the beginning and in the end.',
      ),
      Dua(
        label: 'Supplication for Host',
        labelBg: const Color(0xFFFAEEDA),
        labelColor: const Color(0xFF854F0B),
        arabic: 'اللَّهُمَّ بَارِكْ لَهُمْ فِيمَا رَزَقْتَهُمْ',
        urdu: 'اے اللہ! جو تو نے انہیں رزق دیا ہے اس میں برکت دے',
        translation: 'O Allah! Bless them in what You have provided for them.',
      ),
    ],
  ),
  Subject(
    key: 'sleep',
    name: 'Sleep',
    icon: '🌙',
    subtitle: 'Supplications for sleeping and waking up',
    duas: [
      Dua(
        label: 'Before Sleeping',
        labelBg: const Color(0xFFEEEDFE),
        labelColor: const Color(0xFF534AB7),
        arabic: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
        urdu: 'اے اللہ! تیرے نام کے ساتھ مرتا ہوں اور جیتا ہوں',
        translation: 'In Your name, O Allah, I die and I live.',
      ),
      Dua(
        label: 'Waking Up',
        labelBg: const Color(0xFFE1F5EE),
        labelColor: const Color(0xFF0F6E56),
        arabic: 'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ',
        urdu: 'تعریف اللہ کی جس نے ہمیں موت دینے کے بعد زندگی دی',
        translation: 'All praise is for Allah Who gave us life after taking it from us, and to Him is the resurrection.',
      ),
      Dua(
        label: 'After a Bad Dream',
        labelBg: const Color(0xFFFCEBEB),
        labelColor: const Color(0xFFA32D2D),
        arabic: 'أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ',
        urdu: 'میں شیطان مردود سے اللہ کی پناہ مانگتا ہوں',
        translation: 'I seek refuge in Allah from the accursed Shaitan.',
      ),
      Dua(
        label: 'While lying in Bed',
        labelBg: const Color(0xFFE6F1FB),
        labelColor: const Color(0xFF185FA5),
        arabic: 'اللَّهُمَّ قِنِي عَذَابَكَ يَوْمَ تَبْعَثُ عِبَادَكَ',
        urdu: 'اے اللہ! جس دن تو اپنے بندوں کو اٹھائے اس دن مجھے عذاب سے بچا',
        translation: 'O Allah! Protect me from Your punishment on the day You resurrect Your servants.',
      ),
      Dua(
        label: 'For Peaceful Sleep',
        labelBg: const Color(0xFFF1EFE8),
        labelColor: const Color(0xFF5F5E5A),
        arabic: 'سُبْحَانَكَ اللَّهُمَّ وَبِحَمْدِكَ',
        urdu: 'اے اللہ! تو پاک ہے اور تیری حمد کے ساتھ',
        translation: 'Glory be to You, O Allah, and with Your praise.',
      ),
    ],
  ),
  Subject(
    key: 'toilet',
    name: 'Toilet',
    icon: '🚿',
    subtitle: 'Supplications for entering and leaving the Bathroom',
    duas: [
      Dua(
        label: 'Entering the Bathroom',
        labelBg: const Color(0xFFE1F5EE),
        labelColor: const Color(0xFF0F6E56),
        arabic: 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْخُبُثِ وَالْخَبَائِثِ',
        urdu: 'اے اللہ! میں ناپاک جنوں سے تیری پناہ مانگتا ہوں',
        translation: 'O Allah! I seek refuge in You from the male and female evil spirits.',
      ),
      Dua(
        label: 'Leaving the Bathroom',
        labelBg: const Color(0xFFFAECE7),
        labelColor: const Color(0xFF993C1D),
        arabic: 'غُفْرَانَكَ',
        urdu: 'اے اللہ! میں تجھ سے مغفرت مانگتا ہوں',
        translation: 'I seek Your forgiveness.',
      ),
      Dua(
        label: 'Before using Water',
        labelBg: const Color(0xFFF1EFE8),
        labelColor: const Color(0xFF5F5E5A),
        arabic: 'بِسْمِ اللَّهِ',
        urdu: 'اللہ کے نام سے',
        translation: 'In the name of Allah.',
      ),
    ],
  ),
  Subject(
    key: 'wudu',
    name: 'Wudu',
    icon: '💧',
    subtitle: 'Supplications for performing Ablution',
    duas: [
      Dua(
        label: 'Starting Ablution',
        labelBg: const Color(0xFFE6F1FB),
        labelColor: const Color(0xFF185FA5),
        arabic: 'بِسْمِ اللَّهِ',
        urdu: 'اللہ کے نام سے',
        translation: 'In the name of Allah.',
      ),
      Dua(
        label: 'Completing Ablution',
        labelBg: const Color(0xFFE1F5EE),
        labelColor: const Color(0xFF0F6E56),
        arabic: 'أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ',
        urdu: 'میں گواہی دیتا ہوں کہ اللہ کے سوا کوئی معبود نہیں',
        translation: 'I bear witness that there is no god but Allah, and Muhammad (SAW) is His servant and Messenger.',
      ),
      Dua(
        label: 'Washing the Face',
        labelBg: const Color(0xFFEEEDFE),
        labelColor: const Color(0xFF534AB7),
        arabic: 'اللَّهُمَّ بَيِّضْ وَجْهِي يَوْمَ تَبْيَضُّ وُجُوهٌ',
        urdu: 'اے اللہ! جس دن چہرے روشن ہوں میرا چہرہ روشن فرما',
        translation: 'O Allah! Make my face bright on the day when faces will be bright.',
      ),
      Dua(
        label: 'Washing the Hands',
        labelBg: const Color(0xFFFAECE7),
        labelColor: const Color(0xFF993C1D),
        arabic: 'اللَّهُمَّ أَعْطِنِي كِتَابِي بِيَمِينِي',
        urdu: 'اے اللہ! میرا نامۂ اعمال میرے داہنے ہاتھ میں دے',
        translation: 'O Allah! Give me my record in my right hand.',
      ),
      Dua(
        label: 'Wiping the Head',
        labelBg: const Color(0xFFEAF3DE),
        labelColor: const Color(0xFF3B6D11),
        arabic: 'اللَّهُمَّ حَرِّمْنِي عَلَى النَّارِ',
        urdu: 'اے اللہ! مجھے آگ پر حرام فرما دے',
        translation: 'O Allah! Forbid the Fire from touching me.',
      ),
    ],
  ),
  Subject(
    key: 'morning',
    name: 'Morning & Evening',
    icon: '🌅',
    subtitle: 'Morning and Evening remembrances (Azkar)',
    duas: [
      Dua(
        label: 'Morning Supplication',
        labelBg: const Color(0xFFE6F1FB),
        labelColor: const Color(0xFF185FA5),
        arabic: 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ',
        urdu: 'ہم نے صبح کی اور بادشاہت اللہ کے لیے ہے',
        translation: 'We have reached the morning and the kingdom belongs to Allah.',
      ),
      Dua(
        label: 'Evening Supplication',
        labelBg: const Color(0xFFEEEDFE),
        labelColor: const Color(0xFF534AB7),
        arabic: 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ',
        urdu: 'ہم نے شام کی اور بادشاہت اللہ کے لیے ہے',
        translation: 'We have reached the evening and the kingdom belongs to Allah.',
      ),
      Dua(
        label: 'Morning Ayat-ul-Kursi',
        labelBg: const Color(0xFFE1F5EE),
        labelColor: const Color(0xFF0F6E56),
        arabic: 'اللَّهُ لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ',
        urdu: 'اللہ وہ ہے جس کے سوا کوئی معبود نہیں',
        translation: 'Allah! There is no god but He, the Ever-Living, the Sustainer of existence.',
      ),
      Dua(
        label: 'Morning Tasbih',
        labelBg: const Color(0xFFFAEEDA),
        labelColor: const Color(0xFF854F0B),
        arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
        urdu: 'اللہ پاک ہے اور اس کی تعریف کے ساتھ',
        translation: 'Glory be to Allah and praise is for Him.',
      ),
      Dua(
        label: 'Evening Protection',
        labelBg: const Color(0xFFFAECE7),
        labelColor: const Color(0xFF993C1D),
        arabic: 'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ',
        urdu: 'میں اللہ کے کامل کلمات کی پناہ مانگتا ہوں',
        translation: 'I seek refuge in the perfect words of Allah.',
      ),
    ],
  ),
  Subject(
    key: 'rain',
    name: 'Rain',
    icon: '🌧️',
    subtitle: 'Supplications for rain and thunderstorms',
    duas: [
      Dua(
        label: 'During Rain',
        labelBg: const Color(0xFFE6F1FB),
        labelColor: const Color(0xFF185FA5),
        arabic: 'اللَّهُمَّ صَيِّبًا نَافِعًا',
        urdu: 'اے اللہ! نفع بخش بارش نازل فرما',
        translation: 'O Allah! Send upon us a beneficial rain.',
      ),
      Dua(
        label: 'After Rain',
        labelBg: const Color(0xFFF1EFE8),
        labelColor: const Color(0xFF5F5E5A),
        arabic: 'مُطِرْنَا بِفَضْلِ اللَّهِ وَرَحْمَتِهِ',
        urdu: 'ہم پر اللہ کے فضل اور رحمت سے بارش ہوئی',
        translation: 'It has rained upon us by the grace and mercy of Allah.',
      ),
      Dua(
        label: 'To stop excessive Rain',
        labelBg: const Color(0xFFEEEDFE),
        labelColor: const Color(0xFF534AB7),
        arabic: 'اللَّهُمَّ حَوَالَيْنَا وَلَا عَلَيْنَا',
        urdu: 'اے اللہ! ہمارے ارد گرد برسا ہم پر نہیں',
        translation: 'O Allah! Round about us and not upon us.',
      ),
      Dua(
        label: 'During Thunder',
        labelBg: const Color(0xFFFAEEDA),
        labelColor: const Color(0xFF854F0B),
        arabic: 'سُبْحَانَ الَّذِي يُسَبِّحُ الرَّعْدُ بِحَمْدِهِ',
        urdu: 'پاک ہے وہ جس کی حمد کے ساتھ بادل تسبیح کرتا ہے',
        translation: 'Glory be to Him whom the thunder glorifies with His praise.',
      ),
    ],
  ),
  Subject(
    key: 'home',
    name: 'Home',
    icon: '🏠',
    subtitle: 'Supplications for entering and leaving the Home',
    duas: [
      Dua(
        label: 'Entering the Home',
        labelBg: const Color(0xFFE1F5EE),
        labelColor: const Color(0xFF0F6E56),
        arabic: 'بِسْمِ اللَّهِ وَلَجْنَا وَبِسْمِ اللَّهِ خَرَجْنَا',
        urdu: 'اللہ کے نام سے ہم داخل ہوئے اور اللہ کے نام سے نکلے',
        translation: 'In the name of Allah we enter, and in the name of Allah we leave.',
      ),
      Dua(
        label: 'Leaving the Home',
        labelBg: const Color(0xFFFAECE7),
        labelColor: const Color(0xFF993C1D),
        arabic: 'بِسْمِ اللَّهِ تَوَكَّلْتُ عَلَى اللَّهِ',
        urdu: 'اللہ کے نام سے، میں نے اللہ پر بھروسہ کیا',
        translation: 'In the name of Allah, I place my trust in Allah.',
      ),
      Dua(
        label: 'Blessing in the Home',
        labelBg: const Color(0xFFE6F1FB),
        labelColor: const Color(0xFF185FA5),
        arabic: 'رَبِّ أَنْزِلْنِي مُنْزَلًا مُبَارَكًا',
        urdu: 'اے میرے رب! مجھے بابرکت جگہ اتار',
        translation: 'My Lord! Let me land at a blessed landing-place.',
      ),
      Dua(
        label: 'Protection when leaving',
        labelBg: const Color(0xFFEEEDFE),
        labelColor: const Color(0xFF534AB7),
        arabic: 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ أَنْ أَضِلَّ أَوْ أُضَلَّ',
        urdu: 'اے اللہ! میں گمراہ ہونے اور گمراہ کیے جانے سے تیری پناہ مانگتا ہوں',
        translation: 'O Allah! I seek refuge in You lest I stray or be led astray.',
      ),
    ],
  ),
  Subject(
    key: 'distress',
    name: 'Distress',
    icon: '🤲',
    subtitle: 'Supplications for difficulties and anxiety',
    duas: [
      Dua(
        label: 'Anxiety and Sorrow',
        labelBg: const Color(0xFFFCEBEB),
        labelColor: const Color(0xFFA32D2D),
        arabic: 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ',
        urdu: 'اے اللہ! میں فکر اور غم سے تیری پناہ مانگتا ہوں',
        translation: 'O Allah! I seek refuge in You from anxiety and sorrow.',
      ),
      Dua(
        label: 'Hard Times',
        labelBg: const Color(0xFFFAECE7),
        labelColor: const Color(0xFF993C1D),
        arabic: 'حَسْبِيَ اللَّهُ لَا إِلَهَ إِلَّا هُوَ',
        urdu: 'مجھے اللہ کافی ہے، اس کے سوا کوئی معبود نہیں',
        translation: 'Allah is sufficient for me; there is no god but He.',
      ),
      Dua(
        label: 'Freedom from Debt',
        labelBg: const Color(0xFFE6F1FB),
        labelColor: const Color(0xFF185FA5),
        arabic: 'اللَّهُمَّ اكْفِنِي بِحَلَالِكَ عَنْ حَرَامِكَ',
        urdu: 'اے اللہ! مجھے اپنے حلال سے حرام سے بے نیاز فرما',
        translation: 'O Allah! Suffice me with what is lawful instead of what is forbidden.',
      ),
      Dua(
        label: 'In Pain or Distress',
        labelBg: const Color(0xFFEEEDFE),
        labelColor: const Color(0xFF534AB7),
        arabic: 'لَا إِلَهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِينَ',
        urdu: 'تیرے سوا کوئی معبود نہیں، تو پاک ہے',
        translation: 'None has the right to be worshipped but You, Glory be to You, I have been among the wrongdoers.',
      ),
      Dua(
        label: 'During Illness',
        labelBg: const Color(0xFFE1F5EE),
        labelColor: const Color(0xFF0F6E56),
        arabic: 'اللَّهُمَّ رَبَّ النَّاسِ أَذْهِبِ الْبَأْسَ',
        urdu: 'اے اللہ! لوگوں کے رب، تکلیف دور فرما',
        translation: 'O Allah, Lord of mankind, remove the hardship.',
      ),
    ],
  ),
];



class SubjectsScreen extends StatelessWidget {
  const SubjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.all(16),
          child: Column(
            children: [
               SizedBox(height: getHeight(16)),

              // Grid
              Expanded(
                child: GridView.builder(
                  itemCount: subjects.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.2,
                  ),
                  itemBuilder: (context, index) {
                    final subject = subjects[index];
                    return SubjectCard(subject: subject);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// ─── Subject Card ──────────────────────────────
class SubjectCard extends StatelessWidget {
  final Subject subject;
  const SubjectCard({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DuasScreen(subject: subject)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE0E0E0)),
          boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.25),
        offset: const Offset(0, 1),
        blurRadius: 4,
        spreadRadius: 0,
      ),
    ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(subject.icon, style:  TextStyle(fontSize: getFont(32))),
             SizedBox(height: getHeight(8)),
            Text(
              subject.name,
              style: AppColors().customTextStyleBold16().copyWith(
                fontSize: getFont(18)
              )
            ),
             SizedBox(height: getHeight(4)),
            Text(
              '${subject.duas.length} duaein',
              style:  AppColors().customTextStyle14(
                color: Color(0xFF888888),
              ).copyWith(
                fontSize: getFont(12)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// ─── Duas Screen ────────────────────────────
class DuasScreen extends StatelessWidget {
  final Subject subject;
  const DuasScreen({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
        //   onPressed: () => Navigator.pop(context),
        // ),
        centerTitle: true,
        title: Text(
          '${subject.icon} ${subject.name} of Duas ',
          style:AppColors().customTextStyleBold16().copyWith(
            fontSize: getFont(16),
          ),
    
        ),
         bottom: PreferredSize(
    preferredSize: const Size.fromHeight(0.12),
    child: Container(
      color: const Color(0xFF6B7678),
      height: 0.12,
    ),
  ),
      ),
      body: SafeArea(
        child: ListView(
          padding:  EdgeInsets.all(16),
          children: [
            // Subtitle
            Text(
              subject.subtitle,
              style:AppColors().customTextStyle14(
                color: Color(0xFF666666),
              ).copyWith(
                fontSize: getFont(12)
              )
            ),
             SizedBox(height: getHeight(16)),
            // Dua Cards
            ...subject.duas.map(
                  (dua) => Padding(
                padding:  EdgeInsets.only(bottom: getHeight(12)),
                child: DuaCard(dua: dua),
              ),
            ),
          ],
        ),
      ),
    );
  }
}