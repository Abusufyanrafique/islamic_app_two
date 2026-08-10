import 'package:flutter/material.dart';
import 'package:local_notification/Utils/Constants/AllColors.dart';
import 'package:local_notification/Utils/Constants/CustomButton.dart';
import '../../Utils/Constants/CustomTextFormField.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Utils/Constants/SizeConfig.dart';

// --- Events ---
abstract class ZakatEvent {}
class CalculateZakatEvent extends ZakatEvent {
  final String savings;
  final String gold;
  final String vehicle;
  final String debt;

  CalculateZakatEvent({
    required this.savings,
    required this.gold,
    required this.vehicle,
    required this.debt,
  });
}

// --- State ---
class ZakatState {
  final double zakatAmount;
  ZakatState({this.zakatAmount = 0.0});
}

// --- BLoC ---
class ZakatBloc extends Bloc<ZakatEvent, ZakatState> {
  ZakatBloc() : super(ZakatState()) {
    on<CalculateZakatEvent>((event, emit) {
      num savings = _parseValue(event.savings);
      num goldValue = _parseValue(event.gold);
      num vehicleValue = _parseValue(event.vehicle);
      num debts = _parseValue(event.debt);

      num totalAssets = savings + goldValue + vehicleValue;
      num netAmount = totalAssets - debts;

      double result = 0.0;
      if (netAmount > 0) {
        result = (netAmount * 0.025).toDouble();
      }

      emit(ZakatState(zakatAmount: result));
    });
  }

  num _parseValue(String value) {
    if (value.isEmpty) return 0;
    value = value.replaceAll(",", "");
    return num.tryParse(value) ?? 0;
  }
}

class ZakatScreen extends StatelessWidget {
  ZakatScreen({super.key});

  // Controllers ko class level par rakha gaya hai
  final TextEditingController saving = TextEditingController();
  final TextEditingController gold = TextEditingController();
  final TextEditingController vehicle = TextEditingController();
  final TextEditingController debt = TextEditingController();

  final List<TextInputFormatter> numberFormatter = [
    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
  ];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocProvider(
      create: (context) => ZakatBloc(),
      child: Scaffold(
       appBar: AppBar(
  title: Text(
    "Zakat Calculator",
    style: AppColors().customTextStyle15().copyWith(
      color: AppColors.black,
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
        body: BlocBuilder<ZakatBloc, ZakatState>(
          builder: (context, state) {
            // Helper function to trigger calculation
            void triggerCalc() {
              context.read<ZakatBloc>().add(CalculateZakatEvent(
                savings: saving.text,
                gold: gold.text,
                vehicle: vehicle.text,
                debt: debt.text,
              ));
            }

            return SingleChildScrollView(
              padding:  EdgeInsets.symmetric(
                horizontal: getWidth(16), 
                vertical: getHeight(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   SizedBox(height: getHeight(30)),

                  /// Savings
                  CustomTextField(
                    titleController: saving,
                    title: 'Value of savings, deposits, checking accounts',
                    hinttext: '0.00',
                    line: 1,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: numberFormatter,
                    onChanged: (value) => triggerCalc(),
                  ),

                   SizedBox(height: getHeight(10)),

                  /// Vehicle / Property
                  CustomTextField(
                    titleController: vehicle,
                    title: 'Value of vehicle and properties',
                    hinttext: '0.00',
                    line: 1,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: numberFormatter,
                    onChanged: (value) => triggerCalc(),
                  ),

                   SizedBox(height: getHeight(10)),

                  /// Gold
                  CustomTextField(
                    titleController: gold,
                    title: 'Value of gold, silver, gems',
                    hinttext: '0.00',
                    line: 1,
                    
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: numberFormatter,
                    onChanged: (value) => triggerCalc(),
                  ),

                   SizedBox(height: getHeight(20)),

                  /// Result Title
                   Text("Total Zakat"),

                   SizedBox(height: getHeight(8)),

                  /// Result Box
                  Container(
                    height: getHeight(50),
                    padding:  EdgeInsets.symmetric(
                      horizontal: getWidth(10),
                       vertical: getHeight(8)),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          offset: const Offset(0, 1),
                          blurRadius: 4,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        state.zakatAmount.toStringAsFixed(2),
                        style: AppColors().customTextStyle18(color: AppColors.primaryColor),
                      ),
                    ),
                  ),

                   SizedBox(height: getHeight(50)),

                  /// Button
                  CustomButton(
                    onTap: triggerCalc,
                    title: "Zakat Calculator",
                    backgroundColor:Color(0xFF56C8C8)
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}











// class ZakatScreen extends StatefulWidget {
//   const ZakatScreen({super.key});
//
//   @override
//   State<ZakatScreen> createState() => _ZakatScreenState();
// }
//
// class _ZakatScreenState extends State<ZakatScreen> {
//   TextEditingController saving = TextEditingController();
//   TextEditingController gold = TextEditingController();
//   TextEditingController vehicle = TextEditingController();
//   TextEditingController debt = TextEditingController();
//
//   double zakatAmount = 0;
//
//   /// ✅ Safe Parsing Function (handles big numbers + commas)
//   num parseValue(String value) {
//     if (value.isEmpty) return 0;
//
//     value = value.replaceAll(",", ""); // remove commas
//
//     return num.tryParse(value) ?? 0;
//   }
//
//   /// ✅ Zakat Calculation
//   void calculateZakat() {
//     num savings = parseValue(saving.text);
//     num goldValue = parseValue(gold.text);
//     num vehicleValue = parseValue(vehicle.text);
//     num debts = parseValue(debt.text);
//
//     num totalAssets = savings + goldValue + vehicleValue;
//     num netAmount = totalAssets - debts;
//
//     setState(() {
//       if (netAmount > 0) {
//         zakatAmount = (netAmount * 0.025).toDouble();
//       } else {
//         zakatAmount = 0;
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     saving.dispose();
//     gold.dispose();
//     vehicle.dispose();
//     debt.dispose();
//     super.dispose();
//   }
//
//   /// ✅ Common Input Formatter
//   List<TextInputFormatter> numberFormatter = [
//     FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Zakat Calculator"),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 30),
//
//             /// Savings
//             CustomTextField(
//               titleController: saving,
//               title: 'Value of savings, deposits, checking accounts',
//               hinttext: '0.00',
//               line: 1,
//               keyboardType:
//               const TextInputType.numberWithOptions(decimal: true),
//               inputFormatters: numberFormatter,
//               onChanged: (value) => calculateZakat(),
//             ),
//
//             const SizedBox(height: 10),
//
//             /// Vehicle / Property
//             CustomTextField(
//               titleController: vehicle,
//               title: 'Value of vehicle and properties',
//               hinttext: '0.00',
//               line: 1,
//               keyboardType:
//               const TextInputType.numberWithOptions(decimal: true),
//               inputFormatters: numberFormatter,
//               onChanged: (value) => calculateZakat(),
//             ),
//
//             const SizedBox(height: 10),
//
//             /// Gold
//             CustomTextField(
//               titleController: gold,
//               title: 'Value of gold, silver, gems',
//               hinttext: '0.00',
//               line: 1,
//               keyboardType:
//               const TextInputType.numberWithOptions(decimal: true),
//               inputFormatters: numberFormatter,
//               onChanged: (value) => calculateZakat(),
//             ),
//
//
//             const SizedBox(height: 20),
//
//             /// Result Title
//             const Text("Total Zakat"),
//
//             const SizedBox(height: 8),
//
//             /// Result Box
//             Container(
//               height: getHeight(50),
//               padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.25),
//                     offset: const Offset(0, 1),
//                     blurRadius: 4,
//                   ),
//                 ],
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Center(
//                 child: Text(
//                   " ${zakatAmount.toStringAsFixed(2)}",
//                   style:  AppColors().customTextStyle18(color: AppColors.primaryColor)
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 50),
//
//             /// Button
//             CustomButton(
//               ontap: calculateZakat,
//               title: "Calculate Zakat",
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

