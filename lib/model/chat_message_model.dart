class ChatMessage {
  String messageId; // 메시지 고유 ID
  String sender; // 보낸 사람의 UID
  String text; // 메시지 내용
  int timestamp; // 메시지 전송 시간 (타임스탬프)
  Map<String, bool> isRead; // 읽음 상태

  ChatMessage({
    required this.messageId,
    required this.sender,
    required this.text,
    required this.timestamp,
    required this.isRead,
  });

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'sender': sender,
      'text': text,
      'timestamp': timestamp,
      'isRead': isRead,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      messageId: map['messageId'] as String,
      sender: map['sender'] as String,
      text: map['text'] as String,
      timestamp: map['timestamp'] as int,
      isRead:
          map['isRead'] != null ? Map<String, bool>.from(map['isRead']) : {},
    );
  }
}
