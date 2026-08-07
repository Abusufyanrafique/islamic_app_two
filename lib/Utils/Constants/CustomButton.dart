
import 'package:flutter/material.dart';
import 'package:local_notification/Utils/Constants/SizeConfig.dart';

import 'AllColors.dart';


// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
   VoidCallback ontap;
  final String title;

  CustomButton({
    super.key,
    required this.ontap,
    required this.title,
  });

  bool _loading = false;



  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: getHeight(50),
      child: InkWell(
        onTap: ontap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
           color: AppColors.primaryColor
           // gradient: AppColors.UploadbackgroundGradientColor,
          ),
          child: Center(
            child: _loading
                ?  SizedBox(
              height: getHeight(22),
              width: getWidth(22),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
                : Text(
              title,
              style: AppColors()
                  .customTextStyleBold16(color: AppColors.textColor),
            ),
          ),
        ),
      ),
    );
  }
}

