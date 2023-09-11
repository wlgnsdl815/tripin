// ignore_for_file: public_member_api_docs, sort_constructors_first
class ChatRoom {
  String roomId; // 방 고유 ID
  String lastMessage; // 마지막 메시지
  int updatedAt; // 마지막 업데이트 시간 (타임스탬프)
  List<String> participants; // 참가자 UID 리스트
  int? startDate;
  int? endDate;
  String city;
  List<int> dateRange;

  ChatRoom({
    required this.roomId,
    required this.lastMessage,
    required this.updatedAt,
    required this.participants,
    this.startDate,
    this.endDate,
    required this.city,
    required this.dateRange,
  });

  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'lastMessage': lastMessage,
      'updatedAt': updatedAt,
      'participants': participants,
      'startDate': startDate,
      'endDate': endDate,
      'city': city,
      'dateRange': dateRange
    };
  }

  factory ChatRoom.fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      roomId: map['roomId'] as String,
      lastMessage: map['lastMessage'] as String,
      updatedAt: map['updatedAt'] as int,
      participants: List<String>.from(map['participants'] as List),
      startDate: map['startDate'] as int?, // startDate 추가
      endDate: map['endDate'] as int?, city: map['city'] ?? '',
      dateRange: map['dateRange'] ?? [],
    );
  }
}
