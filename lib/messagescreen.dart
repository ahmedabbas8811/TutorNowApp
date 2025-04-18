// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:newifchaly/archived_chat_screen.dart';
// import 'package:newifchaly/student/views/chat_screen.dart';
// import 'package:newifchaly/views/widgets/shimmer_chat_list.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// final supabase = Supabase.instance.client;

// class TutorChatListScreen extends StatefulWidget {
//   @override
//   _TutorChatListScreenState createState() => _TutorChatListScreenState();
// }

// class _TutorChatListScreenState extends State<TutorChatListScreen> {
//   List<Map<String, dynamic>> chatList = [];
//   Map<String, Map<String, String>> userMap = {};
//   bool isLoading = true;
//   late final StreamSubscription _messagesSubscription;

//   @override
//   void initState() {
//     super.initState();
//     _fetchChatList();
//     _listenForNewMessages();
//   }

//   @override
//   void dispose() {
//     // Cancel the subscription when the widget is disposed
//     _messagesSubscription.cancel();
//     super.dispose();
//   }

//   Future<void> _fetchChatList() async {
//   final myUserId = supabase.auth.currentUser?.id;
//   if (myUserId == null) {
//     Get.snackbar('Error', 'User not authenticated');
//     return;
//   }

//   final response = await supabase
//       .from('messages')
//       .select('sender_id, receiver_id, content, created_at, is_read, is_archived, pinned_by')
//       .or('sender_id.eq.$myUserId,receiver_id.eq.$myUserId')
//       .eq('is_archived', false)
//       .order('created_at', ascending: false);

//   if (response == null) {
//     if (mounted) {
//       setState(() {
//         chatList = [];
//         isLoading = false;
//       });
//     }
//     return;
//   }

//   Map<String, Map<String, dynamic>> uniqueChats = {};
//   Set<String> userIdsToFetch = {};

//   for (var message in response) {
//     final String chatPartnerId = message['sender_id'] == myUserId
//         ? message['receiver_id']
//         : message['sender_id'];

//     if (!uniqueChats.containsKey(chatPartnerId)) {
//       uniqueChats[chatPartnerId] = {
//         'chat_partner_id': chatPartnerId,
//         'last_message': message['content'],
//         'created_at': message['created_at'],
//         'is_read': message['is_read'] ?? false,
//         'is_sender': message['sender_id'] == myUserId,
//         'is_pinned': message['pinned_by'] == myUserId, // Check if the current user pinned the chat
//       };
//     } else {
//       // Update pin status if any message in the chat is pinned by the current user
//       uniqueChats[chatPartnerId]?['is_pinned'] = 
//           uniqueChats[chatPartnerId]?['is_pinned'] || (message['pinned_by'] == myUserId);
//     }
//     userIdsToFetch.add(chatPartnerId);
//   }

//   final userDetails = await _fetchMultipleUserDetails(userIdsToFetch);

//   // Separate pinned and unpinned chats
//   List<Map<String, dynamic>> pinnedChats = [];
//   List<Map<String, dynamic>> unpinnedChats = [];

//   uniqueChats.values.forEach((chat) {
//     if (chat['is_pinned']) {
//       pinnedChats.add(chat);
//     } else {
//       unpinnedChats.add(chat);
//     }
//   });

//   // Sort pinned chats by created_at (most recent first)
//   pinnedChats.sort((a, b) => b['created_at'].compareTo(a['created_at']));

//   // Sort unpinned chats by created_at (most recent first)
//   unpinnedChats.sort((a, b) => b['created_at'].compareTo(a['created_at']));

//   // Combine the lists with pinned chats at the top
//   if (mounted) {
//     setState(() {
//       chatList = [...pinnedChats, ...unpinnedChats]; // Pinned chats first, then unpinned chats
//       userMap = userDetails;
//       isLoading = false;
//     });
//   }
// }

//   void _listenForNewMessages() {
//     _messagesSubscription = supabase
//         .from('messages')
//         .stream(primaryKey: ['id'])
//         .order('created_at', ascending: false)
//         .listen((_) {
//       if (mounted) {
//         _fetchChatList();
//       }
//     });
//   }

//   Future<Map<String, Map<String, String>>> _fetchMultipleUserDetails(Set<String> userIds) async {
//     if (userIds.isEmpty) return {};

//     final response = await supabase
//         .from('users')
//         .select('id, metadata, image_url')
//         .inFilter('id', userIds.toList());

//     Map<String, Map<String, String>> userDetails = {};

//     for (var user in response) {
//       final metadata = user['metadata'];
//       userDetails[user['id']] = {
//         'name': metadata is Map<String, dynamic> ? metadata['name'] ?? 'Unknown' : 'Unknown',
//         'image_url': user['image_url'] ?? '',
//       };
//     }

//     return userDetails;
//   }

//   Future<void> _togglePinChat(String chatPartnerId, bool isPinned) async {
//     final myUserId = supabase.auth.currentUser?.id;
//     if (myUserId == null) return;

//     // Update the pinned_by column for messages where the current user is involved
//     await supabase
//         .from('messages')
//         .update({'pinned_by': isPinned ? null : myUserId})
//         .or('sender_id.eq.$myUserId,receiver_id.eq.$myUserId')
//         .or('sender_id.eq.$chatPartnerId,receiver_id.eq.$chatPartnerId')
//         .eq('sender_id', myUserId); // Only update messages sent by the current user

//     if (mounted) {
//       _fetchChatList(); // Refresh the list after pinning/unpinning
//     }
//   }

//   Future<void> _archiveChat(String chatPartnerId) async {
//     final myUserId = supabase.auth.currentUser?.id;
//     if (myUserId == null) return;

//     await supabase
//         .from('messages')
//         .update({'is_archived': true})
//         .or('sender_id.eq.$myUserId,receiver_id.eq.$myUserId')
//         .or('sender_id.eq.$chatPartnerId,receiver_id.eq.$chatPartnerId');

//     if (mounted) {
//       _fetchChatList(); // Refresh the list after archiving
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chats'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.archive),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ArchivedChatsScreen(),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: isLoading
//           ? ShimmerChatList()
//           : chatList.isEmpty
//               ? Center(child: Text('No chats yet.', style: TextStyle(color: Colors.grey)))
//               : ListView.builder(
//                   itemCount: chatList.length,
//                   itemBuilder: (context, index) {
//                     final chatUser = chatList[index];
//                     return _buildChatTile(chatUser);
//                   },
//                 ),
//     );
//   }

//   Widget _buildChatTile(Map<String, dynamic> chatUser) {
//     final userId = chatUser['chat_partner_id'];
//     final userName = userMap[userId]?['name'] ?? 'Unknown';
//     final userImage = userMap[userId]?['image_url'] ?? '';
//     final isPinned = chatUser['is_pinned'] ?? false;
//     final isUnread = !chatUser['is_read'] && !chatUser['is_sender'];

//     return GestureDetector(
//       onLongPress: () {
//         showModalBottomSheet(
//           context: context,
//           builder: (context) {
//             return Container(
//               child: Wrap(
//                 children: <Widget>[
//                   ListTile(
//                     leading: Icon(Icons.push_pin),
//                     title: Text(isPinned ? 'Unpin Chat' : 'Pin Chat'),
//                     onTap: () {
//                       _togglePinChat(userId, isPinned);
//                       Navigator.pop(context);
//                     },
//                   ),
//                   ListTile(
//                     leading: Icon(Icons.archive),
//                     title: Text('Archive Chat'),
//                     onTap: () {
//                       _archiveChat(userId);
//                       Navigator.pop(context);
//                     },
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//       child: ListTile(
//         leading: CircleAvatar(
//           backgroundImage: userImage.isNotEmpty
//               ? NetworkImage(userImage)
//               : AssetImage('assets/Ellipse1.png') as ImageProvider,
//         ),
//         title: Text(
//           userName,
//           style: TextStyle(
//             fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
//           ),
//         ),
//         subtitle: Row(
//           children: [
//             if (isPinned)
//               Padding(
//                 padding: EdgeInsets.only(right: 4),
//                 child: Icon(Icons.push_pin, size: 14, color: Colors.blue),
//               ),
//             Expanded(
//               child: Text(
//                 chatUser['last_message'],
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(
//                   fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(_formatTimestamp(chatUser['created_at'])),
//             if (isUnread)
//               const Padding(
//                 padding: EdgeInsets.only(left: 5),
//                 child: Icon(Icons.circle, color: Colors.green, size: 10),
//               ),
//           ],
//         ),
//         onTap: () {
//           _openChatScreen(userId);
//         },
//       ),
//     );
//   }

//   void _openChatScreen(String chatPartnerId) {
//     _markMessagesAsRead(chatPartnerId);

//     final chatPartnerName = userMap[chatPartnerId]?['name'] ?? 'Unknown';

//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ChatScreen(
//           receiverId: chatPartnerId,
//           receiverName: chatPartnerName,
//         ),
//       ),
//     ).then((_) {
//       if (mounted) {
//         _fetchChatList();
//       }
//     });
//   }

//   Future<void> _markMessagesAsRead(String chatPartnerId) async {
//     final myUserId = supabase.auth.currentUser?.id;
//     if (myUserId == null) return;

//     await supabase
//         .from('messages')
//         .update({'is_read': true})
//         .eq('sender_id', chatPartnerId)
//         .eq('receiver_id', myUserId)
//         .eq('is_read', false);
//   }

//   String _formatTimestamp(String timestamp) {
//     final date = DateTime.parse(timestamp);
//     return DateFormat('hh:mm a').format(date);
//   }
// }


import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:newifchaly/archived_chat_screen.dart';
import 'package:newifchaly/student/views/chat_screen.dart';
import 'package:newifchaly/views/widgets/shimmer_chat_list.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

final supabase = Supabase.instance.client;

class TutorChatListScreen extends StatefulWidget {
  @override
  _TutorChatListScreenState createState() => _TutorChatListScreenState();
}

class _TutorChatListScreenState extends State<TutorChatListScreen> {
  List<Map<String, dynamic>> chatList = [];
  Map<String, Map<String, String>> userMap = {};
  bool isLoading = true;
  late final StreamSubscription _messagesSubscription;

  @override
  void initState() {
    super.initState();
    _fetchChatList();
    _listenForNewMessages();
  }

  @override
  void dispose() {
    _messagesSubscription.cancel();
    super.dispose();
  }

  Future<void> _fetchChatList() async {
    final myUserId = supabase.auth.currentUser?.id;
    if (myUserId == null) {
      Get.snackbar('Error', 'User not authenticated');
      return;
    }

    final response = await supabase
        .from('messages')
        .select('sender_id, receiver_id, content, created_at, is_read, is_archived, pinned_by')
        .or('sender_id.eq.$myUserId,receiver_id.eq.$myUserId')
        .eq('is_archived', false)
        .order('created_at', ascending: false);

    if (response == null) {
      if (mounted) {
        setState(() {
          chatList = [];
          isLoading = false;
        });
      }
      return;
    }

    Map<String, Map<String, dynamic>> uniqueChats = {};
    Set<String> userIdsToFetch = {};

    for (var message in response) {
      final String chatPartnerId = message['sender_id'] == myUserId
          ? message['receiver_id']
          : message['sender_id'];

      if (!uniqueChats.containsKey(chatPartnerId)) {
        uniqueChats[chatPartnerId] = {
          'chat_partner_id': chatPartnerId,
          'last_message': message['content'],
          'created_at': message['created_at'],
          'is_read': message['is_read'] ?? false,
          'is_sender': message['sender_id'] == myUserId,
          'is_pinned': message['pinned_by'] == myUserId,
        };
      } else {
        uniqueChats[chatPartnerId]?['is_pinned'] = 
            uniqueChats[chatPartnerId]?['is_pinned'] || (message['pinned_by'] == myUserId);
      }
      userIdsToFetch.add(chatPartnerId);
    }

    final userDetails = await _fetchMultipleUserDetails(userIdsToFetch);

    List<Map<String, dynamic>> pinnedChats = [];
    List<Map<String, dynamic>> unpinnedChats = [];

    uniqueChats.values.forEach((chat) {
      if (chat['is_pinned']) {
        pinnedChats.add(chat);
      } else {
        unpinnedChats.add(chat);
      }
    });

    pinnedChats.sort((a, b) => b['created_at'].compareTo(a['created_at']));
    unpinnedChats.sort((a, b) => b['created_at'].compareTo(a['created_at']));

    if (mounted) {
      setState(() {
        chatList = [...pinnedChats, ...unpinnedChats];
        userMap = userDetails;
        isLoading = false;
      });
    }
  }

  void _listenForNewMessages() {
    _messagesSubscription = supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .listen((_) {
      if (mounted) {
        _fetchChatList();
      }
    });
  }

  Future<Map<String, Map<String, String>>> _fetchMultipleUserDetails(Set<String> userIds) async {
    if (userIds.isEmpty) return {};

    final response = await supabase
        .from('users')
        .select('id, metadata, image_url')
        .inFilter('id', userIds.toList());

    Map<String, Map<String, String>> userDetails = {};

    for (var user in response) {
      final metadata = user['metadata'];
      userDetails[user['id']] = {
        'name': metadata is Map<String, dynamic> ? metadata['name'] ?? 'Unknown' : 'Unknown',
        'image_url': user['image_url'] ?? '',
      };
    }

    return userDetails;
  }

  Future<void> _togglePinChat(String chatPartnerId, bool isPinned) async {
    final myUserId = supabase.auth.currentUser?.id;
    if (myUserId == null) return;

    await supabase
        .from('messages')
        .update({'pinned_by': isPinned ? null : myUserId})
        .or('sender_id.eq.$myUserId,receiver_id.eq.$myUserId')
        .or('sender_id.eq.$chatPartnerId,receiver_id.eq.$chatPartnerId')
        .eq('sender_id', myUserId);

    if (mounted) {
      _fetchChatList();
    }
  }

  Future<void> _archiveChat(String chatPartnerId) async {
    final myUserId = supabase.auth.currentUser?.id;
    if (myUserId == null) return;

    await supabase
        .from('messages')
        .update({'is_archived': true})
        .or('sender_id.eq.$myUserId,receiver_id.eq.$myUserId')
        .or('sender_id.eq.$chatPartnerId,receiver_id.eq.$chatPartnerId');

    if (mounted) {
      _fetchChatList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        actions: [
          IconButton(
            icon: Icon(Icons.archive),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArchivedChatsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? ShimmerChatList()
          : chatList.isEmpty
              ? Center(child: Text('No chats yet.', style: TextStyle(color: Colors.grey)))
              : ListView.builder(
                  itemCount: chatList.length,
                  itemBuilder: (context, index) {
                    final chatUser = chatList[index];
                    return _buildChatTile(chatUser);
                  },
                ),
    );
  }

  Widget _buildChatTile(Map<String, dynamic> chatUser) {
    final userId = chatUser['chat_partner_id'];
    final userName = userMap[userId]?['name'] ?? 'Unknown';
    final userImage = userMap[userId]?['image_url'] ?? '';
    final isPinned = chatUser['is_pinned'] ?? false;
    final isUnread = !chatUser['is_read'] && !chatUser['is_sender'];

    return GestureDetector(
      onLongPress: () {
        _showChatOptionsBottomSheet(userId, isPinned, userName);
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: userImage.isNotEmpty
              ? NetworkImage(userImage)
              : AssetImage('assets/Ellipse1.png') as ImageProvider,
        ),
        title: Text(
          userName,
          style: TextStyle(
            fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Row(
          children: [
            if (isPinned)
              Padding(
                padding: EdgeInsets.only(right: 4),
                child: Icon(Icons.push_pin, size: 14, color: Colors.blue),
              ),
            Expanded(
              child: Text(
                chatUser['last_message'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_formatTimestamp(chatUser['created_at'])),
            if (isUnread)
              const Padding(
                padding: EdgeInsets.only(left: 5),
                child: Icon(Icons.circle, color: Colors.green, size: 10),
              ),
          ],
        ),
        onTap: () {
          _openChatScreen(userId);
        },
      ),
    );
  }

  void _showChatOptionsBottomSheet(String chatPartnerId, bool isPinned, String userName) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(isPinned ? Icons.push_pin : Icons.push_pin_outlined),
                title: Text(isPinned ? 'Unpin Chat' : 'Pin Chat'),
                onTap: () {
                  _togglePinChat(chatPartnerId, isPinned);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.archive),
                title: Text('Archive Chat'),
                onTap: () {
                  _archiveChat(chatPartnerId);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.report, color: Colors.red),
                title: Text('Report User', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _navigateToReportScreen(chatPartnerId, userName);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToReportScreen(String userId, String userName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReportUserScreen(
          userId: userId,
          userName: userName,
        ),
      ),
    );
  }

  void _openChatScreen(String chatPartnerId) {
    _markMessagesAsRead(chatPartnerId);

    final chatPartnerName = userMap[chatPartnerId]?['name'] ?? 'Unknown';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          receiverId: chatPartnerId,
          receiverName: chatPartnerName,
        ),
      ),
    ).then((_) {
      if (mounted) {
        _fetchChatList();
      }
    });
  }

  Future<void> _markMessagesAsRead(String chatPartnerId) async {
    final myUserId = supabase.auth.currentUser?.id;
    if (myUserId == null) return;

    await supabase
        .from('messages')
        .update({'is_read': true})
        .eq('sender_id', chatPartnerId)
        .eq('receiver_id', myUserId)
        .eq('is_read', false);
  }

  String _formatTimestamp(String timestamp) {
    final date = DateTime.parse(timestamp);
    return DateFormat('hh:mm a').format(date);
  }
}





class ReportUserScreen extends StatefulWidget {
  final String userId;
  final String userName;

  const ReportUserScreen({
    Key? key,
    required this.userId,
    required this.userName,
  }) : super(key: key);

  @override
  _ReportUserScreenState createState() => _ReportUserScreenState();
}

class _ReportUserScreenState extends State<ReportUserScreen> {
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _commentsController = TextEditingController();
  List<XFile> _selectedImages = [];

  @override
  void dispose() {
    _reasonController.dispose();
    _commentsController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile>? images = await ImagePicker().pickMultiImage();
      if (images != null && images.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(images);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick images: $e')),
      );
    }
  }

  void _submitReport() {
    if (_reasonController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a reason for reporting')),
      );
      return;
    }

    // Here you would typically send the report to your backend
    // For example:
    // await supabase.from('reports').insert({
    //   'reporter_id': supabase.auth.currentUser?.id,
    //   'reported_user_id': widget.userId,
    //   'reason': _reasonController.text,
    //   'comments': _commentsController.text,
    //   'images': _selectedImages.map((image) => image.path).toList(),
    // });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Report submitted for ${widget.userName}')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Report User (${widget.userName})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Explain why are you reporting this user',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: _commentsController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Write your comments here',
                    hintStyle: TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    filled: true,
                    fillColor: Color(0xFFF3F3F3),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Attach images to your report',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _pickImages,
                  child: CustomPaint(
                    painter: DashedBorderPainter(),
                    child: Container(
                      height: 80,
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                            Text('Tap to upload image', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (_selectedImages.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _selectedImages.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Stack(
                            children: [
                              Image.file(
                                File(_selectedImages[index].path),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  icon: const Icon(Icons.close, color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      _selectedImages.removeAt(index);
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitReport,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff87e64c),
                      padding: const EdgeInsets.symmetric(horizontal: 93, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Colors.black),
                      ),
                    ),
                    child: const Text(
                      'Report User',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dashWidth = 7.0;
    const dashSpace = 4.0;

    double startX = 0;

    // Top border
    while (startX < size.width) {
      double endX = startX + dashWidth;
      if (endX > size.width) endX = size.width; 
      canvas.drawLine(
        Offset(startX, 0),
        Offset(endX, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    // Right border
    double startY = 0;
    while (startY < size.height - 1) {
      double endY = startY + dashWidth;
      if (endY > size.height - 1) endY = size.height - 1; 
      canvas.drawLine(
        Offset(size.width - 1, startY),
        Offset(size.width - 1, endY),
        paint,
      );
      startY += dashWidth + dashSpace;
    }

    // Bottom border
    startX = 0;
    while (startX < size.width) {
      double endX = startX + dashWidth;
      if (endX > size.width) endX = size.width; 
      canvas.drawLine(
        Offset(startX, size.height - 1),
        Offset(endX, size.height - 1),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    // Left border
    startY = 0;
    while (startY < size.height - 1) {
      double endY = startY + dashWidth;
      if (endY > size.height - 1) endY = size.height - 1; 
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, endY),
        paint,
      );
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
