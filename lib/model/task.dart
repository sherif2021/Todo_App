
import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String? subTitle = "";

  @HiveField(2, defaultValue: false)
  bool isDone = false;

  @HiveField(3)
  DateTime time;

  @HiveField(4)
  int colorValue;

  Task(
      {required this.title,
      this.subTitle,
      required this.isDone,
      required this.time,
      required this.colorValue});
}
