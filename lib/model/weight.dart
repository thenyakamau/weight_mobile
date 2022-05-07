import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Weight {
  final String id;
  final DateTime time;
  final double weight;
  final String? uuid;

  Weight({
    required this.id,
    required this.time,
    required this.weight,
    this.uuid,
  });

  Weight.create(this.weight)
      : time = DateTime.now(),
        uuid = null,
        id = Uuid().v4();

  Weight copyWith({
    String? id,
    DateTime? time,
    double? weight,
    String? uuid,
  }) {
    return Weight(
      id: id ?? this.id,
      time: time ?? this.time,
      weight: weight ?? this.weight,
      uuid: uuid ?? this.uuid,
    );
  }

  factory Weight.fromFirestore(DocumentSnapshot doc) =>
      Weight.fromMap(doc.data() as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'time': time.millisecondsSinceEpoch});
    result.addAll({'weight': weight});
    if (uuid != null) {
      result.addAll({'uuid': uuid});
    }

    return result;
  }

  factory Weight.fromMap(Map<String, dynamic> map) {
    return Weight(
      id: map['id'] ?? '',
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
      weight: map['weight']?.toDouble() ?? 0.0,
      uuid: map['uuid'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Weight.fromJson(String source) => Weight.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Weight(id: $id, time: $time, weight: $weight, uuid: $uuid)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Weight &&
        other.id == id &&
        other.time == time &&
        other.weight == weight &&
        other.uuid == uuid;
  }

  @override
  int get hashCode {
    return id.hashCode ^ time.hashCode ^ weight.hashCode ^ uuid.hashCode;
  }
}
