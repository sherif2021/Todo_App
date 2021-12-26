import 'package:flutter/cupertino.dart';
import 'package:todo/model/task.dart';

class UpdateTodoProvider extends ChangeNotifier {
  Task task;

  UpdateTodoProvider(this.task);

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

  void updateTask() {
    task.save();
  }
}
