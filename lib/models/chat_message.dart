class ChatMessage {
  final String id;
  final String chatId;
  final String senderId;
  final String text;
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.text,
    required this.createdAt,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map, {String? id}) {
    return ChatMessage(
      id: id ?? map['\$id'] ?? '',
      chatId: map['chatId'] ?? '',
      senderId: map['senderId'] ?? '',
      text: map['text'] ?? '',
      createdAt: map['\$createdAt'] != null
          ? DateTime.parse(map['\$createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {'chatId': chatId, 'senderId': senderId, 'text': text};
  }
}
