import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo/hive_boxes.dart';
import 'package:todo/model/task.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/provider/add_todo_provider.dart';
import 'package:todo/provider/update_todo_provider.dart';
import 'package:todo/screens/add_screen.dart';
import 'package:todo/screens/update_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Colors.indigo,
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider(
              create: (_) => AddTodoProvider(),
              child: AddTodoScreen(),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: ValueListenableBuilder<Box<Task>>(
          valueListenable: Boxes.getTask().listenable(),
          builder: (_, box, __) {
            final tasks = box.values.toList().cast<Task>();
            if (tasks.isEmpty) {
              return Center(
                child: Text(
                  'You don\'t have any todos.',
                  style: Theme.of(context).textTheme.headline5,
                ),
              );
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'You have ${tasks.length} todos',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                const Divider(
                  height: 1,
                ),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (_, index) =>
                        _buildTask(context, tasks[index]),
                    itemCount: tasks.length,
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTask(BuildContext context, Task task) {
    return Slidable(
      actionPane: const SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Color(task.colorValue).withOpacity(1),
        ),
        title: Text(
          task.title,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
              decoration: task.isDone
                  ? TextDecoration.lineThrough
                  : TextDecoration.none),
        ),
        subtitle: Text(
          task.subTitle ?? '',
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        trailing: task.isDone
            ? const SizedBox()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      '${task.time.day}/${task.time.month}/${task.time.year.toString().substring(2, 4)}',
                      style: Theme.of(context).textTheme.overline),
                  Text(
                    '${task.time.hour}:${task.time.minute}',
                    style: Theme.of(context).textTheme.overline,
                  ),
                ],
              ),
      ),
      actions: [
        IconSlideAction(
          caption: 'Make As ${task.isDone ? 'not ' : ''} Done',
          color: Colors.black45,
          icon: Icons.update,
          onTap: () {
            task.isDone = !task.isDone;
            task.save();
          },
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Update',
          color: Colors.black45,
          icon: Icons.edit,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider(
                create: (_) => UpdateTodoProvider(task),
                child: UpdateTodoScreen(
                  task: task,
                ),
              ),
            ),
          ),
        ),
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            task.delete();
          },
        ),
      ],
    );
  }
}
