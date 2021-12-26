import 'dart:math';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:todo/provider/add_todo_provider.dart';
import 'package:provider/provider.dart';

class AddTodoScreen extends StatelessWidget {
  AddTodoScreen({Key? key}) : super(key: key);
  final titleController = TextEditingController();
  final subTitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo.withOpacity(.7),
        ),
        backgroundColor: Colors.blueGrey,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
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
                            .read<AddTodoProvider>()
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
                                  .watch<AddTodoProvider>()
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
                                            (Random().nextDouble() * 0xFFFFFF)
                                                .toInt())
                                        .withOpacity(1.0),
                                    onColorChanged: (v) {
                                      Navigator.pop(context);
                                      context
                                          .read<AddTodoProvider>()
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
                    value: context.watch<AddTodoProvider>().task.isDone,
                    onChanged: (v) => context
                        .read<AddTodoProvider>()
                        .changeData(isDone: v, notifier: true)),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: double.infinity,
                  child: MaterialButton(
                      color: Colors.indigo,
                      onPressed: () => addTask(context),
                      child: const Text('Add')),
                )
              ],
            ),
          ),
        ));
  }

  void addTask(BuildContext context) {
    final provider = context.read<AddTodoProvider>();
    if (titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('can\'t add without title.'),
        duration: Duration(seconds: 2),
      ));
    } else {
      provider.changeData(
          title: titleController.text, subTitle: subTitleController.text);
      provider.addTodo();
      titleController.clear();
      subTitleController.clear();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Todo has been Added.'),
        duration: Duration(seconds: 2),
      ));
    }
  }
}
