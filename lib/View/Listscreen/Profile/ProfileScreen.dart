import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_notification/Utils/Constants/AllImages.dart';
import 'package:local_notification/Utils/Constants/CustomButton.dart';
import 'package:local_notification/Utils/Constants/CustomTextFormField.dart';
import 'package:local_notification/Utils/Constants/SizeConfig.dart';


import '../../../Bloc/ProfileBloc/ProfileCubit.dart';
import '../../../Utils/Constants/AllColors.dart';
import '../../../Utils/Constants/userFeedback.dart';



class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return BlocProvider(
      create: (_) => ProfileCubit(),
      child: const _ProfileBody(), 
    );
  }
}


class _ProfileBody extends StatelessWidget {
  const _ProfileBody();

  void _showSnackbar(
    BuildContext context, 
    String message, 
    Color color,
    ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)),
        margin:  EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>(); 

    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileSuccess) {
          _showSnackbar(context, "Profile saved successfully!", Colors.green);
        } else if (state is ProfileError) {
          _showSnackbar(context, state.message, Colors.red);
        }
      },
      builder: (context, state) {
        final currentImage = state is ProfileImageSelected
            ? state.selectedImage
            : cubit.selectedImage;

        final bool formValid = cubit.isFormValid;

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title:  Text("Profile",
            style:AppColors().customTextStyleBold16().copyWith(
            fontSize: getFont(16),
          )
            ),
            ),
          body: SingleChildScrollView(
            child: Padding(
              padding:  EdgeInsets.symmetric(
                horizontal: getWidth(14)
                ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   SizedBox(height: getHeight(20)),

                 
                  Center(
                    child: GestureDetector(
                      onTap: () => cubit.pickImage(),
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.grey,
                            backgroundImage: currentImage != null
                                ? FileImage(currentImage)
                                : null,
                            child: currentImage == null
                                ? const Icon(Icons.person,
                                size: 40, color: Colors.white)
                                : null,
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: GestureDetector(
                              onTap: () => cubit.pickImage(),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.white,
                                       width: 2),
                                ),
                                child: CircleAvatar(
                                  radius: 14,
                                  backgroundColor: AppColors.primaryColor,
                                  child: SvgPicture.asset(AllImages.edit),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                   SizedBox(height: getHeight(20)),

                  CustomTextField(
                    titleController: cubit.nameController,
                    title: "Name",
                    line: 1,
                    hinttext: "Enter Name",
                  ),
                   SizedBox(height: getHeight(10)),
                  CustomTextField(
                    titleController: cubit.phoneController,
                    title: "Phone Number",
                    line: 1,
                    keyboardType: TextInputType.phone,
                    hinttext: "Enter Number",
                  ),
                   SizedBox(height:getHeight(10)),
                  CustomTextField(
                    titleController: cubit.emailController,
                    title: "Email",
                    line: 1,
                    keyboardType: TextInputType.emailAddress,
                    hinttext: "abcd@gmail.com",
                  ),
                   SizedBox(height: getHeight(10)),
                  CustomTextField(
                    titleController: cubit.dobController,
                    title: "Date of Birth",
                    line: 1,
                    keyboardType: TextInputType.datetime,
                    hinttext: "DD/MM/YY",
                  ),
                  SizedBox(height: getHeight(10)),
                  const Text("Gender"),
                  SizedBox(height: getHeight(10)),

                  GenderDropdown(
                    onGenderChanged: (value) => cubit.selectGender(value),
                  ),

                  SizedBox(height: getHeight(30)),

                  state is ProfileLoading
                      ?  Center(child:spinkit)
                      : CustomButton(
                    // ontap: () => cubit.saveProfile(),
                    title: "Save", 
                    onTap: () {
                       cubit.saveProfile();
                      },
                  ),

                   SizedBox(height: getHeight(30)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});
//
//   void _showSnackbar(BuildContext context, String message, Color color) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: color,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         margin: const EdgeInsets.all(16),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final cubit = context.read<ProfileCubit>();
//
//     return BlocConsumer<ProfileCubit, ProfileState>(
//       listener: (context, state) {
//         if (state is ProfileSuccess) {
//           _showSnackbar(context, "Profile saved successfully!", Colors.green);
//         } else if (state is ProfileError) {
//           _showSnackbar(context, state.message, Colors.red);
//         }
//       },
//       builder: (context, state) {
//         // ✅ Current image — state se ya cubit se
//         final File? currentImage = state is ProfileImageSelected
//             ? state.selectedImage
//             : cubit.selectedImage;
//
//         // ✅ Form valid check
//         final bool formValid = cubit.isFormValid;
//
//         return Scaffold(
//           appBar: AppBar(title: const Text("Profile")),
//           body: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 14),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 20),
//
//                   // ✅ Profile Image Section
//                   Center(
//                     child: GestureDetector(
//                       onTap: () => cubit.pickImage(),
//                       child: Stack(
//                         children: [
//                           CircleAvatar(
//                             radius: 40,
//                             backgroundColor: Colors.grey,
//                             backgroundImage: currentImage != null
//                                 ? FileImage(currentImage)
//                                 : null,
//                             child: currentImage == null
//                                 ? const Icon(Icons.person,
//                                 size: 40, color: Colors.white)
//                                 : null,
//                           ),
//                           Positioned(
//                             right: 0,
//                             bottom: 0,
//                             child: GestureDetector(
//                               onTap: () => cubit.pickImage(),
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   border:
//                                   Border.all(color: Colors.white, width: 2),
//                                 ),
//                                 child: CircleAvatar(
//                                   radius: 14,
//                                   backgroundColor: AppColors.primaryColor,
//                                   child: SvgPicture.asset(AllImages.edit),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 20),
//
//                   // ✅ Text Fields - controllers cubit mein hain
//                   CustomTextField(
//                     titleController: cubit.nameController,
//                     title: "Name",
//                     line: 1,
//                     hinttext: "Enter Name",
//                   ),
//                   const SizedBox(height: 5),
//                   CustomTextField(
//                     titleController: cubit.phoneController,
//                     title: "Phone Number",
//                     line: 1,
//                     keyboardType: TextInputType.phone,
//                     hinttext: "Enter Number",
//                   ),
//                   const SizedBox(height: 5),
//                   CustomTextField(
//                     titleController: cubit.emailController,
//                     title: "Email",
//                     line: 1,
//                     keyboardType: TextInputType.emailAddress,
//                     hinttext: "abcd@gmail.com",
//                   ),
//                   const SizedBox(height: 5),
//                   CustomTextField(
//                     titleController: cubit.dobController,
//                     title: "Date of Birth",
//                     line: 1,
//                     keyboardType: TextInputType.datetime,
//                     hinttext: "DD/MM/YY",
//                   ),
//                   const SizedBox(height: 5),
//                   const Text("Gender"),
//                   const SizedBox(height: 5),
//
//                   // ✅ Gender Dropdown
//                   GenderDropdown(
//                     onGenderChanged: (value) => cubit.selectGender(value),
//                   ),
//
//                   const SizedBox(height: 30),
//
//                   // ✅ Loading ya Button
//                   state is ProfileLoading
//                       ? const Center(child: CircularProgressIndicator())
//                       : CustomButton(
//                     ontap: () => cubit.saveProfile(),
//                     title: "Save",
//                     // color: formValid
//                     //     ? AppColors.primaryColor
//                     //     : Colors.grey,
//                   ),
//
//                   const SizedBox(height: 30),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

var p=4;
// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});
//
//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   final TextEditingController namecontroller = TextEditingController();
//   final TextEditingController phonenumbercontroller = TextEditingController();
//   final TextEditingController emailcontroller = TextEditingController();
//   final TextEditingController dateofBirthcontroller = TextEditingController();
//   String? selectedGender;
//
//   final List<String> genderList = ["Male", "Female"];
//
//   // ✅ Check karta hai sab fields bhari hain ya nahi
//   bool get _isFormValid {
//     return namecontroller.text.trim().isNotEmpty &&
//         phonenumbercontroller.text.trim().isNotEmpty &&
//         emailcontroller.text.trim().isNotEmpty &&
//         dateofBirthcontroller.text.trim().isNotEmpty &&
//         selectedGender != null;
//   }
//
//
// // State mein yeh variable add karo
//   File? _selectedImage;
//
// // ✅ Gallery open karne ka function
//   Future<void> _pickImageFromGallery() async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? pickedFile = await picker.pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 80, // Image quality 80%
//     );
//
//     if (pickedFile != null) {
//       setState(() {
//         _selectedImage = File(pickedFile.path);
//       });
//     }
//   }
//   @override
//   void initState() {
//     super.initState();
//     // ✅ Har controller ki change pe UI rebuild ho
//     namecontroller.addListener(() => setState(() {}));
//     phonenumbercontroller.addListener(() => setState(() {}));
//     emailcontroller.addListener(() => setState(() {}));
//     dateofBirthcontroller.addListener(() => setState(() {}));
//   }
//
//   @override
//   void dispose() {
//     namecontroller.dispose();
//     phonenumbercontroller.dispose();
//     emailcontroller.dispose();
//     dateofBirthcontroller.dispose();
//     super.dispose();
//   }
//
//   // ✅ Save button press hone par validation
//   void _onSavePressed() {
//     if (!_isFormValid) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text("Please fill all fields"),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           margin: const EdgeInsets.all(16),
//           duration: const Duration(seconds: 2),
//         ),
//       );
//       return;
//     }
//
//     // ✅ Sab fields bhari hain — save logic yahan likho
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: const Text("Profile saved successfully!"),
//         backgroundColor: Colors.green,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         margin: const EdgeInsets.all(16),
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Profile"),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 14),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: GestureDetector(
//                   onTap: _pickImageFromGallery, // ✅ Poore avatar par bhi tap kaam kare
//                   child: Stack(
//                     children: [
//                       // ✅ Profile Image CircleAvatar
//                       CircleAvatar(
//                         radius: 40,
//                         backgroundColor: Colors.grey,
//                         backgroundImage: _selectedImage != null
//                             ? FileImage(_selectedImage!) // ✅ Selected image show ho
//                             : null,
//                         child: _selectedImage == null
//                             ? const Icon(Icons.person, size: 40, color: Colors.white) // Placeholder icon
//                             : null,
//                       ),
//
//                       // ✅ Edit Button
//                       Positioned(
//                         right: 0,
//                         bottom: 0,
//                         child: GestureDetector(
//                           onTap: _pickImageFromGallery, // ✅ Edit icon par tap
//                           child: Container(
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               border: Border.all(color: Colors.white, width: 2),
//                             ),
//                             child: CircleAvatar(
//                               radius: 14,
//                               backgroundColor: AppColors.primaryColor,
//                               child: Center(
//                                 child: SvgPicture.asset(AllImages.edit),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               CustomTextField(
//                 titleController: namecontroller,
//                 title: "Name",
//                 line: 1,
//                 hinttext: "Enter Name",
//               ),
//               const SizedBox(height: 5),
//               CustomTextField(
//                 titleController: phonenumbercontroller,
//                 title: "Phone Number",
//                 line: 1,
//                 keyboardType: TextInputType.phone,
//                 hinttext: "Enter Number",
//               ),
//               const SizedBox(height: 5),
//               CustomTextField(
//                 titleController: emailcontroller,
//                 title: "Email",
//                 line: 1,
//                 keyboardType: TextInputType.emailAddress,
//                 hinttext: "abcd@gmail.com",
//               ),
//               const SizedBox(height: 5),
//               CustomTextField(
//                 titleController: dateofBirthcontroller,
//                 title: "Date of Birth",
//                 line: 1,
//                 keyboardType: TextInputType.datetime,
//                 hinttext: "DD/MM/YY",
//               ),
//               const SizedBox(height: 5),
//               const Text("Gender"),
//               const SizedBox(height: 5),
//
//               // ✅ Gender change hone par parent rebuild ho
//               GenderDropdown(
//                 onGenderChanged: (value) {
//                   setState(() {
//                     selectedGender = value;
//                   });
//                 },
//               ),
//
//               const SizedBox(height: 30),
//
//               // ✅ Button sirf tab active jab sab fields bhari hon
//               CustomButton(
//                 ontap: _isFormValid ? _onSavePressed : _onSavePressed,
//                 title: "Save",
//                 // Agar aapka CustomButton color/opacity support karta hai:
//                 // isEnabled: _isFormValid,
//                // color: _isFormValid ? AppColors.primaryColor : Colors.grey,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

//  GenderDropdown ab callback ke saath
class GenderDropdown extends StatefulWidget {
  final ValueChanged<String?> onGenderChanged;

  const GenderDropdown({super.key, required this.onGenderChanged});

  @override
  State<GenderDropdown> createState() => _GenderDropdownState();
}

class _GenderDropdownState extends State<GenderDropdown> {
  String? selectedGender;
  final List<String> genderList = ["Male", "Female"];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonFormField<String>(
        value: selectedGender,
        hint:  Text("Select Gender",
        style:AppColors().customTextStyleRegular10(
          color:AppColors.black ).copyWith(
            fontSize: getFont(14)
          )
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          fillColor: AppColors.white,
          filled: true,
        ),
        items: genderList.map((gender) {
          return DropdownMenuItem(value: gender, child: Text(gender));
        }).toList(),
        onChanged: (value) {
          setState(() => selectedGender = value);
          widget.onGenderChanged(value); 
        },
      ),
    );
  }
}




//
// class ProfileScreen extends StatelessWidget {
//   ProfileScreen({super.key});
//   TextEditingController namecontroller = TextEditingController();
//   TextEditingController phonenumbercontroller = TextEditingController();
//   TextEditingController emailcontroller = TextEditingController();
//   TextEditingController dateofBirthcontroller = TextEditingController();
//   String? selectedGender;
//
//   List<String> genderList = ["Male", "Female"];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Profile"),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 14),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: Stack(
//                   children: [
//                   CircleAvatar(
//                     radius: 40,
//                     backgroundColor: Colors.grey,
//                   ),
//                     Positioned(
//                         right: 0,
//                         bottom: 0,
//                         child:
//                     Container(
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(
//                           color: Colors.white, // border color
//                           width: 2,
//                         ),
//                       ),
//                       child: CircleAvatar(
//                         radius: 14,
//
//                         backgroundColor: AppColors.primaryColor,
//                         child: Center(
//                           child: SvgPicture.asset(AllImages.edit),
//                         ),
//
//                       ),
//                     )
//                     )
//                   ],
//                 ),
//               ),
//
//               CustomTextField(titleController:namecontroller ,
//               title: "Name", line: 1,
//               hinttext: "Enter Name"),
//               SizedBox(height: 5,),
//               CustomTextField(titleController:phonenumbercontroller ,
//                   title: "Phone Number", line: 1,
//                    keyboardType: TextInputType.phone,
//                   hinttext: "Enter Number"),
//               SizedBox(height: 5,),
//               CustomTextField(titleController:emailcontroller ,
//                   title: "Email", line: 1,
//                   keyboardType: TextInputType.emailAddress,
//                   hinttext: "abcd@gmail.com"),
//               SizedBox(height: 5,),
//               CustomTextField(titleController:dateofBirthcontroller ,
//                   title: "Date of Birth", line: 1,
//                   keyboardType: TextInputType.datetime,
//                   hinttext: "DD/MM/YY"),
//               SizedBox(height: 5,),
//               Text("Gender"),
//               SizedBox(height: 5,),
//               GenderDropdown(),
//               SizedBox(height: 30,),
//
//
//               CustomButton(ontap: (){}, title: "Save"),
//
//
//
//
//
//
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// class GenderDropdown extends StatefulWidget {
//   const GenderDropdown({super.key});
//
//   @override
//   State<GenderDropdown> createState() => _GenderDropdownState();
// }
//
// class _GenderDropdownState extends State<GenderDropdown> {
//
//   String? selectedGender;
//
//   List<String> genderList = ["Male", "Female"];
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: DropdownButtonFormField<String>(
//         value: selectedGender,
//         hint: const Text("Select Gender"),
//         decoration: InputDecoration(
//           border: InputBorder.none,
//           fillColor: AppColors.white,
//
//           filled: true,
//         ),
//         items: genderList.map((gender) {
//           return DropdownMenuItem(
//             value: gender,
//             child: Text(gender),
//           );
//         }).toList(),
//         onChanged: (value) {
//           setState(() {
//             selectedGender = value;
//           });
//         },
//       ),
//     );
//   }
// }