import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_notification/Utils/Constants/SizeConfig.dart';
import '../../AllApiLink/AllApiLink.dart';
import '../../Model/AllahNameModel.dart';
import '../../Utils/Constants/AllColors.dart';
import '../../Utils/Constants/AllImages.dart';
import '../../Utils/Constants/userFeedback.dart';

abstract class AllahNamesEvent {}

class FetchAllahNames extends AllahNamesEvent {}
abstract class AllahNamesState {}

class AllahNamesInitial extends AllahNamesState {}

class AllahNamesLoading extends AllahNamesState {}

class AllahNamesLoaded extends AllahNamesState {
  final AllahNameModel model;

  AllahNamesLoaded(this.model);
}

class AllahNamesError extends AllahNamesState {
  final String message;

  AllahNamesError(this.message);
}


class AllahNamesBloc extends Bloc<AllahNamesEvent, AllahNamesState> {
  AllahNamesBloc() : super(AllahNamesInitial()) {
    on<FetchAllahNames>(_fetchNames);
  }

  Future<void> _fetchNames(
      FetchAllahNames event, Emitter<AllahNamesState> emit) async {
    emit(AllahNamesLoading());
    try {
      final result = await QuranApiService.fetchAllahNames();

      if (result?.data != null) {
        emit(AllahNamesLoaded(result!));
      } else {
        emit(AllahNamesError("Failed to load Names"));
      }
    } catch (e) {
      emit(AllahNamesError(e.toString()));
    }
  }
}
class AllahNamesScreen extends StatelessWidget {
  const AllahNamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AllahNamesBloc()..add(FetchAllahNames()),
      child: Scaffold(
        backgroundColor: const Color(0xffF5F5F5),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: AppColors.primaryColor,
          title:  Text(
            "99 Names of Allah",
            style: TextStyle(
              color: Colors.white,
              fontSize: getFont(18),
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<AllahNamesBloc, AllahNamesState>(
          builder: (context, state) {
            if (state is AllahNamesLoading) {
              return Center(
                child: spinkit
              );
            }

            else if (state is AllahNamesError) {
              return Center(child: Text(state.message));
            }

            else if (state is AllahNamesLoaded) {
              final allahNameModel = state.model;

              return Column(
                children: [
                  // Header Card (UNCHANGED)
                  Container(
                    width: double.infinity,
                    margin:  EdgeInsets.all(16),
                    padding:  EdgeInsets.symmetric(
                        vertical: getHeight(20),
                         horizontal: getWidth(16)),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xff5BC0BE), Color(0xff3A9E9C)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child:  Column(
                      children: [
                        Text(
                          "أَسْمَاءُ اللهِ الْحُسْنَى",
                          style: TextStyle(
                            fontSize: getFont(28),
                            color: Colors.white,
                            fontFamily: 'Amiri',
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        SizedBox(height: getHeight(8)),
                        Text(
                          "Asma ul Husna — 99 Names of Allah",
                          style: TextStyle(
                            fontSize: getFont(14),
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // List (UNCHANGED)
                  Expanded(
                    child: ListView.builder(
                      padding:  EdgeInsets.symmetric(
                        horizontal: getWidth(16),
                        ),
                      itemCount: allahNameModel.data!.length,
                      itemBuilder: (context, index) {
                        final item = allahNameModel.data![index];
                        return AllahNameCard(data: item);
                      },
                    ),
                  ),
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
class AllahNameCard extends StatelessWidget {
  final Data data;

  const AllahNameCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(
        vertical: getHeight(8),),
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
                  borderRadius: BorderRadius.circular(6),
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
                        SvgPicture.asset(AllImages.numcover),
                      //  Image.asset(AllImages.paranum, height: 40, width: 40),
                        Text(
                          "${data.number}",
                          style:  TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: getFont(14),
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
                            "${data.transliteration}",
                            style:  TextStyle(
                              fontSize: getFont(16),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                           SizedBox(height: getHeight(4)),
                          Text( data.en?.meaning ?? "",

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
                      "${data.name}",
                      style:  TextStyle(
                        fontSize: getFont(22),
                        color: Color(0xff5BC0BE),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Amiri',
                      ),
                      textDirection: TextDirection.rtl,
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



