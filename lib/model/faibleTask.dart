import 'task.dart';


class faibleTask extends task {

  faibleTask(
    {
      required super.id,required super.title, 
      super.status = taskStatus.low,required super.deadLine,
      super.isCompleted = false
      }
    );


  Map<String, dynamic> tojson()=>{
    ...super.tojson(),
    'status': 'low',
  };

  factory faibleTask.fromjson(Map<String, dynamic> json){
    return faibleTask(
      id: json['id'],
      title: json['title'],
      status: taskStatus.values.firstWhere((e)=>e.name == json['status']),
      deadLine: json['deadLine'] != null ? DateTime.parse(json['deadLine']) : null,
      isCompleted: json['isCompleted'] ?? false
    );
  }
}