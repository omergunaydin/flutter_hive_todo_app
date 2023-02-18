import 'package:date_time_picker/date_time_picker.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hive_todo_app/utils/colors.dart';
import 'package:flutter_hive_todo_app/utils/dimens.dart';
import 'package:intl/intl.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:uuid/uuid.dart';

import '../data/todo_hive.dart';
import '../models/todo_model.dart';
import '../widgets/notification.dart';

class AddTodoView extends StatefulWidget {
  AddTodoView({Key? key}) : super(key: key);

  @override
  State<AddTodoView> createState() => _AddTodoViewState();
}

class _AddTodoViewState extends State<AddTodoView> {
  bool titleClicked = false;
  bool subtitleClicked = false;
  bool addTodoButtonEnabled = true;

  late DateTime selectedDate;
  late String title;
  late String subtitle;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  final TextEditingController _selectedDateController = TextEditingController(text: DateTime.now().toString());

  final HiveDb hiveDb = HiveDb();
  final uuid = const Uuid();

  @override
  Widget build(BuildContext context) {
    @override
    void initState() {
      super.initState();
      // _selectedDateController.text = DateTime.now().toString();
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Add Todo',
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
                '😇 What are you planning ?',
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
                  style: TextStyle(color: UiColorHelper.grayColor),
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
                  onPressed: addTodoButtonEnabled
                      ? () {
                          selectedDate = DateFormat('yyyy-MM-dd HH:mm').parse(_selectedDateController.text);

                          title = _titleController.text.toString();
                          subtitle = _subtitleController.text.toString();

                          FocusManager.instance.primaryFocus?.unfocus();

                          addTodoButtonEnabled = false;

                          hiveDb.addTodo(todo: Todo(id: uuid.v4(), title: title, subtitle: subtitle, createdAtTime: selectedDate, isCompleted: false)).whenComplete(() {
                            showElegantNotification('Add Todo', 'Your Todo is added succesfully.', Icons.check_circle_rounded, UiColorHelper.addToDoColor, context);
                            Future.delayed(
                              const Duration(milliseconds: 2500),
                              () {
                                Navigator.pop(context);
                              },
                            );
                          });
                        }
                      : null,
                  style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: UiHelper.borderRadiusCircular3x)),
                  child: Padding(
                    padding: UiHelper.verticalSymmetricPadding3x,
                    child: Text(
                      'Add Todo',
                      style: Theme.of(context).textTheme.headline6,
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


 /* PanaraInfoDialog.showAnimatedGrow(
                        context,
                        title: "Add Todo",
                        message: "Your Todo is added succesfully.",
                        buttonText: "Okay",
                        textColor: UiColorHelper.grayColor,
                        color: UiColorHelper.yellowColor,
                        buttonTextColor: UiColorHelper.grayColor,
                        onTapDismiss: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        panaraDialogType: PanaraDialogType.custom,
                        barrierDismissible: false,
                      );  */