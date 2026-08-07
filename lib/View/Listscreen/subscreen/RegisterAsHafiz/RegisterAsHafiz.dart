import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_notification/Utils/Constants/SizeConfig.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:equatable/equatable.dart';
import '../../../../Utils/Constants/AllColors.dart';
import '../../../../Utils/Constants/userFeedback.dart';


class ImamState extends Equatable {
  final String name;
  final String email;
  final String phone;
  final String cnic;
  final String? qualification;
  final File? profileImage;
  final File? certificate;
  final bool isValid;
  final bool isLoading;

  const ImamState({
    this.name = '',
    this.email = '',
    this.phone = '',
    this.cnic = '',
    this.qualification,
    this.profileImage,
    this.certificate,
    this.isValid = false,
    this.isLoading = false,
  });

  ImamState copyWith({
    String? name,
    String? email,
    String? phone,
    String? cnic,
    String? qualification,
    File? profileImage,
    File? certificate,
    bool? isValid,
    bool? isLoading,
  }) {
    return ImamState(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      cnic: cnic ?? this.cnic,
      qualification: qualification ?? this.qualification,
      profileImage: profileImage ?? this.profileImage,
      certificate: certificate ?? this.certificate,
      isValid: isValid ?? this.isValid,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props =>
      [name, email, phone, cnic, qualification, profileImage, certificate, isValid, isLoading];
}
class ImamCubit extends Cubit<ImamState> {
  ImamCubit() : super(const ImamState());

  final _supabase = Supabase.instance.client;

  void updateName(String val) => _update(state.copyWith(name: val));
  void updateEmail(String val) => _update(state.copyWith(email: val));
  void updatePhone(String val) => _update(state.copyWith(phone: val));
  void updateCnic(String val) => _update(state.copyWith(cnic: val));
  void updateQualification(String val) =>
      _update(state.copyWith(qualification: val));

  void setProfileImage(File file) =>
      _update(state.copyWith(profileImage: file));

  void setCertificate(File file) =>
      _update(state.copyWith(certificate: file));

  void _update(ImamState newState) {
    bool valid = newState.name.isNotEmpty &&
        newState.email.isNotEmpty &&
        newState.phone.isNotEmpty &&
        newState.cnic.isNotEmpty &&
        newState.qualification != null &&
        newState.profileImage != null &&
        newState.certificate != null;

    emit(newState.copyWith(isValid: valid));
  }

  // ✅ Upload Function (FIXED)
  Future<String?> _uploadFile(File file, String folder) async {
    try {
      final ext = file.path.split('.').last;
      final fileName = "${DateTime.now().millisecondsSinceEpoch}.$ext";

      await _supabase.storage
          .from('Imam_Profiles') // ✅ same bucket everywhere
          .upload("$folder/$fileName", file);

      return _supabase.storage
          .from('Imam_Profiles')
          .getPublicUrl("$folder/$fileName");
    } catch (e) {
      print("Upload error: $e");
      return null;
    }
  }

  // ✅ FINAL SUBMIT FUNCTION
  Future<void> submit() async {
    if (!state.isValid) return;

    try {
      emit(state.copyWith(isLoading: true));

      final profileUrl = await _uploadFile(state.profileImage!, "Imam_Profiles");
      final certUrl = await _uploadFile(state.certificate!, "Certificates");

      if (profileUrl == null || certUrl == null) {
        emit(state.copyWith(isLoading: false));
        return;
      }

      // ✅ Unique UID generate karo
   //    final String uid = const Uuid().v4();

      await _supabase.from('Hafiz_Profile').insert({
                       // ← unique id
        'name': state.name,
        'email': state.email,
        'phone_number': state.phone,
        'cnic_number': state.cnic,
        'education': state.qualification,
        'profile_url': profileUrl,
        'certificate': certUrl,
        'status': 'pending',              // ← default pending
      });

      emit(state.copyWith(isLoading: false));

    } catch (e) {
      emit(state.copyWith(isLoading: false));
      print("Submit Error: $e");
    }
  }

}
class ImamRegistrationScreen extends StatelessWidget {
  const ImamRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ImamCubit(),
      child:  ImamRegistration(),
    );
  }
}
class ImamRegistration extends StatelessWidget {
  ImamRegistration({super.key});
  File? _certificateFile;
  Future<File?> pickImage() async {
    final picked =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) return File(picked.path);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ImamCubit>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: BlocBuilder<ImamCubit, ImamState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              const SizedBox(height: 10),
              Center(
                child: Text(
                    "Register as Hafiz",
                    //  'Step 1 of 2: Personal Information',
                    style: AppColors().customTextStyle14(color: AppColors.black)
                ),
              ),
                  const SizedBox(height: 10),
              // ── Progress Bar ─────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: const LinearProgressIndicator(
                        value: 0.8,
                        minHeight: 8,
                        backgroundColor: Color(0xFFD9D9D9),
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5BBFB5)),
                      ),
                    ),
                  ),
                   SizedBox(width: getWidth(10)),
                  Text(
                      'Next: Document Upload',
                      style: AppColors().customTextStyle14(color: AppColors.black)
                  ),
                ],
              ),
               SizedBox(height: getHeight(24)),

              Center(
                child: GestureDetector(
                    onTap: () async {
                final file = await pickImage();
                if (file != null) cubit.setProfileImage(file);
              },

                  child: Stack(
                    children: [
                      Container(
                        width: getWidth(110),
                        height: getHeight(110),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF5BBFB5),
                             width: getWidth(3),
                             ),
                          color: Colors.grey[200],
                          image:  state.profileImage != null
                              ? DecorationImage(
                            image: FileImage( state.profileImage!),
                            fit: BoxFit.cover,
                          )
                              : null,
                        ),
                        child:  state.profileImage == null
                            ? const Icon(Icons.person, size: 50, color: Colors.grey)
                            : null,
                      ),
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Color(0xFF5BBFB5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
                   SizedBox(height: getHeight(20)),

                  /// 🔹 TEXT FIELDS
                  _buildTextField(
                    hint: "Name",
                    icon: Icons.person,
                    onChanged: cubit.updateName,
                    keyboardType: TextInputType.text
                  ),
                   SizedBox(height: getHeight(10)),
                  _buildTextField(
                    hint: "Email",
                    icon: Icons.email,
                    onChanged: cubit.updateEmail,
                      keyboardType: TextInputType.emailAddress
                  ),
                   SizedBox(height: getHeight(10)),
                  _buildTextField(
                    hint: "Phone",
                    icon: Icons.phone,
                    onChanged: cubit.updatePhone,
                      keyboardType: TextInputType.phone
                  ),
                   SizedBox(height: getHeight(10)),
                  _buildTextField(
                    hint: "CNIC",
                    icon: Icons.credit_card,
                    onChanged: cubit.updateCnic,
                      keyboardType: TextInputType.number
                  ),

                   SizedBox(height: getHeight(12)),
//               // ── Dropdown ──────────────────────────────────────────
              Container(
                height: getHeight(42),
                padding:  EdgeInsets.symmetric(
                  horizontal: getWidth(16),
                  ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: DropdownButtonHideUnderline(
                  child:
                  DropdownButton<String>(
                    value: state.qualification,
                    hint:  Text('Islamic Qualification',
                      style:AppColors().customTextStyle12(
                        fontWeight: FontWeight.w400,
                        color: AppColors.black),
                    ),
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                       color: Colors.grey),
                    items: ['Alim', 'Hafiz', 'Mufti', 'Qari']
                        .map((e) =>
                        DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) =>
                        cubit.updateQualification(val!),
                  ),
                ),
              ),
                  /// 🔹 DROPDOWN
                   SizedBox(height: getHeight(20)),

                  GestureDetector(
                    onTap: () async {
                      final file = await pickImage();
                      if (file != null) cubit.setCertificate(file);
                    },
                    child: Container(
                      width: double.infinity,
                      padding:  EdgeInsets.symmetric(
                        vertical: getHeight(20),
                        ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.shade400,
                          style: BorderStyle.solid,
                          width: 1.5,
                        ),
                      ),
                      child: _certificateFile != null
                          ? Column(
                        children: [
                          const Icon(Icons.check_circle,
                              color: Color(0xFF5BBFB5),
                               size: 40),
                           SizedBox(height: getHeight(8)),
                          Text(
                            'File Selected',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: getFont(14),
                            ),
                          ),
                        ],
                      )
                          : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding:  EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF5BBFB5).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.upload_rounded,
                              color: Color(0xFF5BBFB5),
                              size: 36,
                            ),
                          ),
                           SizedBox(width: getWidth(10)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               Text(
                                'Upload Document',
                                style: TextStyle(
                                  fontSize: getFont(16),
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                               SizedBox(height: getHeight(4)),
                              Text(
                                'PDF, JPG or PNG',
                                style: TextStyle(
                                  fontSize: getFont(13),
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  ),
                   SizedBox(height: getHeight(20)),

                  // ── Status ────────────────────────────────────────────
                   Text(
                    'Status: Pending Verification',
                    style: TextStyle(
                      fontSize: getFont(15),
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                   SizedBox(height: getHeight(20)),
              SizedBox( width: double.infinity,
                height: 54, child: ElevatedButton(
                      onPressed: state.isValid && !state.isLoading
                          ? () async {
                        cubit.submit();
                        showSuccessToast("Registerd Successfully");

                        Navigator.pop(context);
                      }
                          : null,
                  style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5BBFB5),
                  shape: RoundedRectangleBorder( borderRadius:
                  BorderRadius.circular(50), ), elevation: 0, ),
                  child:  state.isLoading
                          ? spinkit
                          :  Text(
                            "Submit",
                            style: TextStyle(
                               fontSize: getFont(20),
                                fontWeight: FontWeight.w600, 
                                color: Colors.white, ),),



                ),
              ),


                ],
              ),
            );
          },
        ),
      ),
    );
  }
  Widget _buildTextField({

    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    required Function(String) onChanged,
  })
  {
    return Container(
      height: getHeight(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        onChanged:onChanged ,
        cursorColor: Colors.black,
        cursorHeight: 12,
        keyboardType: keyboardType,
        decoration: InputDecoration(

          isDense: true,
          hintText: hint,
          hintStyle: AppColors().customTextStyle12(
            fontWeight: FontWeight.w400,
            color: AppColors.black),
          prefixIcon: Icon(
            icon, 
            color: Colors.grey,
            size: 14,),
          border: InputBorder.none,
          //  contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
  // /// 🔹 TEXTFIELD
  // Widget _buildTextField({
  //   required String hint,
  //   required IconData icon,
  //   required Function(String) onChanged,
  // })
  // {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(vertical: 6),
  //     padding: const EdgeInsets.symmetric(horizontal: 10),
  //     decoration: BoxDecoration(
  //       border: Border.all(),
  //       borderRadius: BorderRadius.circular(10),
  //     ),
  //     child: TextField(
  //       onChanged: onChanged,
  //       decoration: InputDecoration(
  //         border: InputBorder.none,
  //         icon: Icon(icon),
  //         hintText: hint,
  //       ),
  //     ),
  //   );
  // }
}
class CertificatePicker extends StatefulWidget {
  final Function(File) onFilePicked; // Callback to return selected file
  final File? initialFile; // Optional initial file to display

  const CertificatePicker({
    Key? key,
    required this.onFilePicked,
    this.initialFile,
  }) : super(key: key);

  @override
  State<CertificatePicker> createState() => _CertificatePickerState();
}
class _CertificatePickerState extends State<CertificatePicker> {
  File? _file;

  @override
  void initState() {
    super.initState();
    _file = widget.initialFile;
  }

  Future<void> _pickCertificate() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _file = File(picked.path);
      });
      widget.onFilePicked(_file!); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _file != null
            ? Image.file(_file!, 
            height: getHeight(100),
             width: getWidth(100),
              fit: BoxFit.cover,)
            : const Icon(
              Icons.image, 
              size: 100, 
              color: Colors.grey,
              ),
         SizedBox(height: getHeight(8)),
        ElevatedButton(
          onPressed: _pickCertificate,
          child: const Text("Pick Certificate"),
        ),
      ],
    );
  }
}
