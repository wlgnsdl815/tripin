class ChatRoom {
  String roomId; // 방 고유 ID
  String lastMessage; // 마지막 메시지
  int updatedAt; // 마지막 업데이트 시간 (타임스탬프)
  List<String> participants; // 참가자 UID 리스트

  ChatRoom({
    required this.roomId,
    required this.lastMessage,
    required this.updatedAt,
    required this.participants,
  });

  Map<String, dynamic> toMap() {
    return {
      'roomId': this.roomId,
      'lastMessage': this.lastMessage,
      'updatedAt': this.updatedAt,
      'participants': this.participants,
    };
  }

  factory ChatRoom.fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      roomId: map['roomId'] as String,
      lastMessage: map['lastMessage'] as String,
      updatedAt: map['updatedAt'] as int,
      participants: List<String>.from(map['participants'] as List),
    );
  }
}
