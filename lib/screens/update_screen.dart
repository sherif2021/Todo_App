import 'dart:math';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:todo/model/task.dart';
import 'package:todo/provider/update_todo_provider.dart';

class UpdateTodoScreen extends StatefulWidget {
  final Task task;

  const UpdateTodoScreen({Key? key, required this.task}) : super(key: key);

  @override
  State<UpdateTodoScreen> createState() => _UpdateTodoScreenState();
}

class _UpdateTodoScreenState extends State<UpdateTodoScreen> {
  late TextEditingController titleController;
  late TextEditingController subTitleController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          backgroundColor: Colors.indigo.withOpacity(.7),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child:  Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      TextField(
                        controller: titleController,
                        decoration: InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextField(
                        controller: subTitleController,
                        decoration: InputDecoration(
                            labelText: 'Sub Title',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: DateTimePicker(
                              type: DateTimePickerType.dateTimeSeparate,
                              dateMask: 'd MMM, yyyy',
                              initialValue: DateTime.now().toString(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                              icon: const Icon(Icons.event),
                              dateLabelText: 'Date',
                              timeLabelText: "Hour",
                              selectableDayPredicate: (date) =>
                                  DateTime.now().difference(date).inDays > 0
                                      ? false
                                      : true,
                              onChanged: (value) => context
                                  .read<UpdateTodoProvider>()
                                  .changeData(time: DateTime.tryParse(value)),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          InkWell(
                            child: SizedBox(
                              width: 40,
                              height: 40,
                              child: CircleAvatar(
                                backgroundColor: Color(context
                                        .watch<UpdateTodoProvider>()
                                        .task
                                        .colorValue)
                                    .withOpacity(1),
                              ),
                            ),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                        content: BlockPicker(
                                          pickerColor: Color(
                                                  (Random().nextDouble() *
                                                          0xFFFFFF)
                                                      .toInt())
                                              .withOpacity(1.0),
                                          onColorChanged: (v) {
                                            Navigator.pop(context);
                                            context
                                                .read<UpdateTodoProvider>()
                                                .changeData(
                                                    colorValue: v.value,
                                                    notifier: true);
                                          },
                                        ),
                                      ));
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      CheckboxListTile(
                          title: const Text('is Done : '),
                          value:
                              context.watch<UpdateTodoProvider>().task.isDone,
                          onChanged: (v) => context
                              .read<UpdateTodoProvider>()
                              .changeData(isDone: v, notifier: true)),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: MaterialButton(
                            color: Colors.indigo,
                            onPressed: () => addTask(context),
                            child: const Text('Update')),
                      )
                    ],
                  ),
          ),
        ));
  }

  void addTask(BuildContext context) {
    final provider = context.read<UpdateTodoProvider>();
    if (titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('can\'t update without title.'),
        duration: Duration(seconds: 2),
      ));
    } else {

      provider.changeData(title: titleController.text, subTitle: subTitleController.text);
      provider.updateTask();

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Todo has been Updated.'),
        duration: Duration(seconds: 2),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task.title);
    subTitleController = TextEditingController(text: widget.task.subTitle);
  }

  @override
  void dispose() {
    titleController.dispose();
    subTitleController.dispose();
    super.dispose();
  }
}
