import 'package:flutter/material.dart';
import 'package:local_notification/Utils/Constants/SizeConfig.dart';



class CustomBackgroundWrapper extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;

  const CustomBackgroundWrapper({
    super.key, 
    required this.child, 
    this.appBar,
    });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. Extend body taake image poori screen pr aye
      extendBodyBehindAppBar: true,
      appBar: appBar,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // Top Right Image
            Positioned(
              top: 0,
              right: 0,
              child: Image.asset(
                'assets/your_image.png',
                width: getWidth(180),
                opacity: const AlwaysStoppedAnimation(0.2), // Light background
              ),
            ),
            // Bottom Left Image
            Positioned(
              bottom: 0,
              left: 0,
              child: Image.asset(
                'assets/your_image.png',
                width: getWidth(180),
                opacity: const AlwaysStoppedAnimation(0.2),
              ),
            ),
            // Asal Content
            // 2. Isay "Positioned.fill" karein taake list ko poori jagah mile
            Positioned.fill(
              child: SafeArea(
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// class CustomBackgroundWrapper extends StatelessWidget {
//   final Widget child;
//   final PreferredSizeWidget? appBar; // AppBar ko handle karne ke liye
//
//   const CustomBackgroundWrapper({super.key, required this.child, this.appBar});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true, // Takay images AppBar ke niche se shuru hon
//       appBar: appBar,
//       body: Stack(
//         children: [
//           // Top Right Image
//           Positioned(
//             top: 0,
//             right: 0,
//             child: Image.asset(
//               AllImages.bottomflower, // Aapki image ka path
//               width: 180,
//               opacity: const AlwaysStoppedAnimation(0.3), // Light background
//             ),
//           ),
//           // Bottom Left Image
//           Positioned(
//             bottom: 0,
//             left: 0,
//             child: Image.asset(
//               AllImages.bottomflower,
//               width: 180,
//               opacity: const AlwaysStoppedAnimation(0.3),
//             ),
//           ),
//           // Asal Content
//           SafeArea(
//             child: child,
//           ),
//         ],
//       ),
//     );
//   }
// }
var g =4;
// class CustomBackgroundWrapper extends StatelessWidget {
//   final Widget child;
//
//   const CustomBackgroundWrapper({super.key, required this.child});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // ResizeToAvoidBottomInset true rakhein taake keyboard khulne pr error na aaye
//       resizeToAvoidBottomInset: true,
//       body: Stack(
//         children: [
//           // --- Background Images (Fix rahengi) ---
//
//           // Top Right Image
//           Positioned(
//             top: -20, // Thora screen se bahar nikalne ke liye
//             right: -20,
//             child: Opacity(
//               opacity: 0.5, // Background ko thora light rakhein taake list saaf dikhe
//               child: Image.asset(
//                 AllImages.backflower,
//                 //'assets/background_pattern.png',
//                 width: MediaQuery.of(context).size.width * 0.5, // 50% screen width
//               ),
//             ),
//           ),
//
//           // Bottom Left Image
//           Positioned(
//             bottom: -20,
//             left: -20,
//             child: Opacity(
//               opacity: 0.5,
//               child: Image.asset(
//                 AllImages.backflower,
//                 width: MediaQuery.of(context).size.width * 0.5,
//               ),
//             ),
//           ),
//
//           // --- Screen Content (List ya koi bhi UI) ---
//           // SafeArea lazmi hai taake content corners mein na phanse
//           SafeArea(
//             child: SizedBox.expand(child: child),
//           ),
//         ],
//       ),
//     );
//   }
// }