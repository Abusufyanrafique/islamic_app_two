import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_notification/Utils/Constants/AllColors.dart';
import 'package:local_notification/Utils/Constants/SizeConfig.dart';

class TasbihModel {
  final int id;
  final String arabic;
  final String english;
  final String urdu;

  TasbihModel({
    required this.id,
    required this.arabic,
    required this.english,
    required this.urdu,
  });
}

// --- Events ---
abstract class TasbihEvent {}

class SelectTasbih extends TasbihEvent {
  final int index;
  SelectTasbih(this.index);
}

class IncrementCount extends TasbihEvent {}

class ResetCount extends TasbihEvent {
  final int index;
  ResetCount(this.index);
}

// Fired once when saved counts are loaded from local storage on app start.
class LoadCounts extends TasbihEvent {
  final List<int> counts;
  LoadCounts(this.counts);
}

// --- State ---
class TasbihState {
  final int selectedIndex;
  final List<int> counts;

  TasbihState({required this.selectedIndex, required this.counts});

  TasbihState copyWith({int? selectedIndex, List<int>? counts}) {
    return TasbihState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      counts: counts ?? this.counts,
    );
  }
}

// --- Local storage helper (SharedPreferences) ---
class TasbihLocalStorage {
  static const String _countsKey = 'tasbih_counts';

  // Save the full counts list as a JSON string.
  static Future<void> saveCounts(List<int> counts) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_countsKey, jsonEncode(counts));
  }

  // Load counts list; returns null if nothing saved yet.
  static Future<List<int>?> loadCounts() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_countsKey);
    if (saved == null) return null;
    final List<dynamic> decoded = jsonDecode(saved);
    return decoded.map((e) => e as int).toList();
  }
}

// --- BLoC ---
class TasbihBloc extends Bloc<TasbihEvent, TasbihState> {
  final int listLength;

  TasbihBloc(this.listLength)
      : super(TasbihState(
          selectedIndex: -1,
          counts: List<int>.generate(listLength, (index) => 0),
        )) {
    // Load saved counts from local storage as soon as the bloc is created.
    _loadSavedCounts();

    on<LoadCounts>((event, emit) {
      emit(state.copyWith(counts: event.counts));
    });

    on<SelectTasbih>((event, emit) {
      emit(state.copyWith(selectedIndex: event.index));
    });

    on<IncrementCount>((event, emit) async {
      if (state.selectedIndex != -1) {
        List<int> newCounts = List.from(state.counts);
        newCounts[state.selectedIndex]++;
        emit(state.copyWith(counts: newCounts));
        // Persist immediately so nothing is lost if the app is closed.
        await TasbihLocalStorage.saveCounts(newCounts);
      }
    });

    on<ResetCount>((event, emit) async {
      List<int> newCounts = List.from(state.counts);
      newCounts[event.index] = 0;
      emit(state.copyWith(counts: newCounts));
      // Persist the reset so it's remembered too.
      await TasbihLocalStorage.saveCounts(newCounts);
    });
  }

  Future<void> _loadSavedCounts() async {
    final saved = await TasbihLocalStorage.loadCounts();
    if (saved != null && saved.length == listLength) {
      add(LoadCounts(saved));
    }
  }
}

class TasbihScreen extends StatelessWidget {
  const TasbihScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<TasbihModel> tasbihList = [
      TasbihModel(id: 1, arabic: "سُبْحَانَ ٱللَّٰهِ", english: "Glory be to Allah", urdu: "اللہ پاک ہے"),
      TasbihModel(id: 2, arabic: "ٱلْحَمْدُ لِلَّٰهِ", english: "All praise is for Allah", urdu: "تمام تعریفیں اللہ کے لیے ہیں"),
      TasbihModel(id: 3, arabic: "ٱللَّٰهُ أَكْبَرُ", english: "Allah is the Greatest", urdu: "اللہ سب سے بڑا hai"),
      TasbihModel(id: 4, arabic: "لَا إِلَٰهَ إِلَّا ٱللَّٰهُ", english: "There is no god but Allah", urdu: "اللہ کے سوا کوئی معبود نہیں"),
      TasbihModel(id: 5, arabic: "أَسْتَغْفِرُ ٱللَّٰهَ", english: "I seek forgiveness from Allah", urdu: "میں اللہ سے معافی مانگتا ہوں"),
      TasbihModel(id: 6, arabic: "سُبْحَانَ ٱللَّٰهِ وَبِحَمْدِهِ", english: "Glory be to Allah and praise Him", urdu: "اللہ پاک ہے اور اسی کے لیے حمد ہے"),
      TasbihModel(id: 7, arabic: "سُبْحَانَ ٱللَّٰهِ ٱلْعَظِيمِ", english: "Glory be to Allah, the Most Great", urdu: "اللہ پاک ہے، جو بہت عظمت والا ہے"),
      TasbihModel(id: 8, arabic: "رَبِّ ٱغْفِرْ لِي", english: "My Lord, forgive me", urdu: "اے میرے رب! مجھے بخش دے"),
      TasbihModel(id: 9, arabic: "ٱللَّهُمَّ ٱغْفِرْ لِي", english: "O Allah, forgive me", urdu: "اے اللہ! مجھے معاف فرما دے"),
      TasbihModel(id: 10, arabic: "ٱللَّهُمَّ ٱرْحَمْنِي", english: "O Allah, have mercy on me", urdu: "اے اللہ! مجھ پر رحم فرما"),
    ];

    return BlocProvider(
      create: (context) => TasbihBloc(tasbihList.length),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          title: Text(
            "Tasbih Counter",
            style: AppColors().customTextStyleBold16().copyWith(
                  fontSize: getFont(16),
                ),
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
        body: Padding(
          padding: EdgeInsets.all(16),
          child: BlocBuilder<TasbihBloc, TasbihState>(
            builder: (context, state) {
              return Column(
                children: [
                  SizedBox(height: getHeight(10)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: tasbihList.length,
                      itemBuilder: (context, index) {
                        final item = tasbihList[index];
                        final bool isSelected = state.selectedIndex == index;

                        return Padding(
                          padding: EdgeInsets.only(bottom: getHeight(12)),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => context.read<TasbihBloc>().add(SelectTasbih(index)),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: isSelected ? 
                                      const Color(0xffE0F7F6) : Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.08),
                                          blurRadius: 8,
                                          spreadRadius: 1,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: [
                                            Text("${state.counts[index]}",
                                                style: AppColors().customTextStyleBold16(
                                                  color: AppColors.black,
                                                )),
                                            Text("Count",
                                                style: AppColors().customTextStyle14(
                                                  color: Color(0xFF636366),
                                                )),
                                          ],
                                        ),
                                        SizedBox(width: getWidth(16)),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(item.arabic,
                                                  textDirection: TextDirection.rtl,
                                                  style: TextStyle(
                                                      fontSize: getFont(20),
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xff5BC0BE),
                                                      fontFamily: 'Amiri')),
                                              SizedBox(height: getHeight(4)),
                                              Text(item.english,
                                                  style: AppColors().customTextStyle14().copyWith(
                                                        fontSize: getFont(12),
                                                      )),
                                              SizedBox(height: getHeight(2)),
                                              Text(item.urdu,
                                                  textDirection: TextDirection.rtl,
                                                  style: AppColors().customTextStyle14().copyWith(
                                                        fontSize: getFont(12),
                                                      )),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: getWidth(10)),
                              GestureDetector(
                                onTap: () => context.read<TasbihBloc>().add(ResetCount(index)),
                                child: Container(
                                  height: getHeight(70),
                                  width: getWidth(50),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.08),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(Icons.refresh),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: getHeight(20)),

                  // Selected Tasbih Card
                  Container(
                    height: getHeight(150),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: state.selectedIndex == -1
                          ? const Text("Select Tasbih")
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(tasbihList[state.selectedIndex].arabic,
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                        fontSize: getFont(22),
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff5BC0BE),
                                        fontFamily: 'Amiri')),
                                SizedBox(height: getHeight(4)),
                                Text(
                                  tasbihList[state.selectedIndex].english,
                                  style: AppColors().customTextStyle20().copyWith(fontSize: getFont(14)),
                                ),
                                SizedBox(height: getHeight(2)),
                                Text(tasbihList[state.selectedIndex].urdu, textDirection: TextDirection.rtl),
                              ],
                            ),
                    ),
                  ),
                  SizedBox(height: getHeight(20)),

                  // Counter Button
                  GestureDetector(
                    onTap: () => context.read<TasbihBloc>().add(IncrementCount()),
                    child: Container(
                      height: getHeight(50),
                      width: double.infinity,
                      decoration: BoxDecoration(color: const Color(0xff56C8C8), borderRadius: BorderRadius.circular(50)),
                      child: Center(
                        child: Text(
                          state.selectedIndex == -1 ? "Start" : "${state.counts[state.selectedIndex]}",
                          style: TextStyle(fontSize: getFont(20), color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}









// class TasbihScreen extends StatefulWidget {
//   const TasbihScreen({super.key});
//
//   @override
//   State<TasbihScreen> createState() => _TasbihScreenState();
// }
//
// class _TasbihScreenState extends State<TasbihScreen> {
//   int selectedIndex = -1;
//   late List<int> counts;
//
//   final List<TasbihModel> tasbihList = <TasbihModel>[
//     TasbihModel(
//       id: 1,
//       arabic: "سُبْحَانَ ٱللَّٰهِ",
//       english: "Glory be to Allah",
//       urdu: "اللہ پاک ہے",
//     ),
//     TasbihModel(
//       id: 2,
//       arabic: "ٱلْحَمْدُ لِلَّٰهِ",
//       english: "All praise is for Allah",
//       urdu: "تمام تعریفیں اللہ کے لیے ہیں",
//     ),
//     TasbihModel(
//       id: 3,
//       arabic: "ٱللَّٰهُ أَكْبَرُ",
//       english: "Allah is the Greatest",
//       urdu: "اللہ سب سے بڑا ہے",
//     ),
//     TasbihModel(
//       id: 4,
//       arabic: "لَا إِلَٰهَ إِلَّا ٱللَّٰهُ",
//       english: "There is no god but Allah",
//       urdu: "اللہ کے سوا کوئی معبود نہیں",
//     ),
//     TasbihModel(
//       id: 5,
//       arabic: "أَسْتَغْفِرُ ٱللَّٰهَ",
//       english: "I seek forgiveness from Allah",
//       urdu: "میں اللہ سے معافی مانگتا ہوں",
//     ),
//     TasbihModel(
//       id: 6,
//       arabic: "سُبْحَانَ ٱللَّٰهِ وَبِحَمْدِهِ",
//       english: "Glory be to Allah and praise Him",
//       urdu: "اللہ پاک ہے اور اسی کے لیے حمد ہے",
//     ),
//     TasbihModel(
//       id: 7,
//       arabic: "سُبْحَانَ ٱللَّٰهِ ٱلْعَظِيمِ",
//       english: "Glory be to Allah, the Most Great",
//       urdu: "اللہ پاک ہے، جو بہت عظمت والا ہے",
//     ),
//     TasbihModel(
//       id: 8,
//       arabic: "رَبِّ ٱغْفِرْ لِي",
//       english: "My Lord, forgive me",
//       urdu: "اے میرے رب! مجھے بخش دے",
//     ),
//     TasbihModel(
//       id: 9,
//       arabic: "ٱللَّهُمَّ ٱغْفِرْ لِي",
//       english: "O Allah, forgive me",
//       urdu: "اے اللہ! مجھے معاف فرما دے",
//     ),
//     TasbihModel(
//       id: 10,
//       arabic: "ٱللَّهُمَّ ٱرْحَمْنِي",
//       english: "O Allah, have mercy on me",
//       urdu: "اے اللہ! مجھ پر رحم فرما",
//     ),
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     counts = List<int>.generate(tasbihList.length, (index) => 0); // ✅ Explicit int list
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         foregroundColor: Colors.white,
//         title: const Text("Tasbih Counter",style: TextStyle(color: Colors.white),),
//         centerTitle: true,
//         backgroundColor: const Color(0xff5BC0BE),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             const SizedBox(height: 10),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: tasbihList.length,
//                 itemBuilder: (context, index) {
//                   final TasbihModel item = tasbihList[index]; // ✅ Explicit type
//                   final bool isSelected = selectedIndex == index;
//
//                   return Padding(
//                     padding: const EdgeInsets.only(bottom: 12),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 selectedIndex = index;
//                               });
//                             },
//                             child: Container(
//                               padding: const EdgeInsets.all(16),
//
//
// // Container ke andar
//                             decoration: inset.BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(16),
//                               boxShadow: [
//                                 // 1. Drop Shadow (Outer)
//                                 inset.BoxShadow(
//                                   color: Colors.grey.withOpacity(0.2),
//                                   blurRadius: 1,
//                                   offset: const Offset(0, 1),
//                                 ),
//                                 // 2. Inner Shadow (Inset)
//                                 inset.BoxShadow(
//                                   offset: const Offset(0, 1),
//                                   blurRadius: 1,
//                                   color: Colors.grey.withOpacity(0.2),
//                                   inset: true, // Yeh property inner shadow banati hai
//                                 ),
//                               ],
//                             ),
//                               // decoration: BoxDecoration(
//                               //   color: isSelected
//                               //       ? const Color(0xffE0F7F6)
//                               //       : Colors.white,
//                               //   borderRadius: BorderRadius.circular(16),
//                               //   boxShadow: [
//                               //     BoxShadow(
//                               //       color: Colors.grey.withOpacity(0.2),
//                               //       blurRadius: 4,
//                               //
//                               //       offset:  Offset(1, 1)
//                               //     )
//                               //   ],
//                               // ),
//                               child: Row(
//                                 children: [
//                                   // ✅ Counter
//                                   Column(
//                                     children: [
//                                       Text(
//                                         "${counts[index]}",
//                                         style: const TextStyle(
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       const Text(
//                                         "Count",
//                                         style: TextStyle(
//                                           fontSize: 12,
//                                           color: Colors.grey,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(width: 16),
//                                   // ✅ Arabic + English + Urdu
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                       CrossAxisAlignment.end,
//                                       children: [
//                                         Text(
//                                           item.arabic,
//                                           textDirection: TextDirection.rtl,
//                                           style: const TextStyle(
//                                             fontSize: 20,
//                                             fontWeight: FontWeight.bold,
//                                             color: Color(0xff5BC0BE),
//                                             fontFamily: 'Amiri',
//                                           ),
//                                         ),
//                                         const SizedBox(height: 4),
//                                         Text(
//                                           item.english,
//                                           style: const TextStyle(
//                                               fontSize: 12,
//                                               color: Colors.grey),
//                                         ),
//                                         const SizedBox(height: 2),
//                                         Text(
//                                           item.urdu,
//                                           textDirection: TextDirection.rtl,
//                                           style: const TextStyle(
//                                               fontSize: 13,
//                                               color: Colors.black87),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         // ✅ Reset Button
//                         GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               counts[index] = 0;
//                             });
//                           },
//                           child: Container(
//                             height: 70,
//                             width: 40,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(color: Colors.grey.shade300),
//                             ),
//                             child: const Icon(Icons.refresh),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//             const SizedBox(height: 20),
//
//             // ✅ Selected Tasbih Card
//             Container(
//               height: 150,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.2),
//                     blurRadius: 6,
//                   )
//                 ],
//               ),
//               child: Center(
//                 child: selectedIndex == -1
//                     ? const Text("Select Tasbih")
//                     : Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       tasbihList[selectedIndex].arabic,
//                       textDirection: TextDirection.rtl,
//                       style: const TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xff5BC0BE),
//                         fontFamily: 'Amiri',
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(tasbihList[selectedIndex].english),
//                     const SizedBox(height: 2),
//                     Text(
//                       tasbihList[selectedIndex].urdu,
//                       textDirection: TextDirection.rtl,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//
//             // ✅ Counter Button
//             GestureDetector(
//               onTap: () {
//                 if (selectedIndex != -1) {
//                   setState(() {
//                     counts[selectedIndex]++;
//                   });
//                 }
//               },
//               child: Container(
//                 height: 50,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: const Color(0xff5BC0BE),
//                   borderRadius: BorderRadius.circular(50),
//                 ),
//                 child: Center(
//                   child: Text(
//                     selectedIndex == -1
//                         ? "Start"
//                         : "${counts[selectedIndex]}",
//                     style: const TextStyle(
//                       fontSize: 20,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }

