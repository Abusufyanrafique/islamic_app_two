import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_notification/Utils/Constants/AllColors.dart';
import 'package:local_notification/Utils/Constants/AllImages.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:local_notification/Utils/Constants/SizeConfig.dart';

import '../../Utils/Constants/userFeedback.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


// --- Events ---
abstract class RamadanEvent {}
class FetchRamadanData extends RamadanEvent {}

// --- State ---
abstract class RamadanState {}
class RamadanLoading extends RamadanState {}
class RamadanLoaded extends RamadanState {
  final List<dynamic> ramadanList;
  RamadanLoaded(this.ramadanList);
}
class RamadanError extends RamadanState {
  final String message;
  RamadanError(this.message);
}

// --- BLoC ---
class RamadanBloc extends Bloc<RamadanEvent, RamadanState> {
  RamadanBloc() : super(RamadanLoading()) {
    on<FetchRamadanData>((event, emit) async {
      emit(RamadanLoading());
      try {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.low);
        final year = DateTime.now().year;
        final url = 'https://api.aladhan.com/v1/calendar/$year'
            '?latitude=${position.latitude}'
            '&longitude=${position.longitude}'
            '&method=1';

        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseBody = jsonDecode(response.body);
          final Map<String, dynamic> monthsData = responseBody['data'];
          List<dynamic> ramadanDays = [];

          monthsData.forEach((monthIndex, days) {
            for (var day in days) {
              if (day['date']['hijri']['month']['number'] == 9) {
                ramadanDays.add(day);
              }
            }
          });
          emit(RamadanLoaded(ramadanDays));
        } else {
          emit(RamadanError('Server error: ${response.statusCode}'));
        }
      } catch (e) {
        emit(RamadanError('Data loading mein masla: $e'));
      }
    });
  }
}

class RamadanScreen extends StatelessWidget {
  const RamadanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Current year for the UI
    final year = DateTime.now().year;

    return BlocProvider(
      create: (context) => RamadanBloc()..add(FetchRamadanData()),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<RamadanBloc, RamadanState>(
          builder: (context, state) {
            if (state is RamadanLoading) {
              return Center(child: spinkit);
            } else if (state is RamadanError) {
              return Center(child: Text("Error: ${state.message}"));
            } else if (state is RamadanLoaded) {
              final ramadanList = state.ramadanList;

              return CustomScrollView(
                slivers: [
                
                  SliverAppBar(
                    expandedHeight: 180,
                    pinned: true,
                    centerTitle: true,
                    elevation: 0,
                    scrolledUnderElevation: 0,
                    surfaceTintColor: Colors.transparent,
                    title:  Text(
                      "Ramadan",
                      style: AppColors().customTextStyleBold16()
                    ),
                    actions: const [
                      Icon(Icons.more_vert, 
                      color: Colors.black,
                      )],
                    flexibleSpace: FlexibleSpaceBar(
                      expandedTitleScale: 1,
                      centerTitle: true,
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            AllImages.ramzanbackground,
                            fit: BoxFit.cover,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                               SizedBox(height: getHeight(40)),
                              Text(
                                "Ramadan $year",
                                style:AppColors().customTextStyleBold10().copyWith(
                                  fontSize: getFont(20)
                                ) 
                              ),
                               SizedBox(height: getHeight(8),),
                               Text(
                                "Sehri and Iftar Alerts",
                                style: AppColors().customTextStyleBold16()
                              ),
                              SizedBox(height: getHeight(6),),
                              Text(
                                "Calender: ${ramadanList[0]['date']['readable']}",
                               style: AppColors().customTextStyle14().copyWith(
                                fontSize: getFont(16),
                               )
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                  /// 🔹 Header Row
                  SliverToBoxAdapter(
                    child: Padding(
                      padding:  EdgeInsets.all(12),
                      child: Container(
                        padding:  EdgeInsets.symmetric(
                          horizontal: getWidth(16), 
                          vertical: getHeight(14)),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.primaryColor),
                        ),
                        child:  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Fast", 
                            style: AppColors().customTextStyle18().copyWith(
                              fontSize: getFont(16),
                            )),
                            Text("Sehri",
                             style: AppColors().customTextStyle18().copyWith(
                              fontSize: getFont(16),
                            )),
                            Text("Iftar",
                             style: AppColors().customTextStyle18().copyWith(
                              fontSize: getFont(16),
                            )),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final day = ramadanList[index];
                        final timings = day['timings'];
                        final hijriDay = day['date']['hijri']['day'];

                        String sehri = timings['Fajr'].split(' ')[0];
                        String iftar = timings['Maghrib'].split(' ')[0];

                        return Padding(
                          padding:  EdgeInsets.symmetric(
                            horizontal: getWidth(12), 
                            vertical:getHeight(4)),
                          child: Container(
                            padding:  EdgeInsets.symmetric(
                              horizontal: getWidth(18),
                               vertical: getHeight(8)),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 6,
                                )
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SvgPicture.asset(AllImages.numcover),
                                    Text(
                                      "$hijriDay",
                                      style:  TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: getFont(12),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  sehri, 
                                  style: AppColors().customTextStyle14()),
                                Text(
                                  iftar, 
                                  style: AppColors().customTextStyle14(),),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: ramadanList.length,
                    ),
                  ),

                   SliverToBoxAdapter(child: SizedBox(height: getHeight(20))),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}


