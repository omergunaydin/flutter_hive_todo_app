import 'package:flutter/material.dart';
import 'package:flutter_hive_todo_app/data/todo_hive.dart';
import 'package:flutter_hive_todo_app/models/todo_model.dart';
import 'package:flutter_hive_todo_app/utils/dimens.dart';
import 'package:flutter_hive_todo_app/views/add_todo.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:uuid/uuid.dart';
import '../widgets/notification.dart';
import '../widgets/todo_item_card.dart';
import '../utils/colors.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  final HiveDb hiveDb = HiveDb();
  final uuid = const Uuid();

  @override
  Widget build(BuildContext context) {
    AnimationController animationController = AnimationController(duration: const Duration(seconds: 2), vsync: this);

    return ValueListenableBuilder(
        valueListenable: hiveDb.listenToTodo(),
        builder: (ctx, Box<Todo> box, Widget? child) {
          var todos = box.values.toList();

          /// Sort Todo List
          todos.sort(((a, b) => b.createdAtTime.compareTo(a.createdAtTime)));

          int checkedTodos = todos.where((element) => element.isCompleted).toList().length;

          return Scaffold(
              backgroundColor: Colors.white,
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddTodoView(),
                  ));
                },
                backgroundColor: UiColorHelper.yellowColor,
                child: const Icon(
                  Icons.add,
                  color: UiColorHelper.grayColor,
                ),
              ),
              body: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: UiHelper.topPadding2x,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 10 * 6,
                          child: Image.asset(
                            'assets/images/ticktodo_banner.png',
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: UiHelper.allPadding3x,
                      child: Divider(),
                    ),
                    Padding(
                      padding: UiHelper.allPadding3x,
                      child: Row(
                        children: [
                          SizedBox(
                            height: 30,
                            width: 30,
                            child: todos.isEmpty
                                ? CircularProgressIndicator(
                                    valueColor: animationController.drive(ColorTween(begin: UiColorHelper.grayColor)),
                                    backgroundColor: UiColorHelper.yellowColor,
                                  )
                                : CircularProgressIndicator(
                                    valueColor: const AlwaysStoppedAnimation(UiColorHelper.grayColor),
                                    backgroundColor: UiColorHelper.yellowColor,
                                    value: todos.isEmpty ? 0 / 1 : checkedTodos / todos.length,
                                  ),
                          ),
                          Padding(
                            padding: UiHelper.leftPadding2x,
                            child: Text(
                              todos.isEmpty ? 'Your list is empty 🙂' : 'To Do List',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                          todos.isEmpty
                              ? const SizedBox.shrink()
                              : Padding(
                                  padding: UiHelper.leftPadding2x,
                                  child: Text(
                                    '($checkedTodos of ${todos.length})',
                                    style: Theme.of(context).textTheme.subtitle1!.copyWith(color: UiColorHelper.grayColor),
                                  ),
                                ),
                          const Spacer(),
                          todos.isEmpty
                              ? const SizedBox.shrink()
                              : Padding(
                                  padding: UiHelper.rightPadding2x,
                                  child: InkWell(
                                    onTap: () async {
                                      PanaraConfirmDialog.show(
                                        context,
                                        title: "Delete All Todos",
                                        message: "Are you sure to delete all todos?",
                                        confirmButtonText: "Confirm",
                                        cancelButtonText: "Cancel",
                                        textColor: UiColorHelper.grayColor,
                                        color: UiColorHelper.yellowColor,
                                        buttonTextColor: Colors.white,
                                        onTapCancel: () {
                                          Navigator.pop(context);
                                        },
                                        onTapConfirm: () {
                                          Navigator.pop(context);

                                          hiveDb.deleteAllTodos();

                                          showElegantNotification('Delete Todo', 'All todos deleted succesfully.', Icons.check_circle_rounded, UiColorHelper.deleteToDoColor, context);
                                        },
                                        panaraDialogType: PanaraDialogType.error,
                                        barrierDismissible: false,
                                      );
                                    },
                                    child: const CircleAvatar(
                                      backgroundColor: UiColorHelper.yellowColor,
                                      child: Icon(
                                        Icons.delete_outlined,
                                        color: UiColorHelper.grayColor,
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: todos.isEmpty
                          ? Center(
                              child: Column(
                                children: [
                                  Lottie.asset('assets/images/lottie_todosdone.json', width: MediaQuery.of(context).size.width / 10 * 7, height: MediaQuery.of(context).size.width / 10 * 7),
                                  Text(
                                    'All Todos Done!',
                                    style: Theme.of(context).textTheme.headline5,
                                  ),
                                  Padding(
                                    padding: UiHelper.topPadding1x,
                                    child: Text(
                                      'Add a todo in your To Do List',
                                      style: Theme.of(context).textTheme.subtitle1!.copyWith(color: UiColorHelper.yellowColor, fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: todos.length,
                              itemBuilder: (context, index) {
                                return Dismissible(
                                  direction: DismissDirection.horizontal,
                                  background: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.delete_outline,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        'Your Todo Item Deleted!',
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      )
                                    ],
                                  ),
                                  onDismissed: (direction) {
                                    hiveDb.deleteTodo(todo: todos[index]);
                                  },
                                  key: Key(todos[index].id),
                                  child: TodoItemCard(
                                    todo: todos[index],
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ));
        });
  }
}
