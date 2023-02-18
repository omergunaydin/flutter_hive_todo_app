import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hive_todo_app/views/update_todo.dart';

import '../models/todo_model.dart';
import '../utils/constants.dart';
import '../utils/dimens.dart';
import '../utils/colors.dart';

class TodoItemCard extends StatelessWidget {
  const TodoItemCard({
    Key? key,
    required this.todo,
  }) : super(key: key);

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: UiHelper.cardPadding,
      child: AnimatedContainer(
        duration: Constants.durationLow,
        decoration: BoxDecoration(
          color: todo.isCompleted ? UiColorHelper.cardBgColor : UiColorHelper.cardColor,
          borderRadius: UiHelper.borderRadiusCircular4x,
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => UpdateTodoView(todo: todo),
            ));
          },
          child: ListTile(
            horizontalTitleGap: 5,
            leading: InkWell(
              onTap: () {
                todo.isCompleted = !todo.isCompleted;
                todo.save();
              },
              child: AnimatedContainer(
                duration: Constants.durationLow,
                decoration: BoxDecoration(
                  color: todo.isCompleted ? UiColorHelper.cardCheckedColor : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                ),
              ),
            ),
            title: Padding(
              padding: UiHelper.topPadding2x,
              child: Text(
                todo.title,
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: todo.isCompleted ? UiColorHelper.cardCheckedColor : UiColorHelper.grayColor,
                      decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                    ),
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  todo.subtitle,
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: todo.isCompleted ? UiColorHelper.cardCheckedColor : UiColorHelper.grayColor,
                        decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                      ),
                ),
                Padding(
                  padding: UiHelper.allPadding2x,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      children: [
                        Text(
                          formatDate(todo.createdAtTime, [HH, ':', nn]),
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                color: todo.isCompleted ? UiColorHelper.cardCheckedColor : UiColorHelper.grayColor,
                                decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                              ),
                        ),
                        Text(
                          formatDate(todo.createdAtTime, [dd, '-', mm, '-', yyyy]),
                          style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                color: todo.isCompleted ? UiColorHelper.cardCheckedColor : UiColorHelper.grayColor,
                                decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
