import 'package:hive/hive.dart';
import 'package:todo/model/task.dart';

class Boxes {
  static Box<Task> getTask() => Hive.box<Task>('tasks');
}
