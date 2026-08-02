import 'dart:convert';
import 'dart:io';

import '../model/task.dart';
import '../model/task_exception.dart';

class taskRepository <T extends task>{
  final String _filePath;
  List<T> _items = [];

  taskRepository(this._filePath);

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
              .map((json)=>task.fromJson(json as Map<String, dynamic>) as T)
              .toList();
    } catch(e){
      throw Exception("Failed to load tasks from file: $e");
    }
  }


  void save(){
    try{
      final file = File(_filePath);
      final jsonList = _items.map((task)=> task.tojson()).toList();
      file.writeAsStringSync(jsonEncode(jsonList));
    }catch(e){
      throw Exception("Failed to save tasks to file: $e");  
    }
  }

  void add(T task){
    if(_items.any((t)=>t.id == task.id)){
      throw taskExeption("Task with id ${task.id} already exists");
    }
    _items.add(task);
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
      throw taskNotFoundException(id.toString());
    }
  }

  void complete(int id){
    final task = _findById(id);
    task.isCompleted = true;
    save();
  }

  void delete(int id){
    final task = _findById(id);
    _items.remove(task);
    save();
  }
}