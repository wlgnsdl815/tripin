import 'package:cloud_firestore/cloud_firestore.dart';

class Description {
  final String memo;
  final String uid;
  final Timestamp timestamp;
  final String markerId;
  final String roomId;

  Description({
    required this.memo,
    required this.uid,
    required this.timestamp,
    required this.markerId,
    required this.roomId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'memo': memo,
      'uid': uid,
      'timestamp': timestamp,
      'markerId': markerId,
      'roomId': roomId,
    };
  }

  factory Description.fromMap(Map<String, dynamic> map) {
    return Description(
      memo: map['memo'] as String,
      uid: map['uid'] as String,
      timestamp: map['timestamp'] as Timestamp,
      markerId: map['markerId'] as String,
      roomId: map['roomId'] as String,
    );
  }
}
