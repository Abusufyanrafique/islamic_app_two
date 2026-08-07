part of 'ProfileCubit.dart';



abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

// ✅ Image select hone par UI update ke liye
class ProfileImageSelected extends ProfileState {
  final File selectedImage;
  ProfileImageSelected(this.selectedImage);
}

// ✅ Gender change hone par UI update ke liye
class ProfileGenderSelected extends ProfileState {
  final String gender;
  ProfileGenderSelected(this.gender);
}

// ✅ Form validation state
class ProfileFormValidation extends ProfileState {
  final bool isValid;
  ProfileFormValidation(this.isValid);
}