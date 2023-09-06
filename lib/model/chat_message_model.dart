class ChatMessage {
  String messageId; // 메시지 고유 ID
  String sender; // 보낸 사람의 UID
  String text; // 메시지 내용
  int timestamp; // 메시지 전송 시간 (타임스탬프)

  ChatMessage({
    required this.messageId,
    required this.sender,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'messageId': this.messageId,
      'sender': this.sender,
      'text': this.text,
      'timestamp': this.timestamp,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      messageId: map['messageId'] as String,
      sender: map['sender'] as String,
      text: map['text'] as String,
      timestamp: map['timestamp'] as int,
    );
  }
}
