import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'SizeConfig.dart';

class AppColors{
  static const Color primaryColor = Color(0xff56C8C8);
  // ignore: constant_identifier_names
  static const Color ContainerColor =Color(0xffF2F2F2);
  static const Color primaryGradientEnd = Color(0xA057FF);
  static const Color orange = Color(0xFFAF4227);
  static const Color lighttextcolor = Color(0xff999999);
  static const Color gradTextColor = Color(0xFF4C55FF);
  static const Color grad2TextColor = Color(0xFFFF2539);
  static const Color screenbackgroundColor = Color(0xFFD9D9D9);
  static const Color circleColor = Color(0xffF5F5F5);
  static const Color texffieldBackgroundColor =Color(0xffF5F5F5);
  static const Color primaryiconcolor = Color(0xFF29B7D6);
  static const Color lightBackgroundColor = Color(0xFFFAFAFA);
  static const Color darkBackgroundColor = Color(0xFF322EDD);
  static const Color darkModeContrastColor = Color(0xFF475569);
  static const Color textBlackColor = Color(0xFF353535);
  static const Color lightTextColor = Color(0xff999999);
  static const Color textColor = Color(0xffFFFFFF);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color successColor = Color(0xFF0C8015);
  static const Color warningColor = Color(0xFFDB930B);
  static const Color news = Color(0xFF7D4DCD);
  static const Color eye = Color(0xFF00F5FF);
  static const Color active = Color(0xFFFF8D28);
  static const Color selective = Color(0xFFFF383C);
  static const Color top = Color(0xFF34C759);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color yellow = Color(0xFF6D445);
  static const Color pink = Color(0xFFF5188C);
  static const Color brinjal = Color(0xff6366F1);

  static const Color blue = Color(0xFF3C5A9A);
  static const Color darkBlue = Color(0xFF173B68);
   static const Color labbaik = Color(0xFF2FA8B8);
   static const Color gradientcontainer = Color(0xFF29EEFC);
   static const Color resultcontainerboder= Color(0xFF2955BA);
   static const Color bellcolor = Color(0xFFE3984C);
   static const Color hinttext = Color(0xFF49454F);
  static const PaidScreenbackgroundGradientColor = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.gradTextColor,
      AppColors.pink,

    ],
    stops: [0.08, 1.0,], // ascending order
  );

  static const UploadbackgroundGradientColor = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xffCF62FD),
      Color(0xffFA7BF2)

    ],
    stops: [0.08, 1.0], // ascending order
  );
  static const backgroundGradientColor = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.primaryColor,
      AppColors.primaryGradientEnd,

    ],
    stops: [0.08, 1.0], // ascending order
  );
  static const backgroundGradientTextColor = LinearGradient(


    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      //  AppColors.gradTextColor,
      Color(0xFF5B5CFF),
      Color(0xFF9B5CFF),
      //AppColors.primaryColor,
      Color(0xFFA057FF),
    ],
  );
 
  //transform: GradientRotation(2),
  //   // begin: Alignment.topCenter,
  //   // end: Alignment.bottomCenter,
  //     begin: Alignment.centerLeft,
  //     end: Alignment.centerRight,
  //     colors: [
  //     Color(0xFF5B5CFF),
  //     Color(0xFF9B5CFF),
  // Color(0xFFB96BFF),
  //   // colors: [
  //   //   AppColors.gradTextColor,
  //   //   AppColors.primaryColor
  //   // ],
  //  // stops: [0.4, 0.5],


  TextStyle customTextStyleRegular8({
    Color color = textBlackColor,
    FontWeight fontWeight = FontWeight.w400,
  })
  {
    return GoogleFonts.poppins(
      letterSpacing: 0,
      color: color,
      fontSize: 8,
      fontWeight: fontWeight,
      height: 1,
    );

    //   TextStyle(
    //   letterSpacing: 0,
    //   fontFamily: "Poppins",
    //   color: color,
    //   fontSize: 8,
    //   fontWeight: fontWeight,
    //   height: 1,
    //
    // );
  }
  TextStyle customTextStyleRegular10({
    Color color = textBlackColor,
    FontWeight fontWeight = FontWeight.w400,
  })
  {
    return GoogleFonts.poppins(
      letterSpacing: 0,
      color: color,
      fontSize: getFont(10),
      fontWeight: fontWeight,
      height: 1,
    );
  }
  TextStyle customTextStyleBold10({
    Color color = textBlackColor,
    FontWeight fontWeight = FontWeight.w700,
  })
  {
    return GoogleFonts.poppins(
      letterSpacing: 0,
      color: color,
      fontSize: getFont(10),
      fontWeight: fontWeight,
      height: 1,
    );
  }
  TextStyle customTextStyle11({
    Color color = textBlackColor,
    FontWeight fontWeight = FontWeight.w300,
  }) {
    return GoogleFonts.poppins(
      letterSpacing: 0,
      color: color,
      fontSize: getFont(11),
      fontWeight: fontWeight,
      height: 1,
    );
  }
  TextStyle customTextStyle12({
    Color color = lighttextcolor,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    return GoogleFonts.poppins(
      letterSpacing: 0,
      color: color,
      fontSize: getFont(12),
      fontWeight: fontWeight,
      height: 1,
    );
  }
  TextStyle customTextStyle14({
    Color color = black,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return GoogleFonts.poppins(
      letterSpacing: 0,
      color: color,
      fontSize: getFont(14),
      fontWeight: fontWeight,
      height: 1,
    );
  }
  TextStyle customTextStyle15({
    Color color = textBlackColor,
    FontWeight fontWeight = FontWeight.w300,
  }) {
    return GoogleFonts.poppins(
      letterSpacing: 0,
      color: color,
      fontSize: getFont(15),
      fontWeight: fontWeight,
      height: 1,
    );
  }
  TextStyle customTextStyleBold16({
    Color color = textBlackColor,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    return GoogleFonts.poppins(
      letterSpacing: 0,
      color: color,
      fontSize: getFont(16),
      fontWeight: fontWeight,
      height: 1,
    );
  }

  TextStyle customTextStyle18({
    Color color = textBlackColor,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    return GoogleFonts.poppins(
      letterSpacing: 0,
      color: color,
      fontSize: getFont(18),
      fontWeight: fontWeight,
      height: 1,
    );
  }
  TextStyle customTextStyle20Regular({
    Color color =textBlackColor,
    FontWeight fontWeight = FontWeight.w300,
  }) {
    return GoogleFonts.poppins(
      letterSpacing: 0,
      color: color,
      fontSize: getFont(20),
      fontWeight: fontWeight,
      height: 1,
    );
  }
  TextStyle customTextStyle20({
    Color color =textBlackColor,
    FontWeight fontWeight = FontWeight.w700,
  }) {
    return GoogleFonts.poppins(
      letterSpacing: 0,
      color: color,
      fontSize: getFont(20),
      fontWeight: fontWeight,
      height: 1,
    );
  }
TextStyle customTextStyleBold800({
  Color color = textBlackColor,
  FontWeight fontWeight = FontWeight.w800,
}) {
  return GoogleFonts.poppins(
    letterSpacing: 0,
    color: color,
    fontSize: getFont(10),
    fontWeight: fontWeight,
    height: 1,
  );
}

  TextStyle customTextStyle21({
    Color color = textBlackColor,
    FontWeight fontWeight = FontWeight.w700,
  }) {
    return GoogleFonts.poppins(
      letterSpacing: 0,
      color: color,
      fontSize: getFont(21),
      fontWeight: fontWeight,
      height: 1,
    );
  }
  TextStyle customTextStyle24({
    Color color = textBlackColor,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    return GoogleFonts.poppins(
      letterSpacing: 0,
      color: color,
      fontSize: getFont(24),
      fontWeight: fontWeight,
      height: 1,
    );
  }

  TextStyle customTextStyle27({
    Color color = textBlackColor,
    FontWeight fontWeight = FontWeight.w700,
  }) {
    return GoogleFonts.poppins(
      letterSpacing: 0,
      color: color,
      fontSize: getFont(27),
      fontWeight: fontWeight,
      height: 1,
    );
  }

  TextStyle customTextStyle30Regular({
    Color color = textBlackColor,
    FontWeight fontWeight = FontWeight.w300,
  }) {
    return GoogleFonts.poppins(
      letterSpacing: 0,
      color: color,
      fontSize: getFont(30),
      fontWeight: fontWeight,
      height: 1,
    );
  }
  TextStyle customTextStyle32({
    Color color = textBlackColor,
    FontWeight fontWeight = FontWeight.w700,
  }) {
    return GoogleFonts.poppins(
      letterSpacing: 0,
      color: color,
      fontSize: getFont(32),
      fontWeight: fontWeight,
      height: 1,
    );
  }

  TextStyle customTextStyle36({
    Color color = textBlackColor,
    FontWeight fontWeight = FontWeight.w700,
  }) {
    return GoogleFonts.poppins(
      letterSpacing: 0,
      color: color,
      fontSize: getFont(36),
      fontWeight: fontWeight,
      height: 1,
    );
  }

  TextStyle customTextStyleCairo14({
    Color color = white,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return GoogleFonts.cairo(
      letterSpacing: 0,
      color: color,
      fontSize: getFont(14),
      fontWeight: fontWeight,
      height: 1,
    );
  }
  TextStyle customTextStyleCairo30({
    Color color = white,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return GoogleFonts.poppins(
      letterSpacing: 0,
      color: color,
      fontSize: getFont(30),
      fontWeight: fontWeight,
      height: 1,
    );
  }




  TextStyle customTextStyleAmiri22({
    Color color = white,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return GoogleFonts.amiri(
      letterSpacing: 0,
      color: color,
      fontSize: getFont(22),
      fontWeight: fontWeight,
      height: 1,
    );
  }

  TextStyle customTextStyleAmiri24({
    Color color = white,
    FontWeight fontWeight = FontWeight.w400,
    double height = 1,
  }) {
    return GoogleFonts.amiri(
      letterSpacing: 0,
      color: color,
      fontSize: getFont(24),
      fontWeight: fontWeight,
      height:height,
    );
  }







}






class GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Gradient gradient;

  const GradientText({
    super.key,
    required this.text,
    required this.style,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(bounds),
      child: Text(
        text,
        style: style.copyWith(color: Colors.white),
      ),
    );
  }
}





// import 'package:google_fonts/google_fonts.dart';
// import 'SizeConfig.dart';
//
// class AppColors{
//   static const Color screenbackgroundColor = Color(0xFFE3EAF2);
//   static const Color textColor = Color(0xff000000);
//   static const Color subtextcolor = Color(0xff7C7777);
//   static const Color primaryColor = Color(0xff56C8C8);
//
//
//   static const Color errorColor = Color(0xFFD32F2F);
//   static const Color successColor = Color(0xFF0C8015);
//   static const Color warningColor = Color(0xFFDB930B);
//
//   static const backgroundGradientColor = LinearGradient(
//     begin: Alignment.topCenter,
//
//     end: Alignment.bottomCenter,
//     colors: [
//       Color(0xffE3EAF2),
//       Color(0xffC9D6FF),
//       Color(0xffA1C4FD)
//
//     ],
//     stops: [0.08, 0.4,1.0], // ascending order
//   );
//
//   static const backgroundGradientTextColor = LinearGradient(
//
//
//       begin: Alignment.centerLeft,
//       end: Alignment.centerRight,
//       colors: [
//       //  AppColors.gradTextColor,
//        Color(0xFF5B5CFF),
//         Color(0xFF9B5CFF),
//        //AppColors.primaryColor,
//          Color(0xFFA057FF),
//       ],
//     );
//
//   TextStyle customTextStyleRegular8({
//     Color color = subtextcolor,
//     FontWeight fontWeight = FontWeight.w400,
//   })
//   {
//     return GoogleFonts.poppins(
//       letterSpacing: 0,
//         color: color,
//         fontSize: 8,
//         fontWeight: fontWeight,
//         height: 1,
//     );
//
//   }
//   TextStyle customTextStyleRegular10({
//     Color color = subtextcolor,
//     FontWeight fontWeight = FontWeight.w400,
//   })
//   {
//     return GoogleFonts.poppins(
//       letterSpacing: 0,
//       color: color,
//       fontSize: getFont(10),
//       fontWeight: fontWeight,
//       height: 1,
//     );
//   }
//   TextStyle customTextStyleBold10({
//     Color color =textColor,
//     FontWeight fontWeight = FontWeight.w700,
//   })
//   {
//     return GoogleFonts.poppins(
//       letterSpacing: 0,
//       color: color,
//       fontSize: getFont(10),
//       fontWeight: fontWeight,
//       height: 1,
//     );
//   }
//   TextStyle customTextStyle11({
//     Color color = textColor,
//     FontWeight fontWeight = FontWeight.w300,
//   }) {
//     return GoogleFonts.poppins(
//       letterSpacing: 0,
//       color: color,
//       fontSize: getFont(11),
//       fontWeight: fontWeight,
//       height: 1,
//     );
//   }
//   TextStyle customTextStyle12({
//     Color color = textColor,
//     FontWeight fontWeight = FontWeight.w500,
//   }) {
//     return GoogleFonts.poppins(
//       letterSpacing: 0,
//       color: color,
//       fontSize: getFont(12),
//       fontWeight: fontWeight,
//       height: 1,
//     );
//   }
//   TextStyle customTextStyle14({
//     Color color = textColor,
//     FontWeight fontWeight = FontWeight.w400,
//   }) {
//     return GoogleFonts.poppins(
//       letterSpacing: 0,
//       color: color,
//       fontSize: getFont(14),
//       fontWeight: fontWeight,
//       height: 1,
//
//     );
//   }
//   TextStyle customTextStyle15({
//     Color color = textColor,
//     FontWeight fontWeight = FontWeight.w300,
//   }) {
//     return GoogleFonts.poppins(
//       letterSpacing: 0,
//       color: color,
//       fontSize: getFont(15),
//       fontWeight: fontWeight,
//       height: 1,
//     );
//   }
//   TextStyle customTextStyleBold16({
//     Color color = textColor,
//     FontWeight fontWeight = FontWeight.w500,
//   }) {
//     return GoogleFonts.poppins(
//       letterSpacing: 0,
//       color: color,
//       fontSize: getFont(16),
//       fontWeight: fontWeight,
//       height: 1,
//     );
//   }
//
//   TextStyle customTextStyle18({
//     Color color = textColor,
//     FontWeight fontWeight = FontWeight.w600,
//   }) {
//     return GoogleFonts.poppins(
//       letterSpacing: 0,
//       color: color,
//       fontSize: getFont(18),
//       fontWeight: fontWeight,
//       height: 1,
//     );
//   }
//   TextStyle customTextStyle20Regular({
//     Color color =textColor,
//     FontWeight fontWeight = FontWeight.w300,
//   }) {
//     return GoogleFonts.poppins(
//       letterSpacing: 0,
//       color: color,
//       fontSize: getFont(20),
//       fontWeight: fontWeight,
//       height: 1,
//     );
//   }
//   TextStyle customTextStyle20({
//     Color color =textColor,
//     FontWeight fontWeight = FontWeight.w500,
//   }) {
//     return GoogleFonts.poppins(
//       letterSpacing: 0,
//       color: color,
//       fontSize: getFont(20),
//       fontWeight: fontWeight,
//       height: 1,
//     );
//   }
//
//
//   TextStyle customTextStyle21({
//     Color color = textColor,
//     FontWeight fontWeight = FontWeight.w700,
//   }) {
//     return GoogleFonts.poppins(
//       letterSpacing: 0,
//       color: color,
//       fontSize: getFont(21),
//       fontWeight: fontWeight,
//       height: 1,
//     );
//   }
//   TextStyle customTextStyle24({
//     Color color =textColor,
//     FontWeight fontWeight = FontWeight.w600,
//   }) {
//     return GoogleFonts.poppins(
//       letterSpacing: 0,
//       color: color,
//       fontSize: getFont(24),
//       fontWeight: fontWeight,
//       height: 1,
//     );
//   }
//
//   TextStyle customTextStyle27({
//     Color color = textColor,
//     FontWeight fontWeight = FontWeight.w700,
//   }) {
//     return GoogleFonts.poppins(
//       letterSpacing: 0,
//       color: color,
//       fontSize: getFont(27),
//       fontWeight: fontWeight,
//       height: 1,
//     );
//   }
//
//   TextStyle customTextStyle30Regular({
//     Color color = textColor,
//     FontWeight fontWeight = FontWeight.w300,
//   }) {
//     return GoogleFonts.poppins(
//       letterSpacing: 0,
//       color: color,
//       fontSize: getFont(30),
//       fontWeight: fontWeight,
//       height: 1,
//     );
//   }
//   TextStyle customTextStyle32({
//     Color color = textColor,
//     FontWeight fontWeight = FontWeight.w700,
//   }) {
//     return GoogleFonts.poppins(
//       letterSpacing: 0,
//       color: color,
//       fontSize: getFont(32),
//       fontWeight: fontWeight,
//       height: 1,
//     );
//   }
//
//   TextStyle customTextStyle36({
//     Color color = textColor,
//     FontWeight fontWeight = FontWeight.w700,
//   }) {
//     return GoogleFonts.poppins(
//       letterSpacing: 0,
//       color: color,
//       fontSize: getFont(36),
//       fontWeight: fontWeight,
//       height: 1,
//     );
//   }
//
//   TextStyle customTextStyleCairo14({
//     Color color = textColor,
//     FontWeight fontWeight = FontWeight.w400,
//   }) {
//     return GoogleFonts.cairo(
//       letterSpacing: 0,
//       color: color,
//       fontSize: getFont(14),
//       fontWeight: fontWeight,
//       height: 1,
//     );
//   }
//
//
//   TextStyle customTextStyleAmiri22({
//     Color color = textColor,
//     FontWeight fontWeight = FontWeight.w400,
//   }) {
//     return GoogleFonts.Amiri(
//       letterSpacing: 0,
//       color: color,
//       fontSize: getFont(14),
//       fontWeight: fontWeight,
//       height: 1,
//     );
//   }
//
// }
//
//
//
//
//
//
// class GradientText extends StatelessWidget {
//   final String text;
//   final TextStyle style;
//   final Gradient gradient;
//
//   const GradientText({
//     super.key,
//     required this.text,
//     required this.style,
//     required this.gradient,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return ShaderMask(
//       shaderCallback: (bounds) => gradient.createShader(bounds),
//       child: Text(
//         text,
//         style: style.copyWith(color: Colors.white),
//       ),
//     );
//   }
// }
//
//
