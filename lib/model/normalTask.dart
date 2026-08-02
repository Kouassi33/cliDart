import 'task.dart';


class normalTask extends task {

  normalTask(
    {
      required super.id,required super.title, 
      super.status = taskStatus.medium,required super.deadLine,
      super.isCompleted = false
      }
    );


  Map<String, dynamic> tojson()=>{
    ...super.tojson(),
    'status': 'medium',
  };

  factory normalTask.fromjson(Map<String, dynamic> json){
    return normalTask(
      id: json['id'],
      title: json['title'],
      status: taskStatus.values.firstWhere((e)=>e.name == json['status']),
      deadLine: json['deadLine'] != null ? DateTime.parse(json['deadLine']) : null,
      isCompleted: json['isCompleted'] ?? false
    );
  }
}