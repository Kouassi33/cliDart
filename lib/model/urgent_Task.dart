import 'task.dart';


class urgentTask extends task {

  urgentTask(
    {
      required super.id,required super.title, 
      super.status = taskStatus.high,required super.deadLine,
      super.isCompleted = false
      }
    ):assert(deadLine != null, "Urgent task must have a deadline");


  Map<String, dynamic> tojson()=>{
    ...super.tojson(),
    'status': 'high',
  };

  factory urgentTask.fromjson(Map<String, dynamic> json){
    return urgentTask(
      id: json['id'],
      title: json['title'],
      status: taskStatus.values.firstWhere((e)=>e.name == json['status']),
      deadLine: json['deadLine'] != null ? DateTime.parse(json['deadLine']) : null,
      isCompleted: json['isCompleted'] ?? false
    );
  }
}