import 'package:flutter/material.dart';
import 'package:islamic_hijri_calendar/islamic_hijri_calendar.dart';
import 'package:local_notification/Utils/Constants/AllColors.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_notification/Utils/Constants/SizeConfig.dart';

class IslamicCalendarState {
  final String selectedEnglishDate;
  final String selectedHijriDate;

  IslamicCalendarState({
    this.selectedEnglishDate = '',
    this.selectedHijriDate = '',
  });
}

class IslamicCalendarCubit extends Cubit<IslamicCalendarState> {
  IslamicCalendarCubit() : super(IslamicCalendarState());

  // Dates update karne ka function
  void updateDates(String engDate, String hijriDate) {
    emit(IslamicCalendarState(
      selectedEnglishDate: engDate,
      selectedHijriDate: hijriDate,
    ));
  }
}




class IslamicCalendar extends StatelessWidget {
  const IslamicCalendar({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => IslamicCalendarCubit(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title:  Text(
            "Islamic Calendar",
             style: AppColors().customTextStyleBold16().copyWith(
              fontSize: getFont(20)
             ),
          ),
        ),
        body: BlocBuilder<IslamicCalendarCubit, IslamicCalendarState>(
          builder: (context, state) {
            return IslamicHijriCalendar(
              isHijriView: true,
              highlightBorder: AppColors.primaryColor,
              defaultBorder: Theme.of(context).colorScheme.onBackground.withOpacity(.1),
              highlightTextColor: Theme.of(context).colorScheme.background,
              defaultTextColor: Theme.of(context).colorScheme.onBackground,
              defaultBackColor: Theme.of(context).colorScheme.background,
              adjustmentValue: 0,
              isGoogleFont: true,
              fontFamilyName: "Lato", // Styling mein koi tabdeeli nahi ki
              getSelectedEnglishDate: (selectedDate) {
                context.read<IslamicCalendarCubit>().updateDates(
                  selectedDate.toString(),
                  state.selectedHijriDate,
                );
                print("English Date : $selectedDate");
              },
              getSelectedHijriDate: (selectedDate) {
                context.read<IslamicCalendarCubit>().updateDates(
                  state.selectedEnglishDate,
                  selectedDate.toString(),
                );
                print("Hijri Date : $selectedDate");
              },
              isDisablePreviousNextMonthDates: true,
            );
          },
        ),
      ),
    );
  }
}

