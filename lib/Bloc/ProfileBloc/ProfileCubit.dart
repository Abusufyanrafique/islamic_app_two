import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';



part 'ProfileLoading.dart';


class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  final SupabaseClient _supabase = Supabase.instance.client;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  File? selectedImage;
  String? selectedGender;

  bool get isFormValid =>
      nameController.text.trim().isNotEmpty &&
          phoneController.text.trim().isNotEmpty &&
          emailController.text.trim().isNotEmpty &&
          dobController.text.trim().isNotEmpty &&
          selectedGender != null &&
          selectedImage != null;

  String? getValidationError() {
    if (selectedImage == null) return "Please upload a profile picture";
    if (nameController.text.trim().isEmpty) return "Please enter your name";
    if (phoneController.text.trim().isEmpty) return "Please enter your phone number";
    if (emailController.text.trim().isEmpty) return "Please enter your email";
    if (dobController.text.trim().isEmpty) return "Please enter your date of birth";
    if (selectedGender == null) return "Please select your gender";
    return null;
  }

  Future<void> pickImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      selectedImage = File(picked.path); // ✅ dart:io ka File
      emit(ProfileImageSelected(selectedImage!));
    }
  }

  void selectGender(String? gender) {
    selectedGender = gender;
    emit(ProfileGenderSelected(gender ?? ''));
  }

  Future<String?> _uploadProfileImage(File imageFile) async {
    try {
final filePath = imageFile.path.split('.').last;
       final fileName = "${DateTime.now().millisecondsSinceEpoch}.$filePath";
      await _supabase.storage.from('ProfileImage').upload(
        fileName,
        imageFile,
        fileOptions: const FileOptions(
          cacheControl: '3600',
          upsert: true,
        ),
      );

      return _supabase.storage.from('ProfileImage').getPublicUrl(fileName);
    } catch (e) {
      return null;
    }
  }

  Future<void> saveProfile() async {
    final error = getValidationError();
    if (error != null) {
      emit(ProfileError(error)); // ✅ ProfileState ka part hai — kaam karega
      return;
    }

    emit(ProfileLoading());

    try {
      // final userId = _supabase.auth.currentUser?.id;
      // if (userId == null) {
      //   emit(ProfileError("User not logged in"));
      //   return;
      // }

      final imageUrl = await _uploadProfileImage(selectedImage!);
      print("--------------------------------------------");
      print(imageUrl.toString());
      if (imageUrl == null) {
        emit(ProfileError("Image upload failed. Please try again."));
        return;
      }

      await _supabase.from('User_Profile').upsert({
       // 'id': userId,
        'name': nameController.text.trim(),
        'phone_number': phoneController.text.trim(),
        'email': emailController.text.trim(),
        'date_of_birth': dobController.text.trim(),
        'gender': selectedGender,
        'profile_url': imageUrl,
      });

      emit(ProfileSuccess());
    } catch (e) {
      emit(ProfileError("Something went wrong: ${e.toString()}"));
    }
  }

  @override
  Future<void> close() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    dobController.dispose();
    return super.close();
  }
}