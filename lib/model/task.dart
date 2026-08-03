import 'package:dart_cli/model/task_exception.dart';

import 'faibleTask.dart';
import 'normalTask.dart';
import 'urgent_Task.dart';
//import 'dart:convert';

enum TaskStatus {low,medium,high }

abstract class Serializable {
  Map<String, dynamic> tojson();
}

abstract class Task implements Serializable, Comparable<Task> {
  final int id;
  String title;
  TaskStatus status;
  DateTime? deadLine;
  bool isCompleted;

  Task(
    {
      required this.title, required this.id, 
      this.status = TaskStatus.medium, this.isCompleted = false,
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
  int compareTo(Task other){

    int priorityOrder(TaskStatus p){

      if(p == TaskStatus.low){

        return 0;

      }else if(p == TaskStatus.medium){

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

  static Task fromJson(Map<String, dynamic> json){
    final type = json['status'];
    switch(type){
      case 'high':
        return UrgentTask.fromjson(json);
      case 'medium':
        return NormalTask.fromjson(json);
      case 'low':
        return FaibleTask.fromjson(json);
    default:
      throw TaskExeption('Unknown Task type: $type');
    }
  }
}