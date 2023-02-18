// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 0)
class Todo extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String subtitle;
  @HiveField(3)
  DateTime createdAtTime;
  @HiveField(4)
  bool isCompleted;

  Todo({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.createdAtTime,
    required this.isCompleted,
  });
}
