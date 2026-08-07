import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_notification/Utils/Constants/SizeConfig.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../Utils/Constants/AllImages.dart';
import '../Utils/Constants/userFeedback.dart';

class ChatState extends Equatable {
  final List<Map<String, dynamic>> messages;
  final bool isLoading;
  final bool isSending;
  final String error;

  const ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.isSending = false,
    this.error = '',
  });

  ChatState copyWith({
    List<Map<String, dynamic>>? messages,
    bool? isLoading,
    bool? isSending,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isSending: isSending ?? this.isSending,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [messages, isLoading, isSending, error];
}
class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(const ChatState());

  final _supabase = Supabase.instance.client;
  RealtimeChannel? _channel;

  // ✅ Unique conversation ID — mufti + user ka combination
  // static String getConversationId(String muftiId, String userName) {
  //   final a = muftiId;
  //   final b = userName.trim().toLowerCase();
  //   // alphabetically sort karke consistent ID banao
  //   return a.hashCode <= b.hashCode
  //       ? '${a}_$b'
  //       : '${b}_$a';
  // }
  static String getConversationId(String muftiId, String userId) {
    return 'chat_${muftiId}_$userId';
  }
  Future<void> loadMessages({
    required String muftiId,
    required String userName,
  }) async {
    try {
      emit(state.copyWith(isLoading: true, error: ''));

      final conversationId = getConversationId(muftiId, userName);

      final response = await _supabase
          .from('Chat')
          .select()
          .eq('conversation_id', conversationId) //  unique ID se fetch
          .order('created_at', ascending: true);

      emit(state.copyWith(
        messages: List<Map<String, dynamic>>.from(response),
        isLoading: false,
      ));

      //  Realtime
      _channel?.unsubscribe();
      _channel = _supabase
          .channel('chat_$conversationId')
          .onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: 'public',
        table: 'Chat',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'conversation_id',
          value: conversationId,
        ),

        callback: (payload) {
          final newMsg = payload.newRecord;

          final alreadyExists = state.messages.any(
                (msg) => msg['created_at'] == newMsg['created_at'],
          );

          if (!alreadyExists) {
            emit(state.copyWith(
              messages: [...state.messages, newMsg],
            ));
          }
        },
        // callback: (payload) {
        //   final newMsg = payload.newRecord;
        //   emit(state.copyWith(
        //     messages: [...state.messages, newMsg],
        //   ));
        // },
      )
          .subscribe();
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
  Future<void> sendMessage({
    required String muftiId,
    required String userName,
    required String message,
    bool isFatwa = false,
  }) async
  {
    final trimmed = message.trim();
    if (trimmed.isEmpty) return;

    final conversationId = getConversationId(muftiId, userName);

    //  temporary message (UI ke liye)
    final tempMessage = {
      'conversation_id': conversationId,
      'mufti_id': muftiId,
      'sender': 'user',
      'sender_name': userName,
      'message': trimmed,
      'is_fatwa': isFatwa,
      'created_at': DateTime.now().toIso8601String(),
    };

    try {
      //  UI par turant show karo
      emit(state.copyWith(
        messages: [...state.messages, tempMessage],
        isSending: true,
      ));

      //  backend insert
      await _supabase.from('Chat').insert({
        'conversation_id': conversationId,
        'mufti_id': muftiId,
        'sender': 'user',
        'sender_name': userName,
        'message': trimmed,
        'is_fatwa': isFatwa,
      });

      emit(state.copyWith(isSending: false));

    } catch (e) {
      emit(state.copyWith(isSending: false, error: e.toString()));
    }
  }
  //  Send fix — await properly + conversation_id bhi save hoga

  // Future<void> sendMessage({
  //   required String muftiId,
  //   required String userName,
  //   required String message,
  //   bool isFatwa = false,
  // }) async
  // {
  //   final trimmed = message.trim();
  //   if (trimmed.isEmpty) return;
  //
  //   final conversationId = getConversationId(muftiId, userName);
  //
  //   try {
  //     emit(state.copyWith(isSending: true));
  //
  //     await _supabase.from('Chat').insert({
  //       'conversation_id': conversationId,
  //       'mufti_id': muftiId,
  //       'sender': 'user',
  //       'sender_name': userName,
  //       'message': trimmed,
  //       'is_fatwa': isFatwa,
  //     });
  //
  //     // // ✅ DB se latest messages reload karo — sab kuch sync rahega
  //     // final response = await _supabase
  //     //     .from('Chat')
  //     //     .select()
  //     //     .eq('conversation_id', conversationId)
  //     //     .order('created_at', ascending: true);
  //     //
  //     // emit(state.copyWith(
  //     //   messages: List<Map<String, dynamic>>.from(response),
  //     //   isSending: false,
  //     // ));
  //
  //   } catch (e) {
  //     print("Send error: $e");
  //     emit(state.copyWith(isSending: false, error: e.toString()));
  //   }
  // }


  var p=3;
  // Future<void> sendMessage({
  //   required String muftiId,
  //   required String userName,
  //   required String message,
  //   bool isFatwa = false,
  // }) async
  // {
  //   final trimmed = message.trim();
  //   if (trimmed.isEmpty) return; // ✅ empty message block
  //
  //   final conversationId = getConversationId(muftiId, userName);
  //
  //   try {
  //     emit(state.copyWith(isSending: true));
  //
  //     await _supabase.from('Chat').insert({
  //       'conversation_id': conversationId, // ✅ unique ID save hogi
  //       'mufti_id': muftiId,
  //       'sender': 'user',
  //       'sender_name': userName,
  //       'message': trimmed,
  //       'is_fatwa': isFatwa,
  //     });
  //
  //     emit(state.copyWith(isSending: false));
  //   } catch (e) {
  //     print("Send error: $e"); // debug ke liye
  //     emit(state.copyWith(isSending: false, error: e.toString()));
  //   }
  // }

  @override
  Future<void> close() {
    _channel?.unsubscribe();
    return super.close();
  }
}

class ChatScreen extends StatelessWidget {
  final String muftiName;
  final String muftiImage;
  final String muftiStatus;
  final String muftiId;   //  int ki jagah String (DB mein text hai)
  final String userName;  // Appointment.user_name

  const ChatScreen({
    super.key,
    required this.muftiName,
    required this.muftiImage,
    required this.muftiStatus,
    required this.muftiId,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatCubit()
        ..loadMessages(
          muftiId: muftiId,
          userName: userName,
        ),
      child: _ChatView(
        muftiName: muftiName,
        muftiImage: muftiImage,
        muftiStatus: muftiStatus,
        muftiId: muftiId,
        userName: userName,
      ),
    );
  }
}

class _ChatView extends StatefulWidget {
  final String muftiName;
  final String muftiImage;
  final String muftiStatus;
  final String muftiId;
  final String userName;

  const _ChatView({
    required this.muftiName,
    required this.muftiImage,
    required this.muftiStatus,
    required this.muftiId,
    required this.userName,
  });

  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _currentTime() {
    final now = DateTime.now();
    return "${now.hour}:${now.minute.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatCubit, ChatState>(
              listener: (context, state) {
                if (!state.isLoading) _scrollToBottom();
              },
              builder: (context, state) {
                if (state.isLoading) {
                  return  Center(
                    child: spinkit,
                  );
                }

                if (state.error.isNotEmpty) {
                  return Center(
                    child: Text(
                      "Error: ${state.error}",
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                return Stack(
                  children: [
                    Center(
                      child: Opacity(
                        opacity: 0.06,
                        child: Image.asset(
                          AllImages.kahba, 
                          width: getWidth(300),),
                      ),
                    ),
                    ListView.builder(
                      controller: _scrollController,
                      padding:  EdgeInsets.symmetric(
                          horizontal: getWidth(12), 
                          vertical: getWidth(16),
                          ),
                      itemCount: state.messages.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return _buildDateLabel(
                              "Average response time: 15 minutes");
                        }
                        return _buildMessageBubble(
                            state.messages[index - 1]);
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          _buildInputBar(context),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      title: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFF5BBFB5).withOpacity(0.2),
            backgroundImage: widget.muftiImage.isNotEmpty
                ? NetworkImage(widget.muftiImage)
                : null, 
            child: widget.muftiImage.isEmpty
                ? Text(
              widget.muftiName.isNotEmpty
                  ? widget.muftiName[0].toUpperCase()
                  : "M",
              style: const TextStyle(
                  color: Color(0xFF5BBFB5),
                  fontWeight: FontWeight.w600),
            )
                : null,
          ),
           SizedBox(width: getWidth(10)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.muftiName,
                  style:  TextStyle(
                      fontSize: getFont(15),
                      fontWeight: FontWeight.w600,
                      color: Colors.black)),
              Text(widget.muftiStatus,
                  style:  TextStyle(
                      fontSize: getFont(12),
                      color: Color(0xFF5BBFB5),
                      fontWeight: FontWeight.w400)),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
            icon: const Icon(Icons.videocam_outlined, color: Colors.black),
            onPressed: () {}),
        IconButton(
            icon: const Icon(Icons.phone_outlined, color: Colors.black),
            onPressed: () {}),
      ],
    );
  }

  Widget _buildDateLabel(String text) {
    return Center(
      child: Padding(
        padding:  EdgeInsets.only(bottom: getHeight(16)),
        child: Text(text,
            style: TextStyle(
                fontSize: getFont(12),
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w400)),
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> msg) {
    // ✅ sender == 'user' means current user ka message
    final bool isMe = msg['sender'] == 'user';
   // final bool isFatwa = msg['is_fatwa'].toString() == 'true'
    final bool isFatwa = msg['is_fatwa'] ?? false;
    final String message = msg['message'] ?? '';
    final String time = msg['created_at'] != null
        ? () {
      final dt = DateTime.parse(msg['created_at']).toLocal();
      return "${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
    }()
        : _currentTime();

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin:  EdgeInsets.only(bottom: getHeight(4)),
            padding:
             EdgeInsets.symmetric(
              horizontal: getWidth(14),
               vertical: getHeight(10)),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.72),
            decoration: BoxDecoration(
              color: isMe ? const Color(0xFF5BBFB5) : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isMe ? 16 : 0),
                bottomRight: Radius.circular(isMe ? 0 : 16),
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 2))
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(message,
                    style: TextStyle(
                        fontSize: getFont(13),
                        color: isMe ? Colors.white : Colors.black87,
                        height: 1.4)),
                 SizedBox(height: getHeight(4)),
                Text(time,
                    style: TextStyle(
                        fontSize: getFont(10),
                        color: isMe
                            ? Colors.white.withOpacity(0.8)
                            : Colors.grey.shade500)),
              ],
            ),
          ),
          if (isFatwa && !isMe) ...[
             SizedBox(height: getHeight(6)),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding:  EdgeInsets.symmetric(
                    horizontal: getWidth(16),
                     vertical: getHeight(8)),
                decoration: BoxDecoration(
                    color: const Color(0xFF5BBFB5),
                    borderRadius: BorderRadius.circular(8)),
                child:  Text("Official Fatwa",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: getFont(13),
                        fontWeight: FontWeight.w500)),
              ),
            ),
             SizedBox(height: getHeight(4)),
            GestureDetector(
              onTap: () {},
              child: Container(
                width: getWidth(180),
                padding:  EdgeInsets.symmetric(
                    horizontal: getWidth(14), 
                    vertical: getHeight(10)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 4,
                        offset: const Offset(0, 2))
                  ],
                ),
                child:  Row(
                  children: [
                    Icon(Icons.download_outlined,
                        size: 18, color: Colors.black54),
                    SizedBox(width: 8),
                    Text("Download PDF",
                        style: TextStyle(
                            fontSize: getFont(13),
                            color: Colors.black87,
                            fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
            ),
          ],
           SizedBox(height: getHeight(10)),
        ],
      ),
    );
  }
  Widget _buildInputBar(BuildContext context) {
    final cubit = context.read<ChatCubit>();

    void send() {
      final text = _controller.text.trim();
      if (text.isEmpty) return; 
      cubit.sendMessage(
        muftiId: widget.muftiId,
        userName: widget.userName,
        message: text,
      );
      _controller.clear();
    }

    return Container(
      padding:  EdgeInsets.symmetric(
        horizontal: getWidth(12),
         vertical: getHeight(10)
         ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, -2),
          )
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.mic_none_outlined,
             color: Colors.black54,
              size: 26),
           SizedBox(width: getWidth(10)),
          Expanded(
            child: Container(
              padding:  EdgeInsets.symmetric(
                horizontal: getWidth(16), 
                vertical: getHeight(8)),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: _controller,
                cursorColor: const Color(0xFF5BBFB5),
                style:  TextStyle(fontSize: getFont(13)),
                decoration:  InputDecoration(
                  isDense: true,
                  hintText: "Type your question...",
                  hintStyle: TextStyle(
                    fontSize: getFont(13),
                     color: Colors.grey),
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => send(), 
              ),
            ),
          ),
           SizedBox(width: getWidth(10)),
          GestureDetector(
            onTap: send, 
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFF5BBFB5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send_rounded, 
                color: Colors.white,
                 size: 20),
            ),
          ),
        ],
      ),
    );
  }
  // Widget _buildInputBar(BuildContext context) {
  //   final cubit = context.read<ChatCubit>();
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       boxShadow: [
  //         BoxShadow(
  //             color: Colors.black.withOpacity(0.06),
  //             blurRadius: 6,
  //             offset: const Offset(0, -2))
  //       ],
  //     ),
  //     child: Row(
  //       children: [
  //         const Icon(Icons.mic_none_outlined,
  //             color: Colors.black54, size: 26),
  //         const SizedBox(width: 10),
  //         Expanded(
  //           child: Container(
  //             padding:
  //             const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //             decoration: BoxDecoration(
  //                 color: const Color(0xFFF0F0F0),
  //                 borderRadius: BorderRadius.circular(30)),
  //             child: TextField(
  //               controller: _controller,
  //               cursorColor: const Color(0xFF5BBFB5),
  //               style: const TextStyle(fontSize: 13),
  //               decoration: const InputDecoration(
  //                 isDense: true,
  //                 hintText: "Type your question...",
  //                 hintStyle:
  //                 TextStyle(fontSize: 13, color: Colors.grey),
  //                 border: InputBorder.none,
  //               ),
  //               onSubmitted: (_) {
  //                 cubit.sendMessage(
  //                   muftiId: widget.muftiId,
  //                   userName: widget.userName,
  //                   message: _controller.text,
  //                 );
  //                 _controller.clear();
  //               },
  //             ),
  //           ),
  //         ),
  //         const SizedBox(width: 10),
  //         GestureDetector(
  //           onTap: () {
  //             cubit.sendMessage(
  //               muftiId: widget.muftiId,
  //               userName: widget.userName,
  //               message: _controller.text,
  //             );
  //             _controller.clear();
  //           },
  //           child: Container(
  //             padding: const EdgeInsets.all(12),
  //             decoration: const BoxDecoration(
  //                 color: Color(0xFF5BBFB5), shape: BoxShape.circle),
  //             child: const Icon(Icons.send_rounded,
  //                 color: Colors.white, size: 20),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}







// class ChatCubit extends Cubit<ChatState> {
//   ChatCubit() : super(const ChatState());
//
//   final _supabase = Supabase.instance.client;
//   RealtimeChannel? _channel;
//
//   // ✅ Appointment table sy mufti_id aur user_name lekar
//   // Chat table sy us conversation ki messages fetch karo
//   Future<void> loadMessages({
//     required String muftiId,   // Appointment.mufti_id (int8 → String pass karo)
//     required String userName,  // Appointment.user_name
//   }) async {
//     try {
//       emit(state.copyWith(isLoading: true, error: ''));
//
//       // 🔑 Sirf is mufti aur is user ki messages
//       final response = await _supabase
//           .from('Chat')
//           .select()
//           .eq('mufti_id', muftiId)
//           .eq('sender_name', userName)
//           .order('created_at', ascending: true);
//
//       emit(state.copyWith(
//         messages: List<Map<String, dynamic>>.from(response),
//         isLoading: false,
//       ));
//
//       // 🔴 Realtime — naye messages automatically aayein
//       _channel?.unsubscribe();
//       _channel = _supabase
//           .channel('chat_${muftiId}_$userName')
//           .onPostgresChanges(
//         event: PostgresChangeEvent.insert,
//         schema: 'public',
//         table: 'Chat',
//         filter: PostgresChangeFilter(
//           type: PostgresChangeFilterType.eq,
//           column: 'mufti_id',
//           value: muftiId,
//         ),
//         callback: (payload) {
//           final newMsg = payload.newRecord;
//           // Sirf usi user ke messages show karo
//           if (newMsg['sender_name'] == userName) {
//             emit(state.copyWith(
//               messages: [...state.messages, newMsg],
//             ));
//           }
//         },
//       )
//           .subscribe();
//     } catch (e) {
//       emit(state.copyWith(isLoading: false, error: e.toString()));
//     }
//   }
//
//   Future<void> sendMessage({
//     required String muftiId,
//     required String userName,
//     required String message,
//     bool isFatwa = false,
//   }) async {
//     if (message.trim().isEmpty) return;
//     try {
//       emit(state.copyWith(isSending: true));
//
//       await _supabase.from('Chat').insert({
//         'mufti_id': muftiId,       // Appointment.mufti_id
//         'sender': 'user',
//         'sender_name': userName,   // Appointment.user_name
//         'message': message.trim(),
//         'is_fatwa': isFatwa,
//       });
//
//       emit(state.copyWith(isSending: false));
//     } catch (e) {
//       emit(state.copyWith(isSending: false, error: e.toString()));
//     }
//   }
//
//   @override
//   Future<void> close() {
//     _channel?.unsubscribe();
//     return super.close();
//   }
// }










// // ─── STATE ────────────────────────────────────────────────
// class ChatState extends Equatable {
//   final List<Map<String, dynamic>> messages;
//   final bool isLoading;
//   final bool isSending;
//   final String error;
//
//   const ChatState({
//     this.messages = const [],
//     this.isLoading = false,
//     this.isSending = false,
//     this.error = '',
//   });
//
//   ChatState copyWith({
//     List<Map<String, dynamic>>? messages,
//     bool? isLoading,
//     bool? isSending,
//     String? error,
//   }) {
//     return ChatState(
//       messages: messages ?? this.messages,
//       isLoading: isLoading ?? this.isLoading,
//       isSending: isSending ?? this.isSending,
//       error: error ?? this.error,
//     );
//   }
//
//   @override
//   List<Object?> get props => [messages, isLoading, isSending, error];
// }
//
// // ─── CUBIT ────────────────────────────────────────────────
// class ChatCubit extends Cubit<ChatState> {
//   ChatCubit() : super(const ChatState());
//
//   final _supabase = Supabase.instance.client;
//   RealtimeChannel? _channel;
//
//   // ✅ Supabase se logged-in user ki ID milti hai
//   String get currentUserId => _supabase.auth.currentUser?.id ?? '';
//
//   // ✅ Messages load karo — mufti_id aur user_id dono se filter
//   Future<void> loadMessages({
//     required int muftiId,
//     required String userId, // Supabase Auth UUID
//   }) async {
//     try {
//       emit(state.copyWith(isLoading: true, error: ''));
//
//       final response = await _supabase
//           .from('Chat')
//           .select()
//           .eq('mufti_id', muftiId)
//           .eq('user_id', userId) // 🔑 user_id se filter
//           .order('created_at', ascending: true);
//
//       emit(state.copyWith(
//         messages: List<Map<String, dynamic>>.from(response),
//         isLoading: false,
//       ));
//
//       // 🔴 Realtime subscription
//       _channel?.unsubscribe();
//       _channel = _supabase
//           .channel('chat_${muftiId}_$userId')
//           .onPostgresChanges(
//         event: PostgresChangeEvent.insert,
//         schema: 'public',
//         table: 'Chat',
//         filter: PostgresChangeFilter(
//           type: PostgresChangeFilterType.eq,
//           column: 'mufti_id',
//           value: muftiId,
//         ),
//         callback: (payload) {
//           final newMsg = payload.newRecord;
//           // Sirf usi user ke messages add karo
//           if (newMsg['user_id'] == userId) {
//             final updated = [...state.messages, newMsg];
//             emit(state.copyWith(messages: updated));
//           }
//         },
//       )
//           .subscribe();
//     } catch (e) {
//       emit(state.copyWith(isLoading: false, error: e.toString()));
//     }
//   }
//
//   // ✅ Message bhejo
//   Future<void> sendMessage({
//     required int muftiId,
//     required String userId,
//     required String senderName,
//     required String message,
//     bool isFatwa = false,
//   }) async {
//     if (message.trim().isEmpty) return;
//     try {
//       emit(state.copyWith(isSending: true));
//
//       await _supabase.from('Chat').insert({
//         'mufti_id': muftiId,
//         'user_id': userId,       // 🔑 user ka Supabase UUID
//         'sender': 'user',
//         'sender_name': senderName,
//         'message': message.trim(),
//         'is_fatwa': isFatwa,
//       });
//
//       emit(state.copyWith(isSending: false));
//     } catch (e) {
//       emit(state.copyWith(isSending: false, error: e.toString()));
//     }
//   }
//
//   @override
//   Future<void> close() {
//     _channel?.unsubscribe();
//     return super.close();
//   }
// }
//
// class ChatScreen extends StatelessWidget {
//   final String muftiName;
//   final String muftiImage;
//   final String muftiStatus;
//   final int muftiId;
//   final String userName;
//
//   const ChatScreen({
//     super.key,
//     required this.muftiName,
//     required this.muftiImage,
//     required this.muftiStatus,
//     required this.muftiId,
//     required this.userName,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     // ✅ Supabase se current user ID seedha yahan milti hai
//     final String userId =
//         Supabase.instance.client.auth.currentUser?.id ?? '';
//
//     return BlocProvider(
//       create: (_) => ChatCubit()
//         ..loadMessages(
//           muftiId: muftiId,
//           userId: userId, // 🔑 pass kar rahe hain
//         ),
//       child: _ChatView(
//         muftiName: muftiName,
//         muftiImage: muftiImage,
//         muftiStatus: muftiStatus,
//         muftiId: muftiId,
//         userName: userName,
//         userId: userId, // 🔑 view ko bhi dena hoga
//       ),
//     );
//   }
// }
//
// class _ChatView extends StatefulWidget {
//   final String muftiName;
//   final String muftiImage;
//   final String muftiStatus;
//   final int muftiId;
//   final String userName;
//   final String userId; // ✅ naya field
//
//   const _ChatView({
//     required this.muftiName,
//     required this.muftiImage,
//     required this.muftiStatus,
//     required this.muftiId,
//     required this.userName,
//     required this.userId, // ✅
//   });
//
//   @override
//   State<_ChatView> createState() => _ChatViewState();
// }






var q=9;




// class Message {
//   Message({
//     required this.told,
//   required this.msg,
//   required this.read,
//     required this.type,
//   required this.fromId,
//   required this.sent
// });
//   late final String told;
//   late final String msg;
//   late final String read;
//   late final String fromId;
//   late final String sent;
//   late final Type type;
//
// Message.fromjson(Map<String , dynamic> json){
//   told = json['told'].toString();
//   msg = json['msg'].toString();
//   read = json['read'].toString();
//   fromId = json['fromId'].toString();
//   sent = json['sent'].toString();
//   type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
//
// }
// Map<String , dynamic> toJson()
// {
//   final data = <String,dynamic>{};
//   data['told'] = told;
//   data['msg'] = msg;
//   data['read'] = read;
//   data['type'] = type.name;
//   data['fromId'] = fromId;
//   data['sent']  = sent;
//   return data;
//
//
//
// }
//
// }
// enum Type{text , image}
//
// class ChatState extends  Equatable {
//   final List<Map<String, dynamic>> messages;
//   final bool isLoading;
//   final bool isSending;
//
//   const ChatState({
//     this.messages = const [],
//     this.isLoading = false,
//     this.isSending = false,
//   });
//
//   ChatState copyWith({
//     List<Map<String, dynamic>>? messages,
//     bool? isLoading,
//     bool? isSending,
//   }) {
//     return ChatState(
//       messages: messages ?? this.messages,
//       isLoading: isLoading ?? this.isLoading,
//       isSending: isSending ?? this.isSending,
//     );
//   }
//
//   @override
//   List<Object?> get props => [messages, isLoading, isSending];
// }
//
// // ─── CHAT CUBIT ───────────────────────────────────────────
// class ChatCubit extends Cubit<ChatState> {
//   ChatCubit() : super(const ChatState());
//
//   final _supabase = Supabase.instance.client;
//   RealtimeChannel? _channel;
//
//
//   static String getconversationId(String id) =>
//       user.uid.hashcode <= id.hashCode
//           ? '${user.uid}_$id' :
//       '${id}_${user.uid}';
//
//   static Stream<QuerySnapshot<Map<String, dynamic>>> getallMessage(
//       ChatUser user) {
//     return firestore
//         .collection('chat/${getconversationId(user.id)}/message')
//         .snapshot();
//   }
//
//   static Future<void> sendmessage(ChatUser chatuser, String msg) async {
//     final time = DateTime
//         .now()
//         .millisecondsSinceEpoch
//         .toString();
//     final Message message = Message(told: chatuser.id,
//         msg: msg,
//         read: '',
//         type: Type.text,
//         fromId: user.id,
//         sent: time)
//     final ref = firestore.collection(
//         'chat/${getconversationId(user.id)}/message');
//     await ref.doc(time).set(message.toJson());
//
//
//     // 📥 Messages fetch + realtime subscribe
//     Future<void> loadMessages({
//       required int muftiId,
//       required String senderName,
//     }) async
//     {
//       try {
//         emit(state.copyWith(isLoading: true));
//
//         final response = await _supabase
//             .from('Chat')
//             .select()
//             .eq('mufti_id', muftiId)
//             .eq('sender_name', senderName)
//             .order('created_at', ascending: true);
//
//         emit(state.copyWith(
//           messages: List<Map<String, dynamic>>.from(response),
//           isLoading: false,
//         ));
//
//         // 🔴 Realtime subscribe
//         _channel = _supabase
//             .channel('chat_$muftiId')
//             .onPostgresChanges(
//           event: PostgresChangeEvent.insert,
//           schema: 'public',
//           table: 'Chat',
//           filter: PostgresChangeFilter(
//             type: PostgresChangeFilterType.eq,
//             column: 'mufti_id',
//             value: muftiId,
//           ),
//           callback: (payload) {
//             final newMsg = payload.newRecord;
//             final updated = [...state.messages, newMsg];
//             emit(state.copyWith(messages: updated));
//           },
//         )
//             .subscribe();
//       } catch (e) {
//         print("Load messages error: $e");
//         emit(state.copyWith(isLoading: false));
//       }
//     }
//
//     // 📤 Message send
//     Future<void> sendMessage({
//       required int muftiId,
//       required String senderName,
//       required String message,
//       bool isFatwa = false,
//     }) async
//     {
//       if (message
//           .trim()
//           .isEmpty) return;
//       try {
//         emit(state.copyWith(isSending: true));
//
//         await _supabase.from('Chat').insert({
//           'mufti_id': muftiId,
//           'sender': 'user',
//           'sender_name': senderName,
//           'message': message.trim(),
//           'is_fatwa': isFatwa,
//         });
//
//         emit(state.copyWith(isSending: false));
//       } catch (e) {
//         print("Send error: $e");
//         emit(state.copyWith(isSending: false));
//       }
//     }
//     @override
//     Future<void> close() {
//       _channel?.unsubscribe();
//       return super.close();
//     }
//   }
//
// }
// class ChatScreen extends StatelessWidget {
//   final String muftiName;
//   final String muftiImage;
//   final String muftiStatus;
//   final int muftiId;
//   final String userName;
//
//
//   const ChatScreen({
//     super.key,
//     required this.muftiName,
//     required this.muftiImage,
//     required this.muftiStatus,
//     required this.muftiId,
//     required this.userName,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => ChatCubit()
//         ..loadMessages(muftiId: muftiId, senderName: userName),
//       child: _ChatView(
//         muftiName: muftiName,
//         muftiImage: muftiImage,
//         muftiStatus: muftiStatus,
//         muftiId: muftiId,
//         userName: userName,
//       ),
//     );
//   }
// }

// class _ChatView extends StatefulWidget {
//   final String muftiName;
//   final String muftiImage;
//   final String muftiStatus;
//   final int muftiId;
//   final String userName;
//
//   const _ChatView({
//     required this.muftiName,
//     required this.muftiImage,
//     required this.muftiStatus,
//     required this.muftiId,
//     required this.userName,
//   });
//
//   @override
//   State<_ChatView> createState() => _ChatViewState();
// }

// class _ChatViewState extends State<_ChatView> {
//   final TextEditingController _controller = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//
//   void _scrollToBottom() {
//     Future.delayed(const Duration(milliseconds: 100), () {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }
//
//   String _currentTime() {
//     final now = DateTime.now();
//     return "${now.hour}:${now.minute.toString().padLeft(2, '0')}";
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F5),
//       appBar: _buildAppBar(),
//       body: Column(
//         children: [
//           Expanded(
//             child: BlocConsumer<ChatCubit, ChatState>(
//               listener: (context, state) {
//                 if (!state.isLoading) _scrollToBottom();
//               },
//               builder: (context, state) {
//                 if (state.isLoading) {
//                   return const Center(
//                     child: CircularProgressIndicator(
//                         color: Color(0xFF5BBFB5)),
//                   );
//                 }
//
//                 return Stack(
//                   children: [
//                     // Watermark
//                     Center(
//                       child: Opacity(
//                         opacity: 0.06,
//                         child:
//                         Image.asset(AllImages.kahba, width: 300),
//                       ),
//                     ),
//                     ListView.builder(
//                       controller: _scrollController,
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 16),
//                       itemCount: state.messages.length + 1,
//                       itemBuilder: (context, index) {
//                         if (index == 0) {
//                           return _buildDateLabel(
//                               "Average response time: 15 minutes");
//                         }
//                         final msg = state.messages[index - 1];
//                         return _buildMessageBubble(msg);
//                       },
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//           _buildInputBar(context),
//         ],
//       ),
//     );
//   }
//
//   PreferredSizeWidget _buildAppBar() {
//     return AppBar(
//       backgroundColor: Colors.white,
//       elevation: 1,
//       title: Row(
//         children: [
//           CircleAvatar(
//             radius: 20,
//             backgroundImage: NetworkImage(widget.muftiImage),
//           ),
//           const SizedBox(width: 10),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(widget.muftiName,
//                   style: const TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black)),
//               Text(widget.muftiStatus,
//                   style: const TextStyle(
//                       fontSize: 12,
//                       color: Color(0xFF5BBFB5),
//                       fontWeight: FontWeight.w400)),
//             ],
//           ),
//         ],
//       ),
//       actions: [
//         IconButton(
//             icon: const Icon(Icons.videocam_outlined, color: Colors.black),
//             onPressed: () {}),
//         IconButton(
//             icon: const Icon(Icons.phone_outlined, color: Colors.black),
//             onPressed: () {}),
//       ],
//     );
//   }
//
//   Widget _buildDateLabel(String text) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.only(bottom: 16),
//         child: Text(text,
//             style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.grey.shade500,
//                 fontWeight: FontWeight.w400)),
//       ),
//     );
//   }
//
//   Widget _buildMessageBubble(Map<String, dynamic> msg) {
//     final bool isMe = msg['sender'] == 'user';
//     final bool isFatwa = msg['is_fatwa'] ?? false;
//     final String message = msg['message'] ?? '';
//     final String time = msg['created_at'] != null
//         ? () {
//       final dt = DateTime.parse(msg['created_at']).toLocal();
//       return "${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
//     }()
//         : _currentTime();
//
//     return Align(
//       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Column(
//         crossAxisAlignment:
//         isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//         children: [
//           Container(
//             margin: const EdgeInsets.only(bottom: 4),
//             padding:
//             const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//             constraints: BoxConstraints(
//                 maxWidth: MediaQuery.of(context).size.width * 0.72),
//             decoration: BoxDecoration(
//               color: isMe ? const Color(0xFF5BBFB5) : Colors.white,
//               borderRadius: BorderRadius.only(
//                 topLeft: const Radius.circular(16),
//                 topRight: const Radius.circular(16),
//                 bottomLeft: Radius.circular(isMe ? 16 : 0),
//                 bottomRight: Radius.circular(isMe ? 0 : 16),
//               ),
//               boxShadow: [
//                 BoxShadow(
//                     color: Colors.black.withOpacity(0.06),
//                     blurRadius: 4,
//                     offset: const Offset(0, 2))
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text(message,
//                     style: TextStyle(
//                         fontSize: 13,
//                         color: isMe ? Colors.white : Colors.black87,
//                         height: 1.4)),
//                 const SizedBox(height: 4),
//                 Text(time,
//                     style: TextStyle(
//                         fontSize: 10,
//                         color: isMe
//                             ? Colors.white.withOpacity(0.8)
//                             : Colors.grey.shade500)),
//               ],
//             ),
//           ),
//
//           // Fatwa buttons
//           if (isFatwa && !isMe) ...[
//             const SizedBox(height: 6),
//             GestureDetector(
//               onTap: () {},
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 16, vertical: 8),
//                 decoration: BoxDecoration(
//                     color: const Color(0xFF5BBFB5),
//                     borderRadius: BorderRadius.circular(8)),
//                 child: const Text("Official Fatwa",
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 13,
//                         fontWeight: FontWeight.w500)),
//               ),
//             ),
//             const SizedBox(height: 4),
//             GestureDetector(
//               onTap: () {},
//               child: Container(
//                 width: 180,
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 14, vertical: 10),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8),
//                   boxShadow: [
//                     BoxShadow(
//                         color: Colors.black.withOpacity(0.08),
//                         blurRadius: 4,
//                         offset: const Offset(0, 2))
//                   ],
//                 ),
//                 child: const Row(
//                   children: [
//                     Icon(Icons.download_outlined,
//                         size: 18, color: Colors.black54),
//                     SizedBox(width: 8),
//                     Text("Download PDF",
//                         style: TextStyle(
//                             fontSize: 13,
//                             color: Colors.black87,
//                             fontWeight: FontWeight.w400)),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//           const SizedBox(height: 10),
//         ],
//       ),
//     );
//   }
// /////////////////////////////////////////////////////
//   Widget _buildInputBar(BuildContext context) {
//     final cubit = context.read<ChatCubit>();
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.06),
//             blurRadius: 6,
//             offset: const Offset(0, -2),
//           )
//         ],
//       ),
//       child: Row(
//         children: [
//           const Icon(Icons.mic_none_outlined, color: Colors.black54, size: 26),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF0F0F0),
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               child: TextField(
//                 controller: _controller,
//                 cursorColor: const Color(0xFF5BBFB5),
//                 style: const TextStyle(fontSize: 13),
//                 decoration: const InputDecoration(
//                   isDense: true,
//                   hintText: "Type your question...",
//                   hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
//                   border: InputBorder.none,
//                 ),
//                 onSubmitted: (_) {
//                   cubit.sendMessage(
//                     muftiId: widget.muftiId,
//                     userId: widget.userId,       // ✅
//                     senderName: widget.userName,
//                     message: _controller.text,
//                   );
//                   _controller.clear();
//                 },
//               ),
//             ),
//           ),
//           const SizedBox(width: 10),
//           GestureDetector(
//             onTap: () {
//               cubit.sendMessage(
//                 muftiId: widget.muftiId,
//                 userId: widget.userId,           // ✅
//                 senderName: widget.userName,
//                 message: _controller.text,
//               );
//               _controller.clear();
//             },
//             child: Container(
//               padding: const EdgeInsets.all(12),
//               decoration: const BoxDecoration(
//                 color: Color(0xFF5BBFB5),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//
//
//
// //   Widget _buildInputBar(BuildContext context) {
// //     final cubit = context.read<ChatCubit>();
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         boxShadow: [
// //           BoxShadow(
// //               color: Colors.black.withOpacity(0.06),
// //               blurRadius: 6,
// //               offset: const Offset(0, -2))
// //         ],
// //       ),
// //       child: Row(
// //         children: [
// //           const Icon(Icons.mic_none_outlined,
// //               color: Colors.black54, size: 26),
// //           const SizedBox(width: 10),
// //           Expanded(
// //             child: Container(
// //               padding:
// //               const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// //               decoration: BoxDecoration(
// //                   color: const Color(0xFFF0F0F0),
// //                   borderRadius: BorderRadius.circular(30)),
// //               child: TextField(
// //                 controller: _controller,
// //                 cursorColor: const Color(0xFF5BBFB5),
// //                 style: const TextStyle(fontSize: 13),
// //                 decoration: const InputDecoration(
// //                   isDense: true,
// //                   hintText: "Type your question...",
// //                   hintStyle:
// //                   TextStyle(fontSize: 13, color: Colors.grey),
// //                   border: InputBorder.none,
// //                 ),
// //                 onSubmitted: (_) {
// //                   cubit.sendMessage(
// //                     muftiId: widget.muftiId,
// //                     senderName: widget.userName,
// //                     message: _controller.text,
// //                   );
// //                   _controller.clear();
// //                 },
// //               ),
// //             ),
// //           ),
// //           const SizedBox(width: 10),
// //           GestureDetector(
// //             onTap: () {
// //               cubit.sendMessage(
// //                 muftiId: widget.muftiId,
// //                 senderName: widget.userName,
// //                 message: _controller.text,
// //               );
// //               _controller.clear();
// //             },
// //             child: Container(
// //               padding: const EdgeInsets.all(12),
// //               decoration: const BoxDecoration(
// //                   color: Color(0xFF5BBFB5), shape: BoxShape.circle),
// //               child: const Icon(Icons.send_rounded,
// //                   color: Colors.white, size: 20),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// }





var p=6;
// class ChatScreen extends StatefulWidget {
//   final String muftiName;
//   final String muftiImage;
//   final String muftiStatus;
//
//   const ChatScreen({
//     super.key,
//     required this.muftiName,
//     required this.muftiImage,
//     required this.muftiStatus,
//   });
//
//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _controller = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//
//   // Dummy messages — baad mein Supabase se replace karna
//   final List<Map<String, dynamic>> _messages = [
//     {
//       'text': 'Assalamu Alaikum, how can I assist you today?',
//       'isMe': false,
//       'time': '12:04',
//       'hasFatwa': true,
//     },
//     {
//       'text':
//       'Walikum Assalam Mufti Sahib, Is it to give permissible to give zakat a close relative',
//       'isMe': true,
//       'time': '12:04',
//       'hasFatwa': false,
//     },
//     {
//       'text':
//       'yes, it is permissible to give zakat to a close relative who is in need',
//       'isMe': false,
//       'time': '12:04',
//       'hasFatwa': true,
//     },
//     {
//       'text': 'JazaAllah Khair, thank you for guidance',
//       'isMe': true,
//       'time': '12:04',
//       'hasFatwa': false,
//     },
//   ];
//
//   void _sendMessage() {
//     final text = _controller.text.trim();
//     if (text.isEmpty) return;
//     setState(() {
//       _messages.add({
//         'text': text,
//         'isMe': true,
//         'time': _currentTime(),
//         'hasFatwa': false,
//       });
//       _controller.clear();
//     });
//     Future.delayed(const Duration(milliseconds: 100), () {
//       _scrollController.animateTo(
//         _scrollController.position.maxScrollExtent,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//     });
//   }
//
//   String _currentTime() {
//     final now = DateTime.now();
//     return "${now.hour}:${now.minute.toString().padLeft(2, '0')}";
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F5),
//       appBar: _buildAppBar(),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               controller: _scrollController,
//               padding: const EdgeInsets.symmetric(
//                   horizontal: 12, vertical: 16),
//               itemCount: _messages.length + 1, // +1 for date label
//               itemBuilder: (context, index) {
//                 if (index == 0) {
//                   return _buildDateLabel("Average response time: 15 minutes");
//                 }
//                 final msg = _messages[index - 1];
//                 return _buildMessageBubble(msg);
//               },
//             ),
//           ),
//
//           // ── Input Bar ──
//           _buildInputBar(),
//         ],
//       ),
//     );
//   }
//
//   // ── AppBar ──────────────────────────────────────────────
//   PreferredSizeWidget _buildAppBar() {
//     return AppBar(
//       backgroundColor: Colors.white,
//       elevation: 1,
//       // leading: IconButton(
//       //   icon: const Icon(Icons.arrow_back, color: Colors.black),
//       //   onPressed: () => Navigator.pop(context),
//       // ),
//       title: Row(
//         children: [
//           CircleAvatar(
//             radius: 20,
//             backgroundImage: NetworkImage(widget.muftiImage),
//           ),
//           const SizedBox(width: 10),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 widget.muftiName,
//                 style: const TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black),
//               ),
//               Text(
//                 widget.muftiStatus,
//                 style: const TextStyle(
//                     fontSize: 12,
//                     color: Color(0xFF5BBFB5),
//                     fontWeight: FontWeight.w400),
//               ),
//             ],
//           ),
//         ],
//       ),
//       actions: [
//         IconButton(
//           icon: const Icon(Icons.videocam_outlined, color: Colors.black),
//           onPressed: () {},
//         ),
//         IconButton(
//           icon: const Icon(Icons.phone_outlined, color: Colors.black),
//           onPressed: () {},
//         ),
//       ],
//     );
//   }
//
//   // ── Date / Info Label ───────────────────────────────────
//   Widget _buildDateLabel(String text) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.only(bottom: 16),
//         child: Text(
//           text,
//           style: TextStyle(
//               fontSize: 12,
//               color: Colors.grey.shade500,
//               fontWeight: FontWeight.w400),
//         ),
//       ),
//     );
//   }
//
//   // ── Message Bubble ──────────────────────────────────────
//   Widget _buildMessageBubble(Map<String, dynamic> msg) {
//     final bool isMe = msg['isMe'];
//     final bool hasFatwa = msg['hasFatwa'] ?? false;
//
//     return Align(
//       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Column(
//         crossAxisAlignment:
//         isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//         children: [
//           Container(
//             margin: const EdgeInsets.only(bottom: 4),
//             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//             constraints: BoxConstraints(
//               maxWidth: MediaQuery.of(context).size.width * 0.72,
//             ),
//             decoration: BoxDecoration(
//               color: isMe
//                   ? const Color(0xFF5BBFB5)
//                   : Colors.white,
//               borderRadius: BorderRadius.only(
//                 topLeft: const Radius.circular(16),
//                 topRight: const Radius.circular(16),
//                 bottomLeft: Radius.circular(isMe ? 16 : 0),
//                 bottomRight: Radius.circular(isMe ? 0 : 16),
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.06),
//                   blurRadius: 4,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text(
//                   msg['text'],
//                   style: TextStyle(
//                     fontSize: 13,
//                     color: isMe ? Colors.white : Colors.black87,
//                     height: 1.4,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   msg['time'],
//                   style: TextStyle(
//                     fontSize: 10,
//                     color: isMe
//                         ? Colors.white.withOpacity(0.8)
//                         : Colors.grey.shade500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // // ── Fatwa Buttons ──
//           // if (hasFatwa && !isMe) ...[
//           //   const SizedBox(height: 6),
//           //   _buildFatwaButton(),
//           //   const SizedBox(height: 4),
//           //  // _buildDownloadButton(),
//           // ],
//           //
//            const SizedBox(height: 10),
//         ],
//       ),
//     );
//   }
//
//   // ── Official Fatwa Badge ─────────────────────────────────
//   Widget _buildFatwaButton() {
//     return GestureDetector(
//       onTap: () {},
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//           color: const Color(0xFF5BBFB5),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: const Text(
//           "Official Fatwa",
//           style: TextStyle(
//               color: Colors.white,
//               fontSize: 13,
//               fontWeight: FontWeight.w500),
//         ),
//       ),
//     );
//   }
//
//   // ── Download PDF Button ──────────────────────────────────
//   // Widget _buildDownloadButton() {
//   //   return GestureDetector(
//   //     onTap: () {},
//   //     child: Container(
//   //       width: 180,
//   //       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//   //       decoration: BoxDecoration(
//   //         color: Colors.white,
//   //         borderRadius: BorderRadius.circular(8),
//   //         boxShadow: [
//   //           BoxShadow(
//   //             color: Colors.black.withOpacity(0.08),
//   //             blurRadius: 4,
//   //             offset: const Offset(0, 2),
//   //           ),
//   //         ],
//   //       ),
//   //       child: Row(
//   //         children: const [
//   //           Icon(Icons.download_outlined, size: 18, color: Colors.black54),
//   //           SizedBox(width: 8),
//   //           Text(
//   //             "Download PDF",
//   //             style: TextStyle(
//   //                 fontSize: 13,
//   //                 color: Colors.black87,
//   //                 fontWeight: FontWeight.w400),
//   //           ),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }
//
//   // ── Input Bar ────────────────────────────────────────────
//   Widget _buildInputBar() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.06),
//             blurRadius: 6,
//             offset: const Offset(0, -2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           // Mic
//           GestureDetector(
//             onTap: () {},
//             child: const Icon(Icons.mic_none_outlined,
//                 color: Colors.black54, size: 26),
//           ),
//           const SizedBox(width: 10),
//
//           // TextField
//           Expanded(
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF0F0F0),
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               child: TextField(
//                 controller: _controller,
//                 cursorColor: const Color(0xFF5BBFB5),
//                 style: const TextStyle(fontSize: 13),
//                 decoration: const InputDecoration(
//                   isDense: true,
//                   hintText: "Type your question...",
//                   hintStyle: TextStyle(
//                       fontSize: 13, color: Colors.grey),
//                   border: InputBorder.none,
//                 ),
//                 onSubmitted: (_) => _sendMessage(),
//               ),
//             ),
//           ),
//           const SizedBox(width: 10),
//
//           // Send Button
//           GestureDetector(
//             onTap: _sendMessage,
//             child: Container(
//               padding: const EdgeInsets.all(12),
//               decoration: const BoxDecoration(
//                 color: Color(0xFF5BBFB5),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(Icons.send_rounded,
//                   color: Colors.white, size: 20),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }