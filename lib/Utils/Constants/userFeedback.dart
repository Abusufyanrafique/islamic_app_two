import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'AllColors.dart';
import 'SizeConfig.dart';
import 'package:fluttertoast/fluttertoast.dart';


void showErrorToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: AppColors.errorColor,
    textColor: Colors.white,
  );
}

void showSuccessToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: AppColors.successColor,
    textColor: Colors.white,
  );
}

void showInfoToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: AppColors.darkBlue,
    textColor: Colors.white,
  );
}

OverlayEntry buildLoadingOverlay() {
  return OverlayEntry(
    builder: (context) => Container(
      color: Colors.black45,
      child: Center(
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.lightBackgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
              ),
          ),
        ),
      ),
    ),
  );
}

Widget loadingIndicator() {
  return const Center(
    child: CircularProgressIndicator(color: AppColors.primaryColor),
  );
}

// --- UI Components ---

Widget bottomButton(
  VoidCallback ontap, 
  String icon, 
  String title,
  ) {
  return GestureDetector(
    onTap: ontap,
    behavior: HitTestBehavior.opaque,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Agar aap getHeight/getWidth use kar rahe hain to wahi rehne dein
        SvgPicture.asset(icon, height: 20, width: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: Colors.black),
        )
      ],
    ),
  );
}

// --- Sharing Logic ---

// // 1. General Share (System Tray) - Image/Video dono ke liye
// Future<void> shareStatus(String path) async {
//   if (path.isNotEmpty) {
//     await Share.shareXFiles([XFile(path)]);
//   }
// }
// Future<void> saveToHive(String path, String type) async {
//   var box = Hive.box<SavedItem>('saved_items');
//
//   // Check karein ke kahin ye file pehle hi save to nahi?
//   bool exists = box.values.any((item) => item.path == path);
//
//   if (!exists) {
//     await box.add(SavedItem(
//       path: path,
//       type: type,
//       dateTime: DateTime.now(),
//     ));
//   }
// }

Widget tabbutton(String title) {
  return Container(
    height: getHeight(36),
    width: getWidth(123),
    decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.white,width: 1)
    ),
    alignment: Alignment.center,
    child: Text(title,style: AppColors().customTextStyleBold16(),),
  );
}





//
// Future<void> openWhatsapp() async {
//   var num = "+923116326930";
//
//   final Uri androidUrl = Uri.parse("whatsapp://send?phone=$num&text=hello");
//   final Uri iosUrl = Uri.parse("https://wa.me/$num?text=${Uri.encodeComponent("hello")}");
//
//   if (Platform.isIOS) {
//     if (await canLaunchUrl(iosUrl)) {
//       await launchUrl(iosUrl);
//     } else {
//       print("WhatsApp not installed");
//     }
//   } else {
//     if (await canLaunchUrl(androidUrl)) {
//       await launchUrl(androidUrl);
//     } else {
//       print("WhatsApp not installed");
//     }
//   }
// }
//
// void showAppSnackBar({
//   required BuildContext context,
//   required String title,
//   required String message,
//   required ContentType contentType,
//
// })
// {
//   final snackBar = SnackBar(
//     elevation: 0,
//     behavior: SnackBarBehavior.floating,
//     backgroundColor: Colors.transparent,
//     content: AwesomeSnackbarContent(
//       title: title,
//       message: message,
//       contentType: contentType,
//     ),
//   );
//
//   ScaffoldMessenger.of(context)
//     ..hideCurrentSnackBar()
//     ..showSnackBar(snackBar);
// }
//


final spinkit = SpinKitSpinningLines(
  color: AppColors.primaryColor,
  size: 50.0,
);