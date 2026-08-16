import 'dart:convert';
import 'dart:io';

import 'package:dart_cli/src/model/task.dart';
import 'package:dart_cli/src/model/task_exception.dart';



class TaskRepository <T extends Task>{
  final String _filePath;
  final T Function(Map<String, dynamic>) _fromJson;
  List<T> _items = [];

  TaskRepository(this._filePath, this._fromJson);

  void load(){
    try{
      final file = File(_filePath);
      if(!file.existsSync()){
        _items = [];
        return;
      }
      final content = file.readAsStringSync();
      final List<dynamic> jsonList = jsonDecode(content);
      _items = jsonList
              .map((json)=>_fromJson(json as Map<String, dynamic>))
              .toList();
    } catch(e){
      throw Exception("Failed to load Tasks from file: $e");
    }
  }


  void save(){
    try{
      final file = File(_filePath);
      final jsonList = _items.map((Task)=> Task.tojson()).toList();
      file.writeAsStringSync(jsonEncode(jsonList));
    }catch(e){
      throw Exception("Failed to save Tasks to file: $e");  
    }
  }

  void add(T Task){
    if(_items.any((t)=>t.id == Task.id)){
      throw TaskExeption("Task with id ${Task.id} already exists");
    }
    _items.add(Task);
    save();
  }

  List<T> getAll({bool sort = true}){
    final list = List<T>.from(_items);
    if(sort){
      list.sort();
    }
    return list;
  }

  T _findById(int id){
    try{
      return _items.firstWhere((t)=>t.id == id);
    }catch(e){
      throw TaskNotFoundException(id.toString());
    }
  }

  void complete(int id){
    final Task = _findById(id);
    Task.isCompleted = true;
    save();
  }

  void delete(int id){
    final Task = _findById(id);
    _items.remove(Task);
    save();
  }
}