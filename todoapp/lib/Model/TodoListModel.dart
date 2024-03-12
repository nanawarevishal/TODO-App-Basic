class ToDoModelClass {
  int? id;
  String title;
  String description;
  String date;
  int? isCompleted;
  ToDoModelClass({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    this.isCompleted = 0,
  });

  Map<String,dynamic>todoMapInsert(){
    return {
        // 'id':id,
        'title':title,
        'description':description,
        'date':date,
        'isCompleted':isCompleted
    };
  }

  // Map<String,dynamic>todoMapUpdate(){
  //   return {
  //       // 'id':id,
  //       'title':title,
  //       'description':description,
  //       'date':date,
  //       'isCompleted':isCompleted
  //   };
  // }
     
  @override
  String toString(){
      return "{ Id: $id ,Title : $title, Description: $description, date: $date,isCompleted : $isCompleted}";
  }
}
