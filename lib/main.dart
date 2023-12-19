import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/todo_screen.dart';
import 'viewmodels/todo_viewmodel.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TodoViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: TodoListScreen(),
      ),
    );
  }
}