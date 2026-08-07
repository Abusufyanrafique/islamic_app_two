

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_notification/Utils/Constants/SizeConfig.dart';


import 'AllColors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.titleController,
    required this.title,
    required this.line,
    required this.hinttext,
    this.keyboardType,
    this.onChanged,
  this.inputFormatters,
  });

  final TextEditingController titleController;
  final String title;
  final int? line;
  final String hinttext;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;



  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
        style: AppColors().customTextStyle12(
          color:AppColors.black,
           ).copyWith(
            fontSize: getFont(14)
           )
        ),
        SizedBox(height: getHeight(8),),
        Container(
          decoration: BoxDecoration(
            color: Colors.white, 
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25), 
                offset: Offset(0, 1), // x=0, y=1
                blurRadius: 4, // blur
                spreadRadius: 0, // spread
              ),
            ],
            borderRadius: BorderRadius.circular(8), 
          ),
          child: TextFormField(
            maxLines: line ?? 1,
            onChanged: onChanged,
            controller: titleController,
            keyboardType: keyboardType,
            decoration:  InputDecoration(
              hintText: hinttext,
              hintStyle: AppColors().
              customTextStyleBold16(
                color: AppColors.screenbackgroundColor,
                ),
              fillColor: AppColors.white,

              filled: true,
    //            border: OutlineInputBorder(
    //            borderRadius: BorderRadius.circular(10),
    //            borderSide: BorderSide(
    //            color: AppColors.screenbackgroundColor,
    //            width: 1,
    //   ),
    // ),

    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: AppColors.screenbackgroundColor,
        width: 1,
      ),),
              border: InputBorder.none,
              // border: OutlineInputBorder(),
            ),
          ),
        ),


      ],
    );
  }
}



class CustomIconTextField extends StatelessWidget {
  const CustomIconTextField({
    super.key,
    required this.titleController,
    required this.title,
    required this.line,
    required this.hinttext,
    required this.icon,
    
  });

  final TextEditingController titleController;
  final String title;
  final int? line;
  final String hinttext;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        TextFormField(
          maxLines: line ?? 1,
          controller: titleController,
          decoration:  InputDecoration(
            icon:Icon(icon),
            hintText: hinttext,
            hintStyle: AppColors().customTextStyleBold16(color: AppColors.black),
           fillColor: AppColors.white,
            filled: true,
            border: InputBorder.none,
            //border: OutlineInputBorder(),
          ),
        ),


      ],
    );
  }
}