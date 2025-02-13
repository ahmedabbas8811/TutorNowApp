import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:newifchaly/student/views/chat_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class TutorChatListScreen extends StatefulWidget {
  @override
  _TutorChatListScreenState createState() => _TutorChatListScreenState();
}

class _TutorChatListScreenState extends State<TutorChatListScreen> {
  List<Map<String, dynamic>> chatList = []; 
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchChatList();
    _listenForNewMessages();
  }

  // fetch chats with latest message for each student tutor conversation
  Future<void> _fetchChatList() async {
    final myUserId = supabase.auth.currentUser?.id;
    if (myUserId == null) {
      Get.snackbar('Error', 'User not authenticated');
      return;
    }

    final response = await supabase
        .from('messages')
        .select('sender_id, receiver_id, content, created_at, is_read')
        .or('sender_id.eq.$myUserId,receiver_id.eq.$myUserId') // Fetch both sent & received messages
        .order('created_at', ascending: false); // Get latest messages first

    if (response == null) {
      setState(() {
        chatList = [];
        isLoading = false;
      });
      return;
    }

    Map<String, Map<String, dynamic>> uniqueChats = {};

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
      }
    }

    setState(() {
      chatList = uniqueChats.values.toList();
      isLoading = false;
    });
  }

  // listen for new messages and update UI dynamically
  void _listenForNewMessages() {
    supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .listen((_) {
      _fetchChatList(); // refresh chat list when a new message is received
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chats')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
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

  // build chat list tile
  Widget _buildChatTile(Map<String, dynamic> chatUser) {
    return FutureBuilder<Map<String, String>>(
      future: _fetchUserDetails(chatUser['chat_partner_id']),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListTile(
            leading: CircleAvatar(backgroundImage: AssetImage('assets/Ellipse1.png')),
            title: Text('Loading...', style: TextStyle(color: Colors.grey)),
            subtitle: Text(chatUser['last_message'],
                maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: Text(_formatTimestamp(chatUser['created_at'])),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return ListTile(
            leading: CircleAvatar(child: Icon(Icons.error, color: Colors.red)),
            title: Text('Error fetching data'),
            subtitle: Text(chatUser['last_message'],
                maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: Text(_formatTimestamp(chatUser['created_at'])),
          );
        }

        final userName = snapshot.data!['name'] ?? 'User';
        final userImage = snapshot.data!['image_url'] ?? '';
        final isUnread = !chatUser['is_read'] && !chatUser['is_sender']; // Unread if received and is_read=false

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
            _openChatScreen(chatUser['chat_partner_id']);
          },
        );
      },
    );
  }

  // fetch user details (name and image)
  Future<Map<String, String>> _fetchUserDetails(String userId) async {
    try {
      final response = await supabase
          .from('users')
          .select('metadata, image_url')
          .eq('id', userId)
          .single();

      if (response == null) return {'name': 'Unknown', 'image_url': ''};

      final metadata = response['metadata'];
      final String name = metadata is Map<String, dynamic> ? metadata['name'] ?? 'Unknown' : 'Unknown';
      final String imageUrl = response['image_url'] ?? '';

      return {'name': name, 'image_url': imageUrl};
    } catch (e) {
      return {'name': 'Unknown', 'image_url': ''};
    }
  }

  // open chat screen and mark messages as read
  void _openChatScreen(String chatPartnerId) {
    _markMessagesAsRead(chatPartnerId);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(receiverId: chatPartnerId),
      ),
    ).then((_) => _fetchChatList()); // refresh chat list on return
  }

  // mark messages as read in the database
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

  // format timestamp
  String _formatTimestamp(String timestamp) {
    final date = DateTime.parse(timestamp);
    return DateFormat('hh:mm a').format(date);
  }
}
