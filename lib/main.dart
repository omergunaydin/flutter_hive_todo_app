import 'package:flutter/material.dart';
import 'package:flutter_hive_todo_app/data/todo_hive.dart';
import 'package:flutter_hive_todo_app/theme/theme.dart';
import 'package:flutter_hive_todo_app/views/home_view.dart';
import 'package:flutter_hive_todo_app/views/test_view.dart';
import 'package:flutter_hive_todo_app/views/welcome_view.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/todo_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init Hive DB
  await Hive.initFlutter();

  // Register Hive Adapter
  Hive.registerAdapter(TodoAdapter());

  // Open Box
  await Hive.openBox<Todo>('todosBox');
  // box = Hive.box<Todo>('todosBox');*/

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todozz App',
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.customTheme,
      home: const WelcomeView(),
    );
  }
}
