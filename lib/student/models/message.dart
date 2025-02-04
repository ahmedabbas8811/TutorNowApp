class Message {
  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.createdAt,
    required this.isMine,
  });

  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime createdAt;
  final bool isMine;

  factory Message.fromMap(
      {required Map<String, dynamic> map, required String myUserId}) {
    return Message(
      id: map['id'].toString(), // ✅ Convert `id` from int to String
      senderId: map['sender_id'].toString(), // ✅ Ensure sender_id is a string
      receiverId:
          map['receiver_id'].toString(), // ✅ Ensure receiver_id is a string
      content: map['content'],
      createdAt: DateTime.parse(map['created_at']),
      isMine: myUserId ==
          map['sender_id'].toString(), // ✅ Ensure correct comparison
    );
  }
}
