import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_notification/Utils/Constants/AllColors.dart';
import 'package:local_notification/Utils/Constants/AllText.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../ChatScreen/ChatScreen.dart';
import '../../../../Utils/Constants/AllImages.dart';
import '../../../../Utils/Constants/SizeConfig.dart';
import '../../../../Utils/Constants/userFeedback.dart';

// ─── STATE ────────────────────────────────────────────────
class AppointmentRequestState extends Equatable {
  final List<Map<String, dynamic>> appointments;
  final bool isLoading;
  final String error;

  const AppointmentRequestState({
    this.appointments = const [],
    this.isLoading = false,
    this.error = "",
  });

  AppointmentRequestState copyWith({
    List<Map<String, dynamic>>? appointments,
    bool? isLoading,
    String? error,
  }) {
    return AppointmentRequestState(
      appointments: appointments ?? this.appointments,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [appointments, isLoading, error];
}

// ─── CUBIT ────────────────────────────────────────────────
class AppointmentRequestCubit extends Cubit<AppointmentRequestState> {
  AppointmentRequestCubit() : super(const AppointmentRequestState());

  final _supabase = Supabase.instance.client;

  // 📥 Fetch appointments by mufti_id
  Future<void> fetchAppointments(int muftiId) async {
    try {
      emit(state.copyWith(isLoading: true, error: ""));

      final response = await _supabase
          .from('Appointment')
          .select()
          .eq('mufti_id', muftiId)
          .order('created_at', ascending: false);

      emit(
        state.copyWith(
          appointments: List<Map<String, dynamic>>.from(response),
          isLoading: false,
        ),
      );
    } catch (e) {
      print("Fetch Error: $e");
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  //  Accept appointment
  Future<void> acceptAppointment(int appointmentId, int muftiId) async {
    try {
      await _supabase
          .from('Appointment')
          .update({'status': 'accepted'})
          .eq('id', appointmentId);

      await fetchAppointments(muftiId);
    } catch (e) {
      print("Accept Error: $e");
    }
  }

  //  Reject appointment
  Future<void> rejectAppointment(int appointmentId, int muftiId) async {
    try {
      await _supabase
          .from('Appointment')
          .update({'status': 'rejected'})
          .eq('id', appointmentId);

      await fetchAppointments(muftiId);
    } catch (e) {
      print("Reject Error: $e");
    }
  }
}

// ─── UI ───────────────────────────────────────────────────
class AppointmentRequest extends StatelessWidget {
  final int muftiId; // mufti ka id pass karo

  const AppointmentRequest({super.key, required this.muftiId});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return BlocProvider(
      create: (_) => AppointmentRequestCubit()..fetchAppointments(muftiId),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Column(
              children: [
                Text(
                  AllText.Appointment_Requests,
                  style: AppColors().customTextStyle14(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  AllText.Manage_Approve_Requests,
                  style: AppColors().customTextStyle12(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          body: Padding(
            padding:  EdgeInsets.symmetric(horizontal: getWidth(12)),
            child:
                BlocBuilder<AppointmentRequestCubit, AppointmentRequestState>(
                  builder: (context, state) {
                    // Loading
                    if (state.isLoading) {
                      return  Center(
                        child: spinkit
                      );
                    }

                    // Error
                    if (state.error.isNotEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 48,
                            ),
                             SizedBox(height: getHeight(12)),
                            Text(
                              "Something went wrong",
                              style: AppColors().customTextStyle14(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                             SizedBox(height: getHeight(8)),
                            ElevatedButton(
                              onPressed: () => context
                                  .read<AppointmentRequestCubit>()
                                  .fetchAppointments(muftiId),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                              ),
                              child: const Text(
                                "Retry",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // Empty
                    if (state.appointments.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 60,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "No appointment requests yet",
                              style: AppColors().customTextStyle14(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // List
                    return RefreshIndicator(
                      color: AppColors.primaryColor,
                      onRefresh: () => context
                          .read<AppointmentRequestCubit>()
                          .fetchAppointments(muftiId),
                      child: ListView.builder(
                        itemCount: state.appointments.length,
                        itemBuilder: (context, index) {
                          final appt = state.appointments[index];
                          return _AppointmentCard(
                            appointment: appt,
                            muftiId: muftiId,
                          );
                        },
                      ),
                    );
                  },
                ),
          ),
        ),
      ),
    );
  }
}

// ─── APPOINTMENT CARD ─────────────────────────────────────
class _AppointmentCard extends StatelessWidget {
  final Map<String, dynamic> appointment;
  final int muftiId;

  const _AppointmentCard({required this.appointment, required this.muftiId});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppointmentRequestCubit>();
    final int id = appointment['id'];
    final String userName = appointment['user_name'] ?? '';
    final String topic = appointment['topic'] ?? '';
    final String type = appointment['appoitment_type'] ?? '';
    final String date = appointment['select_date'] ?? '';
    final String time = appointment['select_time'] ?? '';
    final String status = appointment['status'] ?? 'pending';

    // Date format
    String formattedDate = date;
    try {
      final parsed = DateTime.parse(date);
      formattedDate =
          "${parsed.day} ${_monthName(parsed.month)} ${parsed.year}";
    } catch (_) {}

    return Container(
      width: double.infinity,
      margin:  EdgeInsets.symmetric(
        vertical: getHeight(10),),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            offset: const Offset(0, 1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Header ──
          ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primaryColor.withOpacity(0.1),
              child: Text(
                userName.isNotEmpty ? userName[0].toUpperCase() : "?",
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            title: Text(
              userName,
              style: AppColors().customTextStyle14(fontWeight: FontWeight.w500),
            ),
            subtitle: topic.isNotEmpty
                ? Row(
                    children: [
                      const Icon(Icons.chat_bubble_outline, size: 12),
                       SizedBox(width: getWidth(4)),
                      Expanded(
                        child: Text(
                          topic,
                          style: AppColors().customTextStyle12(
                            fontWeight: FontWeight.w400,
                            color: AppColors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  )
                : null,
            trailing: _StatusBadge(status: status),
          ),

          // ── Info Row ──
          Padding(
            padding:  EdgeInsets.symmetric(
              horizontal: getWidth(12),
              ),
            child: Row(
              children: [
                _RowText(type.isNotEmpty ? type : "Session", AllImages.chat),
                _RowText(formattedDate, AllImages.calender),
                _RowText(time, AllImages.clock),
              ],
            ),
          ),

           SizedBox(height: getHeight(12)),

          // ── Action Buttons (sirf pending mein dikhenge) ──

          // _AppointmentCard ke andar — accepted appointment par chat button
          // _AppointmentCard ke andar, status == 'accepted' wali condition mein
          if (status == 'accepted')
            Padding(
              padding:  EdgeInsets.symmetric(
                horizontal: getWidth(12),
                 vertical: getHeight(8)),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        //  Appointment table sy seedha yeh values aati hain
                        muftiId: appointment['mufti_id']
                            .toString(), // int8 → String
                        muftiName: appointment['mufti_name'] ?? '',
                        muftiImage:
                            '', // Hafiz_Profile sy fetch kar sakte ho baad mein
                        muftiStatus: 'Online',
                        userName:
                            appointment['user_name'] ??
                            '', // Appointment.user_name
                      ),
                    ),
                  );
                },
                child: Container(
                  height: getHeight(38),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.chat_bubble_outline,
                          color: Colors.white,
                          size: 16,
                        ),
                        SizedBox(width: getWidth(8)),
                        Text(
                          "Start Chat",
                          style: AppColors().customTextStyle12(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          // if (status == 'pending')
          //   Padding(
          //     padding:
          //     const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       children: [
          //         // Reject
          //         GestureDetector(
          //           onTap: () => cubit.rejectAppointment(id, muftiId),
          //           child: Container(
          //             height: getHeight(32),
          //             width: getWidth(150),
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(50),
          //               border: Border.all(color: Colors.red, width: 1),
          //             ),
          //             child: Center(
          //               child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 children: [
          //                   const Icon(Icons.close,
          //                       color: Colors.red, size: 14),
          //                   SizedBox(width: getWidth(5)),
          //                   Text("Reject",
          //                       style: AppColors().customTextStyle12(
          //                           color: Colors.red)),
          //                 ],
          //               ),
          //             ),
          //           ),
          //         ),
          //
          //         // Accept
          //         GestureDetector(
          //           onTap: () => cubit.acceptAppointment(id, muftiId),
          //           child: Container(
          //             height: getHeight(32),
          //             width: getWidth(150),
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(50),
          //               color: AppColors.primaryColor,
          //             ),
          //             child: Center(
          //               child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 children: [
          //                   const Icon(Icons.check,
          //                       color: Colors.white, size: 14),
          //                   SizedBox(width: getWidth(5)),
          //                   Text("Accept",
          //                       style: AppColors().customTextStyle12(
          //                           color: AppColors.white)),
          //                 ],
          //               ),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   )
          else
             SizedBox(height: getHeight(8)),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month];
  }
}

// ─── STATUS BADGE ─────────────────────────────────────────
class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    String label;

    switch (status) {
      case 'accepted':
        bgColor = Colors.green.shade50;
        textColor = Colors.green;
        label = "Accepted";
        break;
      case 'rejected':
        bgColor = Colors.red.shade50;
        textColor = Colors.red;
        label = "Rejected";
        break;
      default:
        bgColor = Colors.orange.shade50;
        textColor = Colors.orange;
        label = "Pending";
    }

    return Container(
      padding:  EdgeInsets.symmetric(
        horizontal: getWidth(10),
         vertical: getHeight(4)),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: getFont(11),
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ─── ROW TEXT WIDGET ──────────────────────────────────────
class _RowText extends StatelessWidget {
  final String title;
  final String icon;
  const _RowText(this.title, this.icon);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: getWidth(5)),
        SvgPicture.asset(
          icon, 
          height: getHeight(12),
           width: getWidth(12),
           ),
        SizedBox(width: getWidth(5)),
        Text(
          title,
          style: AppColors().customTextStyle12(
            fontWeight: FontWeight.w400,
            color: AppColors.black,
          ),
        ),
      ],
    );
  }
}

