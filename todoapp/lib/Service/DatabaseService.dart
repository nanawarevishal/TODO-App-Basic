
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/Model/TodoListModel.dart';

class DatabaseService{

    static dynamic database;

    static  createDatabase()async{
        database = openDatabase(
            join(await getDatabasesPath(),"TodoAPPsDBs.db"),
            version: 1,
            onCreate: (db,version)async{
                await db.execute(
                    '''  CREATE TABLE Task (
                        id INTEGER PRIMARY KEY,
                        title TEXT,
                        description TEXT,
                        date TEXT,
                        isCompleted INTEGER DEFAULT 0
                    )'''
                );
            }
        );
    }

    static Future insertData(ToDoModelClass obj)async{
        final localDB = await database;
        await localDB.insert(
            "Task",
            obj.todoMapInsert(),
            conflictAlgorithm: ConflictAlgorithm.replace,
        );
    }

    static Future<List<ToDoModelClass>> getTaskData()async{

        List<ToDoModelClass>modelObj = [];
        final localDB = await database;

        List<Map<String,dynamic>>todoEntries =  await localDB.query("Task");
        print( "Entries: $todoEntries");
        for(int i=0;i<todoEntries.length;i++){
            modelObj.add(ToDoModelClass(
                id: todoEntries[i]['id'],
                title: todoEntries[i]['title'], 
                description: todoEntries[i]['description'], 
                date: todoEntries[i]['date'], 
                isCompleted: todoEntries[i]['isCompleted']
                ),
            );
        }

        return modelObj;
    }

    static Future deleteTask(int id)async{
        final localDB = await database;

        await localDB.delete(
            "Task",
            where:"id = ?",
            whereArgs:[id]
        );
    }

    static Future updateTask(ToDoModelClass obj)async{
         print("Updated Object: $obj");
        final localDB = await database;
        await localDB.update(
            "Task",
            obj.todoMapInsert(),
            where:"id = ?",
            whereArgs:[obj.id]
        );
    }

    // static Future<int> nextId() async {
    //     List<ToDoModelClass>ls = await getTaskData();

    //     if(ls.isEmpty){
    //         return 1;
    //     }

    //     int id = ls[ls.length-1].id;

    //     return id+1;
    // }
}