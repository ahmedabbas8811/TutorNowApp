import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:newifchaly/student/views/chat_screen.dart';
import 'package:newifchaly/views/widgets/shimmer_chat_list.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class ArchivedChatsScreen extends StatefulWidget {
  @override
  _ArchivedChatsScreenState createState() => _ArchivedChatsScreenState();
}

class _ArchivedChatsScreenState extends State<ArchivedChatsScreen> {
  List<Map<String, dynamic>> archivedChatList = [];
  Map<String, Map<String, String>> userMap = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchArchivedChatList();
  }

  Future<void> _fetchArchivedChatList() async {
    final myUserId = supabase.auth.currentUser?.id;
    if (myUserId == null) {
      Get.snackbar('Error', 'User not authenticated');
      return;
    }

    final response = await supabase
        .from('messages')
        .select('sender_id, receiver_id, content, created_at, is_read, is_archived')
        .or('sender_id.eq.$myUserId,receiver_id.eq.$myUserId')
        .eq('is_archived', true) // Fetch only archived chats
        .order('created_at', ascending: false);

    if (response == null) {
      setState(() {
        archivedChatList = [];
        isLoading = false;
      });
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
        };
        userIdsToFetch.add(chatPartnerId);
      }
    }

    final userDetails = await _fetchMultipleUserDetails(userIdsToFetch);

    setState(() {
      archivedChatList = uniqueChats.values.toList();
      userMap = userDetails;
      isLoading = false;
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

  Future<void> _unarchiveChat(String chatPartnerId) async {
    final myUserId = supabase.auth.currentUser?.id;
    if (myUserId == null) return;

    // Unarchive all messages with this chat partner
    await supabase
        .from('messages')
        .update({'is_archived': false})
        .or('sender_id.eq.$myUserId,receiver_id.eq.$myUserId')
        .or('sender_id.eq.$chatPartnerId,receiver_id.eq.$chatPartnerId');

    _fetchArchivedChatList(); // Refresh the list after unarchiving
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Archived Chats')),
      body: isLoading
          ? ShimmerChatList()
          : archivedChatList.isEmpty
              ? Center(child: Text('No archived chats.', style: TextStyle(color: Colors.grey)))
              : ListView.builder(
                  itemCount: archivedChatList.length,
                  itemBuilder: (context, index) {
                    final chatUser = archivedChatList[index];
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

    return GestureDetector(
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.unarchive),
                    title: Text('Unarchive Chat'),
                    onTap: () {
                      _unarchiveChat(userId);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
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
      ),
    );
  }

  void _openChatScreen(String chatPartnerId) {
    final chatPartnerName = userMap[chatPartnerId]?['name'] ?? 'Unknown';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          receiverId: chatPartnerId,
          receiverName: chatPartnerName,
        ),
      ),
    ).then((_) => _fetchArchivedChatList());
  }

  String _formatTimestamp(String timestamp) {
    final date = DateTime.parse(timestamp);
    return DateFormat('hh:mm a').format(date);
  }
}