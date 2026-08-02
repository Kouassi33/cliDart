import 'faibleTask.dart';
import 'normalTask.dart';
import 'task_exception.dart';
import 'urgent_Task.dart';
//import 'dart:convert';

enum taskStatus {low,medium,high }

abstract class Serializable {
  Map<String, dynamic> tojson();
}

abstract class task implements Serializable, Comparable<task> {
  final int id;
  String title;
  taskStatus status;
  DateTime? deadLine;
  bool isCompleted;

  task(
    {
      required this.title, required this.id, 
      this.status = taskStatus.medium, this.isCompleted = false,
      this.deadLine
    }
  );

  bool isOverdue(){
    if(deadLine == null || isCompleted){
      return false;
    }
    return deadLine!.isBefore(DateTime.now());
  }

  @override
  int compareTo(task other){

    int priorityOrder(taskStatus p){

      if(p == taskStatus.low){

        return 0;

      }else if(p == taskStatus.medium){

        return 1;

      }else{

        return 2;

      }
      
    }

  int cmp = priorityOrder(status).compareTo(priorityOrder(other.status));
  if(cmp !=0)return cmp;

  if(deadLine != null && other.deadLine !=null){
    return deadLine!.compareTo(other.deadLine!);
  }else if(deadLine == null && other.deadLine != null){
    return 1;
  }else if(deadLine != null && other.deadLine == null){
    return -1;
  }

  return title.compareTo(other.title);
  }


  @override
  Map<String, dynamic> tojson() =>{
    'id':id,
    'title':title,
    'status':status,
    'deadLine':deadLine?.toIso8601String(),
    'isCompleted':isCompleted,
  };

  static task fromJson(Map<String, dynamic> json){
    final type = json['status'];
    switch(type){
      case 'high':
        return urgentTask.fromjson(json);
      case 'medium':
        return normalTask.fromjson(json);
      case 'low':
        return faibleTask.fromjson(json);
    default:
      throw taskExeption('Unknown task type: $type');
    }
  }
}