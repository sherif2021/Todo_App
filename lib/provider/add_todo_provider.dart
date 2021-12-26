import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:todo/hive_boxes.dart';
import 'package:todo/model/task.dart';

class AddTodoProvider extends ChangeNotifier {
  Task task = Task(
      title: '',
      colorValue: (Random().nextDouble() * 0xFFFFFF).toInt(),
      time: DateTime.now(),
      isDone: false);

  void changeData({
    String? title,
    String? subTitle,
    int? colorValue,
    DateTime? time,
    bool? isDone,
    bool notifier = false,
  }) {
    task.title = title ?? task.title;
    task.subTitle = subTitle ?? task.subTitle;
    task.time = time ?? task.time;
    task.colorValue = colorValue ?? task.colorValue;
    task.isDone = isDone ?? task.isDone;

    if (notifier) notifyListeners();
  }

  void addTodo() {
    Boxes.getTask().add(task);
    task = Task(
        title: '',
        colorValue: (Random().nextDouble() * 0xFFFFFF).toInt(),
        time: DateTime.now(),
        isDone: false);
    notifyListeners();
  }
}
