

import 'package:dart_cli/model/task.dart';

class NormalTask extends Task {

  NormalTask(
    {
      required super.id,required super.title, 
      super.status = TaskStatus.medium,required super.deadLine,
      super.isCompleted = false
      }
    );


  Map<String, dynamic> tojson()=>{
    ...super.tojson(),
    'status': 'medium',
  };

  factory NormalTask.fromjson(Map<String, dynamic> json){
    return NormalTask(
      id: json['id'],
      title: json['title'],
      status: TaskStatus.values.firstWhere((e)=>e.name == json['status']),
      deadLine: json['deadLine'] != null ? DateTime.parse(json['deadLine']) : null,
      isCompleted: json['isCompleted'] ?? false
    );
  }
}