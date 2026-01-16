import 'package:flutter/material.dart';

class Note {
  final int? id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime? deadline;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.deadline,
  });

  factory Note.fromMap(Map<String, Object?> map) {
    final dl = map['deadline'] as int?;
    return Note(
      id: map['id'] as int?,
      title: map['title'] as String,
      content: map['content'] as String,
      createdAt: DateTime.fromMicrosecondsSinceEpoch(map['createdAt'] as int),
      deadline: dl == null ? null : DateTime.fromMicrosecondsSinceEpoch(dl),
    );
  }
  Map<String, Object?> toMap() => {
    'id': id,
    'title': title,
    'content': content,
    'deadline': deadline?.microsecondsSinceEpoch,
    'createdAt': createdAt.microsecondsSinceEpoch,
  };
}

Color noteColorByDeadline(DateTime? deadline) {
  if (deadline == null) return Colors.yellow.shade300;

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final dl = DateTime(deadline.year, deadline.month, deadline.day);

  final diffDays = dl.difference(today).inDays;

  if (diffDays < 0) return Colors.red.shade900;
  if (diffDays <= 1) return Colors.red.shade400;
  if (diffDays <= 3) return Colors.orange.shade400;
  if (diffDays <= 7) return Colors.lightGreen.shade400;
  return Colors.green.shade400;
}
