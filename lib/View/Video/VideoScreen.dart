 



import 'package:flutter/material.dart';

import '../../Utils/Constants/AllColors.dart';

class VideoScreen extends StatelessWidget {
   const VideoScreen({super.key});
 
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         backgroundColor: AppColors.primaryColor,
         foregroundColor: Colors.white,
         title: const Text(
           "Video",
           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
         ),
       ),
       body: Center(child: Text("Work is in progress",style:
         AppColors().customTextStyle20(color: AppColors.black)
         ,),),
     );
     
   }
 }
 