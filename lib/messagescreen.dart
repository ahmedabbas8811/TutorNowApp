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
  List<Map<String, dynamic>> chatList =
      []; // stores students with latest messages
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchChatList();
  }

  // fetch unique students who have sent messages to this tutor
  Future<void> _fetchChatList() async {
    final myUserId = supabase.auth.currentUser?.id; // ✅ Tutor's ID
    if (myUserId == null) {
      Get.snackbar('Error', 'User not authenticated');
      return;
    }

    final response = await supabase
        .from('messages')
        .select('sender_id, content, created_at')
        .eq('receiver_id',
            myUserId) // only messages where the tutor is the receiver
        .order('created_at', ascending: false); // get latest messages first

    if (response == null) {
      setState(() {
        chatList = [];
        isLoading = false;
      });
      return;
    }

    // process data to get unique students with their latest message
    Map<String, Map<String, dynamic>> uniqueChats = {};

    for (var message in response) {
      final studentId = message['sender_id'];

      if (!uniqueChats.containsKey(studentId)) {
        uniqueChats[studentId] = {
          'student_id': studentId,
          'last_message': message['content'],
          'created_at': message['created_at'],
        };
      }
    }

    setState(() {
      chatList = uniqueChats.values.toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Student Chats')),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // ✅ Show loader
          : chatList.isEmpty
              ? Center(
                  child: Text('No chats yet.',
                      style: TextStyle(color: Colors.grey)))
              : ListView.builder(
                  itemCount: chatList.length,
                  itemBuilder: (context, index) {
                    final chatUser = chatList[index];
                    return _buildChatTile(chatUser);
                  },
                ),
    );
  }

  // builds chat list item with profile image and name
  Widget _buildChatTile(Map<String, dynamic> chatUser) {
    return FutureBuilder<Map<String, String>>(
      future:
          _fetchStudentDetails(chatUser['student_id']), // fetch name & image
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(
                  'assets/Ellipse1.png'), // show default image while loading
            ),
            title: Text('Loading...', style: TextStyle(color: Colors.grey)),
            subtitle: Text(chatUser['last_message'],
                maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: Text(_formatTimestamp(chatUser['created_at'])),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return ListTile(
            leading: CircleAvatar(
                child: Icon(Icons.error,
                    color: Colors.red)), // show error icon if failed
            title: Text('Error fetching data'),
            subtitle: Text(chatUser['last_message'],
                maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: Text(_formatTimestamp(chatUser['created_at'])),
          );
        }

        final studentName = snapshot.data!['name'] ?? 'Student';
        final studentImage = snapshot.data!['image_url'] ?? '';

        return ListTile(
          leading: CircleAvatar(
            backgroundImage: studentImage.isNotEmpty
                ? NetworkImage(studentImage) // load profile image from URL
                : AssetImage('assets/Ellipse1.png')
                    as ImageProvider, // default image if empty
          ),
          title: Text(studentName,
              style: TextStyle(
                  fontWeight: FontWeight.bold)), // show student name
          subtitle: Text(chatUser['last_message'],
              maxLines: 1, overflow: TextOverflow.ellipsis),
          trailing: Text(_formatTimestamp(chatUser['created_at'])),
          onTap: () {
            _openChatScreen(chatUser['student_id']);
          },
        );
      },
    );
  }

  // fetch student name (from metadata) & profile image (from image_url)
  Future<Map<String, String>> _fetchStudentDetails(String studentId) async {
    try {
      final response = await supabase
          .from('users')
          .select('metadata, image_url')
          .eq('id', studentId)
          .single();

      if (response == null) {
        return {'name': 'Unknown', 'image_url': ''}; 
      }

      final metadata = response['metadata']; 
      final String name = metadata is Map<String, dynamic>
          ? metadata['name'] ?? 'Unknown'
          : 'Unknown';
      final String imageUrl =
          response['image_url'] ?? ''; 

      return {'name': name, 'image_url': imageUrl};
    } catch (e) {
      print("Error fetching student details: $e");
      return {'name': 'Unknown', 'image_url': ''}; 
    }
  }

  // open chat screen
  void _openChatScreen(String studentId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(receiverId: studentId), 
      ),
    );
  }

  // format timestamp for display
  String _formatTimestamp(String timestamp) {
    final date = DateTime.parse(timestamp);
    return DateFormat('hh:mm a').format(date); 
  }
}
