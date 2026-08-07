// ignore: file_names
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


// class shimmerUi{
//   Widget _buildCategoryShimmer() {
//     return SizedBox(
//       height: getHeight(110),
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: 6,
//         padding: EdgeInsets.symmetric(horizontal: getWidth(16)),
//         itemBuilder: (context, index) {
//           return Padding(
//               padding: EdgeInsets.only(right: getWidth(17)),
//               child: Column(
//                 children: [
//                   AppShimmer(
//                     width: getWidth(62),
//                     height: getHeight(62),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   SizedBox(height: getHeight(10)),
//                   AppShimmer(
//                     width: getWidth(45),
//                     height: getHeight(10),
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                 ],
//               ));
//         },
//       ),
//     );
//
//   }
// }




class AppShimmer extends StatelessWidget {
  final double width;
  final double? height;
  final BorderRadius? borderRadius;
  final EdgeInsets? margin;

  const AppShimmer({
    super.key,
    required this.width,
    this.height,
    this.borderRadius,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Shimmer.fromColors(
        baseColor: const Color(0xFFE0E0E0),       // Light grey
        highlightColor: const Color(0xFFF5F5F5),  // Slightly lighter
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: borderRadius ?? BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}