import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:newifchaly/student/views/chat_screen.dart';
import 'package:newifchaly/views/widgets/shimmer_chat_list.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class TutorChatListScreen extends StatefulWidget {
  @override
  _TutorChatListScreenState createState() => _TutorChatListScreenState();
}

class _TutorChatListScreenState extends State<TutorChatListScreen> {
  List<Map<String, dynamic>> chatList = []; 
  Map<String, Map<String, String>> userMap = {}; // Store user details
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchChatList();
    _listenForNewMessages();
  }

  Future<void> _fetchChatList() async {
    final myUserId = supabase.auth.currentUser?.id;
    if (myUserId == null) {
      Get.snackbar('Error', 'User not authenticated');
      return;
    }

    final response = await supabase
        .from('messages')
        .select('sender_id, receiver_id, content, created_at, is_read')
        .or('sender_id.eq.$myUserId,receiver_id.eq.$myUserId')
        .order('created_at', ascending: false);

    if (response == null) {
      setState(() {
        chatList = [];
        isLoading = false;
      });
      return;
    }

    Map<String, Map<String, dynamic>> uniqueChats = {};
    Set<String> userIdsToFetch = {}; // Collect unique user IDs

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
        };
        userIdsToFetch.add(chatPartnerId);
      }
    }

    // Fetch user details in one go
    final userDetails = await _fetchMultipleUserDetails(userIdsToFetch);

    setState(() {
      chatList = uniqueChats.values.toList();
      userMap = userDetails; // Store user details
      isLoading = false;
    });
  }

  void _listenForNewMessages() {
    supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .listen((_) {
      _fetchChatList();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chats')),
      body: isLoading
          ? ShimmerChatList() // Show shimmer loader until data is ready
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

    final isUnread = !chatUser['is_read'] && !chatUser['is_sender'];

    return ListTile(
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
      subtitle: Text(
        chatUser['last_message'],
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
        ),
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
    );
  }

  void _openChatScreen(String chatPartnerId) {
    _markMessagesAsRead(chatPartnerId);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(receiverId: chatPartnerId),
      ),
    ).then((_) => _fetchChatList()); // Refresh chat list on return
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
