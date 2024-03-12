
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/Model/TodoListModel.dart';
import 'package:todoapp/Service/DatabaseService.dart';


class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TodoAppState();
  }
}

class _TodoAppState extends State {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  List<ToDoModelClass>todoList = [];

  final GlobalKey<FormState> _fromKey = GlobalKey();

  void submit(bool doedit, [ToDoModelClass? toDoModelObj])async {
    if (titleController.text.trim().isNotEmpty &&
        descriptionController.text.trim().isNotEmpty &&
        dateController.text.trim().isNotEmpty) {
      if (!doedit) {
        var obj =  ToDoModelClass (
                    title: titleController.text.trim(),
                    description: descriptionController.text.trim(),
                    date: dateController.text.trim(),

                  );
        setState(()  {
           DatabaseService.insertData(obj);
        });
      } else {
        setState(() {
          toDoModelObj!.date = dateController.text.trim();
          toDoModelObj.title = titleController.text.trim();
          toDoModelObj.description = descriptionController.text.trim();
          DatabaseService.updateTask(toDoModelObj);
        });
      }
    }
    clearController();
  }

  void toggleisCompleted(ToDoModelClass toDoModelObj){
        toDoModelObj.date = toDoModelObj.date;
        toDoModelObj.title = toDoModelObj.title;
        toDoModelObj.description = toDoModelObj.description;
        toDoModelObj.isCompleted = toDoModelObj.isCompleted == 0? 1 : 0;

        // print("Toggle Object: ${toDoModelObj}");
        DatabaseService.updateTask(toDoModelObj);
        setState(() {
          
        });
  }

  void clearController() {
    titleController.clear();
    descriptionController.clear();
    dateController.clear();
  }

  void removeTasks(ToDoModelClass toDoModelObj) {
    DatabaseService.deleteTask(toDoModelObj.id!);
    setState(() {
    });
  }

  void editTask(ToDoModelClass toDoModelObj) {
    titleController.text = toDoModelObj.title;
    descriptionController.text = toDoModelObj.description;
    dateController.text = toDoModelObj.date;
    showBottomSheet(true, toDoModelObj);
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    dateController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:  DatabaseService.getTaskData(),
        builder: (BuildContext context,AsyncSnapshot<List<ToDoModelClass>> snapshot){
                // print("Snapshot Data: ${snapshot.data}");
                
                // if(snapshot.hasData){
                if(snapshot.data!=null){
                    todoList = snapshot.data!;
                }
                return Scaffold(
                    backgroundColor: const Color.fromRGBO(111, 81, 255, 1),
                    body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Container(
                        margin: const EdgeInsets.only(top: 80, left: 30, bottom: 50),
                        child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Text(
                                "Good Morning",
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromRGBO(255, 255, 255, 1)),
                            ),
                            Text(
                                "Rahul",
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromRGBO(255, 255, 255, 1)),
                            ),
                            ],
                        ),
                        ),
                        Expanded(
                        child: Container(
                            padding: const EdgeInsets.only(top: 20),
                            height: MediaQuery.of(context).size.height,
                            decoration: const BoxDecoration(
                            color: Color.fromRGBO(217, 217, 217, 1),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40),
                            ),
                            ),
                            child: Column(
                            children: [
                                const Row(),
                                const Text(
                                "CREATE TO DO LIST",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromRGBO(0, 0, 0, 1)),
                                ),
                                const SizedBox(
                                height: 20,
                                ),
                                Expanded(
                                child:  Container(
                                    // padding:const EdgeInsets.only(top: 40),
                                    height: MediaQuery.of(context).size.height,
                                    decoration: const BoxDecoration(
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(40),
                                        topRight: Radius.circular(40),
                                        ),
                                    ),
                                    child: ListView.builder(
                                        padding: const EdgeInsets.all(0),
                                        itemCount: todoList.length,
                                        itemBuilder: (BuildContext context, int index) {
                                            return Slidable(
                                            endActionPane: ActionPane(
                                                motion: const ScrollMotion(),
                                                children:  [
                                                    SlidableAction(
                                                    onPressed: (context) {
                                                          editTask(todoList[index]);
                                                    },
                                                    foregroundColor:
                                                        const Color.fromRGBO(111, 81, 255, 1),
                                                    icon: Icons.edit,
                                                    label: 'Edit',
                                                    ),
                                                    SlidableAction(
                                                    onPressed: (context) {
                                                        removeTasks(snapshot.data![index]);
                                                    },
                                                    foregroundColor:
                                                        const Color.fromRGBO(111, 81, 255, 1),
                                                    icon: Icons.delete,
                                                    label: 'Delete',
                                                    )
                                                ]),
                                            child: Container(
                                                padding: const EdgeInsets.all(9),
                                                margin: const EdgeInsets.only(bottom: 7),
                                                decoration: const BoxDecoration(
                                                    color: Color.fromRGBO(255, 255, 255, 1),
                                                    boxShadow: [
                                                    BoxShadow(
                                                        color:
                                                            Color.fromRGBO(217, 217, 217, 1),
                                                        offset: Offset(10, 10),
                                                        blurRadius: 9)
                                                    ]),
                                                child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                    Container(
                                                        height: 52,
                                                        width: 52,
                                                        decoration: const BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: Color.fromRGBO(
                                                                217, 217, 217, 1)),
                                                        child: Image.asset(
                                                            "assets/images/Group 42.png")),
                                                    const SizedBox(
                                                    width: 10,
                                                    ),
                                                    Expanded(
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        children: [
                                                        Text(
                                                            todoList[index].title,
                                                            style: const TextStyle(
                                                                fontSize: 11,
                                                                fontWeight: FontWeight.w500),
                                                        ),
                                                        const SizedBox(
                                                            height: 7,
                                                        ),
                                                        Row(
                                                            children: [
                                                            Expanded(
                                                                child: Text(
                                                               todoList[index].description,
                                                                style: const TextStyle(
                                                                    fontSize: 9,
                                                                    fontWeight:
                                                                        FontWeight.w400),
                                                                ),
                                                            ),
                                                            GestureDetector(
                                                                onTap: (){
                                                                    toggleisCompleted(todoList[index]);
                                                                },
                                                              child: (todoList[index].isCompleted == 1)?
                                                              const Icon(
                                                                  Icons.check_circle,
                                                                  color: Color.fromARGB(
                                                                      255, 5, 213, 113),
                                                              ):const Icon(Icons.circle_outlined),
                                                            )
                                                            ],
                                                        ),
                                                        const SizedBox(
                                                            height: 10,
                                                        ),
                                                        Text(
                                                           todoList[index].date,
                                                            style: const TextStyle(
                                                                fontSize: 8,
                                                                fontWeight: FontWeight.w400,
                                                                color: Color.fromRGBO(
                                                                    0, 0, 0, 0.7)),
                                                        )
                                                        ],
                                                    ),
                                                    )
                                                ],
                                                ),
                                            ),
                                            );
                                        }),
                                    )     
                                )
                            ],
                            ),
                        ),
                        )
                    ],
                    ),
                    floatingActionButton: FloatingActionButton(
                    backgroundColor: const Color.fromRGBO(111, 81, 255, 1),
                    foregroundColor: const Color.fromRGBO(255, 255, 255, 1),
                    onPressed: () {
                        clearController();
                        showBottomSheet(false);
                    },
                    child: const Icon(Icons.add),
                    ),
                );

                }
    //             // else{
    //             //   return const Scaffold(
    //             //     body: Center(child: CircularProgressIndicator(),),
    //             //   );
    //             // }
  
    // }
    // );
    );
  }
  

  void showBottomSheet(bool doedit, [ToDoModelClass? toDoModelObj]) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext contexr) {
          return Form(
            key: _fromKey,
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(),
                    const Center(
                      child: Text(
                        "Create To-Do ",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(0, 0, 0, 1)),
                      ),
                    ),
                    const Text(
                      "Title",
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.normal,
                          color: Color.fromRGBO(89, 57, 241, 1)),
                    ),
                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(89, 57, 241, 1))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(89, 57, 241, 1))),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(241, 57, 57, 1))),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(241, 57, 57, 1)))
                        ),

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter the title";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Description",
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.normal,
                          color: Color.fromRGBO(89, 57, 241, 1)),
                    ),
                    TextFormField(
                      controller: descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(89, 57, 241, 1))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(89, 57, 241, 1))),
                         errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(241, 57, 57, 1))),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(241, 57, 57, 1)))
                        
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter the description";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Date",
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.normal,
                          color: Color.fromRGBO(89, 57, 241, 1)),
                    ),
                    TextFormField(
                      controller: dateController,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: Color.fromRGBO(89, 57, 241, 1))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: Color.fromRGBO(89, 57, 241, 1))),
                           errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(241, 57, 57, 1))),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(241, 57, 57, 1))),
                          suffixIcon: const Icon(Icons.date_range_outlined)),
                      onTap: () async {
                        DateTime? pickeddate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2024),
                          lastDate: DateTime(2025),
                        );
                        String formatedDate =
                            DateFormat.yMMMd().format(pickeddate!);
                        setState(() {
                          dateController.text = formatedDate;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter the date";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          bool validate = _fromKey.currentState!.validate();
                          if (validate) {
                            doedit
                                ? submit(doedit, toDoModelObj)
                                : submit(doedit);
                            Navigator.pop(context);
                          }
                        },
                        child: Container(
                          width: 300,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                              color: Color.fromRGBO(89, 57, 241, 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: const Text(
                            "Submit",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color.fromRGBO(255, 255, 255, 1)),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}

