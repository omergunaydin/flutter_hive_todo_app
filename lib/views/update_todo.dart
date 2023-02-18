import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hive_todo_app/utils/colors.dart';
import 'package:flutter_hive_todo_app/utils/dimens.dart';
import 'package:intl/intl.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:uuid/uuid.dart';

import '../data/todo_hive.dart';
import '../models/todo_model.dart';
import '../widgets/notification.dart';

class UpdateTodoView extends StatefulWidget {
  UpdateTodoView({Key? key, required this.todo}) : super(key: key);

  final Todo todo;

  @override
  State<UpdateTodoView> createState() => _AddTodoViewState();
}

class _AddTodoViewState extends State<UpdateTodoView> {
  bool titleClicked = false;
  bool subtitleClicked = false;
  bool updateTodoButtonEnabled = true;
  bool deleteTodoButtonEnabled = true;

  late DateTime selectedDate;
  late String title;
  late String subtitle;

  final HiveDb hiveDb = HiveDb();
  final uuid = const Uuid();

  final TextEditingController _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _selectedDateController = TextEditingController(text: DateTime.now().toString());

  @override
  void initState() {
    super.initState();
    //_titleController = TextEditingController(text: 'sdadadad');
    _titleController.text = widget.todo.title;
    _subtitleController.text = widget.todo.subtitle;
    _selectedDateController.text = widget.todo.createdAtTime.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Update Todo',
          style: Theme.of(context).textTheme.headline5,
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Padding(
        padding: UiHelper.allPadding3x,
        child: Column(
          children: [
            Padding(
              padding: UiHelper.verticalSymmetricPadding4x,
              child: Text(
                '😇 Want to update your todo ?',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  color: titleClicked ? UiColorHelper.cardBgColor : UiColorHelper.cardColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                  child: Focus(
                    child: TextFormField(
                      controller: _titleController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(border: InputBorder.none, hintText: 'Title'),
                    ),
                    onFocusChange: (hasFocus) {
                      if (hasFocus) {
                        setState(() {
                          titleClicked = !titleClicked;
                        });
                      } else {
                        setState(() {
                          titleClicked = !titleClicked;
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  color: subtitleClicked ? UiColorHelper.cardBgColor : UiColorHelper.cardColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                  child: Focus(
                    child: TextFormField(
                      controller: _subtitleController,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Add Note',
                      ),
                      minLines: 8,
                      maxLines: 8,
                    ),
                    onFocusChange: (hasFocus) {
                      if (hasFocus) {
                        setState(() {
                          subtitleClicked = !subtitleClicked;
                        });
                      } else {
                        setState(() {
                          subtitleClicked = !subtitleClicked;
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: UiHelper.allPadding4x,
              child: DateTimePicker(
                  controller: _selectedDateController,
                  type: DateTimePickerType.dateTimeSeparate,
                  //initialValue: DateTime.now().toString(),
                  dateMask: 'dd / MM / yyyy',
                  firstDate: DateTime(2022),
                  lastDate: DateTime(2100),
                  dateLabelText: 'Date',
                  timeLabelText: 'Time',
                  style: const TextStyle(color: UiColorHelper.grayColor),
                  onChanged: (val) => print(val),
                  validator: (val) {
                    print(val);
                    return null;
                  },
                  onSaved: (val) {
                    print('datetime -->' + val.toString());
                  }),
            ),
            Padding(
              padding: UiHelper.allPadding4x,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: updateTodoButtonEnabled
                      ? () {
                          selectedDate = DateFormat('yyyy-MM-dd HH:mm').parse(_selectedDateController.text);
                          title = _titleController.text.toString();
                          subtitle = _subtitleController.text.toString();
                          FocusManager.instance.primaryFocus?.unfocus();

                          PanaraConfirmDialog.show(
                            context,
                            title: "Update Todo",
                            message: "Are you sure to update Todo?",
                            confirmButtonText: "Confirm",
                            cancelButtonText: "Cancel",
                            textColor: UiColorHelper.grayColor,
                            color: UiColorHelper.yellowColor,
                            buttonTextColor: UiColorHelper.grayColor,
                            onTapCancel: () {
                              updateTodoButtonEnabled = true;
                              deleteTodoButtonEnabled = true;
                              Navigator.pop(context);
                            },
                            onTapConfirm: () {
                              updateTodoButtonEnabled = false;
                              deleteTodoButtonEnabled = false;
                              Navigator.pop(context);
                              widget.todo.title = title;
                              widget.todo.subtitle = subtitle;
                              widget.todo.createdAtTime = selectedDate;
                              hiveDb.updateTodo(todo: widget.todo);
                              showElegantNotification('Update Todo', 'Your Todo is updated succesfully.', Icons.check_circle_rounded, UiColorHelper.updateToDoColor, context);
                              Future.delayed(
                                const Duration(milliseconds: 2500),
                                () {
                                  Navigator.pop(context);
                                },
                              );
                            },
                            panaraDialogType: PanaraDialogType.custom,
                            barrierDismissible: false, // optional parameter (default is true)
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: UiHelper.borderRadiusCircular3x),
                  ),
                  child: Padding(
                    padding: UiHelper.verticalSymmetricPadding3x,
                    child: Text(
                      'Update Todo',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: UiHelper.horizontalSymmetricPadding6x,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: deleteTodoButtonEnabled
                      ? () {
                          updateTodoButtonEnabled = false;
                          deleteTodoButtonEnabled = false;
                          PanaraConfirmDialog.show(
                            context,
                            title: "Delete Todo",
                            message: "Are you sure to delete Todo?",
                            confirmButtonText: "Confirm",
                            cancelButtonText: "Cancel",
                            textColor: UiColorHelper.grayColor,
                            color: UiColorHelper.yellowColor,
                            buttonTextColor: Colors.white,
                            onTapCancel: () {
                              updateTodoButtonEnabled = true;
                              deleteTodoButtonEnabled = true;
                              Navigator.pop(context);
                            },
                            onTapConfirm: () {
                              updateTodoButtonEnabled = false;
                              deleteTodoButtonEnabled = false;
                              Navigator.pop(context);

                              widget.todo.delete();

                              showElegantNotification('Delete Todo', 'Your Todo is deleted succesfully.', Icons.check_circle_rounded, UiColorHelper.deleteToDoColor, context);
                              Future.delayed(
                                const Duration(milliseconds: 2500),
                                () {
                                  Navigator.pop(context);
                                },
                              );
                            },
                            panaraDialogType: PanaraDialogType.error,
                            barrierDismissible: false, // optional parameter (default is true)
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    primary: UiColorHelper.defaultBgColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: UiHelper.borderRadiusCircular3x,
                      side: const BorderSide(width: 1.2, color: UiColorHelper.grayColor),
                    ),
                  ),
                  child: Padding(
                    padding: UiHelper.verticalSymmetricPadding3x,
                    child: Text(
                      'X Delete Todo',
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(color: UiColorHelper.grayColor),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
