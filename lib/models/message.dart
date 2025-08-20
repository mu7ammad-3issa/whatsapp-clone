class ChatMessage {
  final String id;
  final String content;
  final DateTime timestamp;
  final bool isOutgoing;
  final MessageType type;
  MessageStatus status; // Made mutable
  final String? replyTo;

  ChatMessage({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.isOutgoing,
    this.type = MessageType.text,
    this.status = MessageStatus.sent,
    this.replyTo,
  });
}

enum MessageType {
  text,
  image,
  voice,
  video,
  document,
}

enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
}
