import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:newifchaly/student/models/message.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverName;

  const ChatScreen({Key? key, required this.receiverId, required this.receiverName}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late Stream<List<Message>> _messagesStream;
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  // fetch messages and enable real time updates
  void _fetchMessages() {
    final myUserId = supabase.auth.currentUser?.id;
    if (myUserId == null) {
      Get.snackbar('Error', 'User not authenticated');
      return;
    }

    print('Fetching messages between $myUserId and ${widget.receiverId}');

    _messagesStream = supabase
        .from('messages')
        .stream(primaryKey: ['id']) // real-time updates
        .order('created_at', ascending: true) // Correct ordering
        .map((maps) => maps
            .where((map) =>
                (map['sender_id'] == myUserId &&
                    map['receiver_id'] == widget.receiverId) ||
                (map['sender_id'] == widget.receiverId &&
                    map['receiver_id'] == myUserId)) // filter messages manually
            .map((map) => Message.fromMap(map: map, myUserId: myUserId))
            .toList());

    setState(() {});
  }

  // auto scroll to the latest message
  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  // send message to Supabase database
  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final myUserId = supabase.auth.currentUser?.id;
    if (myUserId == null) {
      Get.snackbar('Error', 'User not authenticated');
      return;
    }

    try {
      await supabase.from('messages').insert({
        'sender_id': myUserId,
        'receiver_id': widget.receiverId,
        'content': text,
        'created_at': DateTime.now().toIso8601String(), // store timestamp
      });

      _textController.clear();
    } catch (e) {
      Get.snackbar('Error', 'Failed to send message: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 232, 245, 224),
      appBar: AppBar(
        title: Text(widget.receiverName),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Message>>(
                stream: _messagesStream, // use the correct stream
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print('Error: ${snapshot.error}');
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final messages = snapshot.data ?? [];
                  if (messages.isEmpty) {
                    return Center(
                        child: Text('No messages yet. Start chatting!'));
                  }

                  WidgetsBinding.instance.addPostFrameCallback((_) =>
                      _scrollToBottom()); // auto scroll when messages update

                  return ListView.builder(
                    controller: _scrollController, // attach ScrollController
                    reverse: false, // ensures messages appear in correct order
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return _buildMessageBubble(message);
                    },
                  );
                },
              ),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  // builds chat bubbles for messages with timestamps
  Widget _buildMessageBubble(Message message) {
    final isMe = message.isMine;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isMe ? Color(0xFF87E64B) : Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              message.content,
              style: TextStyle(color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              _formatTimestamp(message.createdAt),
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  // formats timestamp to show time in "hh:mm a" format
  String _formatTimestamp(DateTime timestamp) {
    return DateFormat('hh:mm a').format(timestamp); // Example: "10:30 PM"
  }

  // builds input field and send button
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            onPressed: _sendMessage,
            icon: Icon(Icons.send, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
