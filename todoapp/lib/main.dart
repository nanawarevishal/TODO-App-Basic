import 'package:flutter/material.dart';
import 'package:todoapp/Service/DatabaseService.dart';
import 'package:todoapp/View/todo.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized(); 
  await DatabaseService.createDatabase();

  print("Update Task: ${await DatabaseService.getTaskData()}");

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
                            
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner:false,
      home: TodoApp()
    );
  }
}
