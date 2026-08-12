

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_notification/Utils/Constants/AllColors.dart';
import 'package:local_notification/Utils/Constants/userFeedback.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../ChatScreen/ChatScreen.dart';
import '../../../../Utils/Constants/AllImages.dart';
import '../../../../Utils/Constants/SizeConfig.dart';
import '../../../../Widgets/DatePicker.dart';
import '../../../../Widgets/TimePicker.dart';
import 'package:device_info_plus/device_info_plus.dart';

class MuftiState extends Equatable {
  final String userName;
  final String name;
  final String profile_url;
  final int muftiId;
  final String deviceId;
  final String selectDate;
  final String selectTime;
  final String topic;
  final String type;
  final int selectedIndex;
  final bool isValid;
  final bool isLoading;

  const MuftiState({
    this.userName = "",
    this.name = "",
    this.profile_url = "",
    this.muftiId = 0,
    this.deviceId = "",
    this.selectDate = "",
    this.selectTime = "",
    this.topic = "",
    this.type = "",
    this.selectedIndex = -1,
    this.isValid = false,
    this.isLoading = false,
  });

  MuftiState copyWith({
    String? userName,
    String? name,
    String? profile_url,
    int? muftiId,
    String? deviceId,
    String? selectDate,
    String? selectTime,
    String? topic,
    String? type,
    int? selectedIndex,
    bool? isValid,
    bool? isLoading,
  }) {
    return MuftiState(
      userName: userName ?? this.userName,
      name: name ?? this.name,
      profile_url: profile_url ?? this.profile_url,
      muftiId: muftiId ?? this.muftiId,
      deviceId: deviceId ?? this.deviceId,
      selectDate: selectDate ?? this.selectDate,
      selectTime: selectTime ?? this.selectTime,
      topic: topic ?? this.topic,
      type: type ?? this.type,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isValid: isValid ?? this.isValid,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
    userName, name, profile_url, muftiId, deviceId,
    selectDate, selectTime, topic, type,
    selectedIndex, isValid, isLoading,
  ];
}
// ─── CUBIT ────────────────────────────────────────────────
class MuftiCubit extends Cubit<MuftiState> {
  MuftiCubit() : super(const MuftiState());

  final _supabase = Supabase.instance.client;

  // 🔄 Updates
  void updateName(String val) => _update(state.copyWith(name: val));
  void updateProfileUrl(String val) => _update(state.copyWith(profile_url: val));
  void updateMuftiId(int val) => _update(state.copyWith(muftiId: val));
  void updateUserName(String val) => _update(state.copyWith(userName: val));
  void updateselectDate(String val) => _update(state.copyWith(selectDate: val));
  void updateselectTime(String val) => _update(state.copyWith(selectTime: val));
  void updatetopic(String val) => _update(state.copyWith(topic: val));
  void updateType(int index, String type) =>
      _update(state.copyWith(selectedIndex: index, type: type));

  // 📱 Device ID fetch
  Future<String> getDeviceId() async {
    final info = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final android = await info.androidInfo;
      return android.id;
    } else if (Platform.isIOS) {
      final ios = await info.iosInfo;
      return ios.identifierForVendor ?? "unknown";
    }
    return "unknown";
  }

  // ✅ Validation
  void _update(MuftiState newState) {
    final valid = newState.name.isNotEmpty &&
        newState.selectDate.isNotEmpty &&
        newState.selectTime.isNotEmpty &&
        newState.userName.isNotEmpty &&
        newState.type.isNotEmpty;
    emit(newState.copyWith(isValid: valid));
  }
// ─── CUBIT mein submit() replace karo ───────────────────

// 🔍 Check if device ID already exists in backend
  Future<bool> isDeviceIdSaved() async {
    try {
      final deviceId = await getDeviceId();
      final response = await _supabase
          .from('Appointment')
          .select('device_id')
          .eq('device_id', deviceId)
          .limit(1);

      return (response as List).isNotEmpty;
    } catch (e) {
      print("Device check error: $e");
      return false;
    }
  }



  Future<int?> submit({required String deviceId}) async {
    if (!state.isValid) return null;
    try {
      emit(state.copyWith(isLoading: true));

      final response = await _supabase.from('Appointment').insert({
        'mufti_id': state.muftiId,
        'user_name': state.userName,
        'mufti_name': state.name,
        'appoitment_type': state.type,
        'select_date': state.selectDate,
        'select_time': state.selectTime,
        'topic': state.topic,
        'device_id': deviceId,
      }).select('id').single();

    //  emit(const MuftiState());
      return response['id'] as int;
    } catch (e) {
      print("Submit Error: $e");
      emit(state.copyWith(isLoading: false));
      return null;
    }
  }

}
// ─── UI ───────────────────────────────────────────────────
class Book_Appointment extends StatelessWidget {
  final String name;
  final String profile_url;
  final int mufti_id;

  const Book_Appointment({
    super.key,
    required this.mufti_id,
    required this.name,
    required this.profile_url,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocProvider(
      create: (_) => MuftiCubit()
        ..updateName(name)
        ..updateMuftiId(mufti_id)
        ..updateProfileUrl(profile_url),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text("Mufti")),
          body: Padding(
            padding:  EdgeInsets.symmetric(horizontal: getWidth(15)),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   SizedBox(height: getHeight(10)),
                  _MuftiProfileCard(name: name, profileUrl: profile_url),
                  SizedBox(height: getHeight(10)),
                  Text("Select Type",
                      style: AppColors().customTextStyle14(
                          fontWeight: FontWeight.w600, color: Colors.black)),
                SizedBox(height: getHeight(10)),
                  const _TypeRow(),
                  SizedBox(height: getHeight(15)),

                  // ── Name TextField ──
                  Text("Your Name",
                      style: AppColors().customTextStyle14(
                          fontWeight: FontWeight.w600, color: Colors.black)),
                 SizedBox(height: getHeight(5)),
                  Container(
                    padding:  EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: TextField(
                      cursorColor: Colors.black,
                      cursorHeight: 15,
                      maxLines: 1,
                      onChanged: context.read<MuftiCubit>().updateUserName,
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: "Enter your name...",
                        hintStyle: AppColors().customTextStyle12(
                            fontWeight: FontWeight.w400, color: AppColors.black),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                   SizedBox(height: getHeight(15)),

                  Text("Select Date",
                      style: AppColors().customTextStyle14(
                          fontWeight: FontWeight.w600, color: Colors.black)),
                   SizedBox(height: getHeight(5)),
                  DatePickerField(
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 10000)),
                    onChanged: (dateTime) {
                      context.read<MuftiCubit>().updateselectDate(
                        dateTime.toIso8601String(),
                      );
                    },
                  ),
                   SizedBox(height: getHeight(10)),
                  Text("Select Time",
                      style: AppColors().customTextStyle14(
                          fontWeight: FontWeight.w600, color: Colors.black)),
                   SizedBox(height: getHeight(5)),
                  TimePickerField(
                    onChanged: (time) {
                      context
                          .read<MuftiCubit>()
                          .updateselectTime(time.format(context));
                    },
                  ),
                   SizedBox(height: getHeight(10)),
                  Text("Topic (Optional)",
                      style: AppColors().customTextStyle14(
                          fontWeight: FontWeight.w600, color: Colors.black)),
                  SizedBox(height: getHeight(10)),
                  const _QuestionWidget(),
                 SizedBox(height: getHeight(20)),
                  const _SubmitButton(),
                  SizedBox(height: getHeight(20)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();


  Future<void> _handleBooking(BuildContext context, MuftiCubit cubit) async {
    final deviceId = await cubit.getDeviceId();
    final alreadySaved = await cubit.isDeviceIdSaved();

    if (!context.mounted) return;

    Future<void> doSubmit() async {
      // ✅ Pehle print karo dekho kya values aa rahi hain
      print("=== DEBUG ===");
      print("muftiId: ${cubit.state.muftiId}");
      print("userName: ${cubit.state.userName}");
      print("name: ${cubit.state.name}");
      print("=============");
      final muftiName = cubit.state.name;
      final muftiImage = cubit.state.profile_url;
      final muftiId = cubit.state.muftiId;
      final userName = cubit.state.userName;

      final appointmentId = await cubit.submit(deviceId: deviceId);

      if (context.mounted && appointmentId != null) {
        showSuccessToast(context,"Booked Successfully");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ChatScreen(
              muftiName: muftiName,   
              muftiImage: muftiImage,
              muftiStatus: "Online",
              muftiId: muftiId.toString(),
              userName: userName,
            ),
          ),
        );
      }
    }



    if (alreadySaved) {
      await doSubmit();
    } else {
      final confirmed = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Share Device ID",
              style: TextStyle(fontWeight: FontWeight.w600)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  "Your Device ID is not registered yet. Share it to book?"),
               SizedBox(height: getHeight(12)),
              Container(
                padding:  EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                     Icon(Icons.phone_android, size: 16, color: Colors.grey),
                     SizedBox(width: getWidth(8)),
                    Expanded(
                      child: Text(deviceId,
                          style:  TextStyle(
                              fontSize: getFont(12),
                              color: Colors.grey,
                              fontFamily: 'monospace')),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text("Yes, Share & Book",
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        await doSubmit();
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text("Appointment cancelled."),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ));
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MuftiCubit, MuftiState>(
      buildWhen: (prev, curr) =>
      prev.isValid != curr.isValid || prev.isLoading != curr.isLoading,
      builder: (context, state) {
        final cubit = context.read<MuftiCubit>();

        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize:  Size(double.infinity, 50),
            backgroundColor:
            state.isValid ? AppColors.primaryColor : Colors.grey,
            padding:
             EdgeInsets.symmetric(vertical: getHeight(14)
             , horizontal: getWidth(12)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50)),
          ),
          onPressed: state.isValid && !state.isLoading
              ? () => _handleBooking(context, cubit)
              : null,
          child: state.isLoading
              ?  SizedBox(
            height: getHeight(20),
            width: getWidth(20),
            child: CircularProgressIndicator(
                color: Colors.white, strokeWidth: 2),
          )
              : const Text(
            "Book Appointment",
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }
}
class _MuftiProfileCard extends StatelessWidget {
  final String name;
  final String profileUrl;
  const _MuftiProfileCard({required this.name, required this.profileUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getHeight(75),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 1),
            spreadRadius: 1,
            blurRadius: 4,
            color: Colors.black.withOpacity(0.25),
          )
        ],
      ),
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: getWidth(12)),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(profileUrl),
            ),
            Padding(
              padding:  EdgeInsets.only(
                top: getHeight(10), 
                left: getWidth(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: AppColors()
                          .customTextStyle14(fontWeight: FontWeight.w500)),
                   SizedBox(height: getHeight(1)),
                  Row(
                    children: [
                      const Icon(Icons.star,
                          color: AppColors.primaryColor, size: 16),
                      Text("4.9",
                          style: AppColors().customTextStyle12(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w400)),
                      Text("(2.4k Reviews)",
                          style: AppColors().customTextStyle12(
                              fontWeight: FontWeight.w400,
                              color: AppColors.primaryColor)),
                    ],
                  ),
                   SizedBox(height: getHeight(1)),
                  Text("Available",
                      style: AppColors()
                          .customTextStyle12(fontWeight: FontWeight.w400)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// Type selection row (Video / Audio / Chat)
class _TypeRow extends StatelessWidget {
  const _TypeRow();

  static const _types = [
    (0, AllImages.video, "Video Call"),
    (1, AllImages.audio, "Audio Call"),
    (2, AllImages.chaticon, "Chat"),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MuftiCubit, MuftiState>(
      buildWhen: (prev, curr) => prev.selectedIndex != curr.selectedIndex,
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _types
              .map((t) => _TypeContainer(
            index: t.$1,
            icon: t.$2,
            text: t.$3,
            isSelected: state.selectedIndex == t.$1,
            onTap: () =>
                context.read<MuftiCubit>().updateType(t.$1, t.$3),
          ))
              .toList(),
        );
      },
    );
  }
}
class _TypeContainer extends StatelessWidget {
  final int index;
  final String icon;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeContainer({
    required this.index,
    required this.icon,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: getHeight(65),
        width: getWidth(100),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? AppColors.primaryColor : AppColors.ContainerColor,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 1),
              spreadRadius: 1,
              blurRadius: 4,
              color: Colors.black.withOpacity(0.25),
            )
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(icon,
                  color: isSelected ? Colors.white : Colors.black),
               SizedBox(height: getHeight(8)),
              Text(
                text,
                style: AppColors().customTextStyle12(
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// Question / topic widget — now talks to cubit
class _QuestionWidget extends StatelessWidget {
  const _QuestionWidget();

  static const _categories = ['Business', 'Family', 'Nikah'];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MuftiCubit, MuftiState>(
      buildWhen: (prev, curr) => prev.topic != curr.topic,
      builder: (context, state) {
        final cubit = context.read<MuftiCubit>();

        // Derive selected index from topic text
        final selectedIndex = _categories.indexOf(state.topic);

        return Container(
          padding:  EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                cursorColor: Colors.black,
                cursorHeight: 15,
                maxLines: 2,
                onChanged: cubit.updatetopic,
                controller: TextEditingController.fromValue(
                  TextEditingValue(
                    text: state.topic,
                    selection: TextSelection.collapsed(
                        offset: state.topic.length),
                  ),
                ),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: "Write your question here....",
                  hintStyle: AppColors().customTextStyle12(
                    fontWeight: FontWeight.w400,
                    color: AppColors.black,
                  ),
                  border: InputBorder.none,
                ),
              ),
              Row(
                children: List.generate(_categories.length, (i) {
                  final isSelected = selectedIndex == i;
                  return Padding(
                    padding:  EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () {
                        // Toggle: same tap = deselect
                        cubit.updatetopic(
                            isSelected ? "" : _categories[i]);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding:  EdgeInsets.symmetric(
                            horizontal: getWidth(18),
                             vertical: getHeight(10)),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF5BBFB5)
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          _categories[i],
                          style: TextStyle(
                            fontSize: getFont(14),
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}

