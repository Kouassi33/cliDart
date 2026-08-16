import 'dart:io';


import 'package:dart_cli/src/model/task.dart';
import 'package:dart_cli/src/model/task_exception.dart';
import 'package:dart_cli/src/repository/taskRepository.dart';

import '../model/normalTask.dart';
import '../model/urgent_Task.dart';

class TaskCLI {
  final TaskRepository<Task> repository;

  TaskCLI(this.repository);

  void start(){
    repository.load();
    print('========== Gestionnaire de tâches ==========\n');
    _showMenu();
  }

  void _showMenu(){
    while(true){
      print('\nMenu:');
      print('1. Ajouter une tâches');
      print('2. Lister les tâches');
      print('3. Marquer une tâche comme terminée');
      print('4. Supprimer une tâche');
      print('5. Quitter');
      stdout.write('Choisissez une option: ');
      final choice = stdin.readLineSync()?.trim() ?? "";
      switch(choice){
        case '1':
          _addTask();
          break;
        case '2':
          _listTasks();
          break;
        case '3':
          _markTaskAsCompleted();
          break;
        case '4':
          _deleteTask();
          break;
        case '5':
          print('Au revoir!');
          return;
        default:
          print('Option invalide. Veuillez réessayer.');
      }
    }
  }

  void _addTask(){
    try{
      stdout.write('Titre: ');
      final title = stdin.readLineSync()?.trim();
      if(title == null || title.isEmpty){
        throw InvalidDataException('Le titre ne peut pas être vide.');
      }

      stdout.write('Type de tâche (low, medium, high): ');
      final typeInput = stdin.readLineSync()?.trim().toLowerCase() ?? "medium";
      TaskStatus status;
      try{
        status = TaskStatus.values.firstWhere((e)=>e.name == typeInput);
      }catch(_){
        throw InvalidPriorityException(typeInput);
      }

      stdout.write('Date limite (YYYY-MM-DD) ou laissez vide: ');
      final deadLineInput = stdin.readLineSync()?.trim();
      DateTime? deadLine;
      if(deadLineInput != null && deadLineInput.isNotEmpty){
        try{
          deadLine = DateTime.parse(deadLineInput);
          if(deadLine.isBefore(DateTime.now())){
            throw InvalidDataException('La date limite ne peut pas être dans le passé.');
          }
        }catch(_){
          throw InvalidDataException('Format de date invalide. Veuillez utiliser YYYY-MM-DD.');
        }
      }  

      final id = DateTime.now().millisecondsSinceEpoch;

      Task newTask;
      if(status == TaskStatus.high && deadLine != null){
      newTask = UrgentTask(
        id: id,
        title: title,
        status: status,
        deadLine: deadLine
      );
    }else if(status == TaskStatus.medium && deadLine != null){
      newTask = NormalTask(
        id: id,
        title: title,
        status: status,
        deadLine: deadLine
      );
    }else{
      newTask = Task.fromJson(
        {'id': id,
        'title': title,
        'status': status.name,
        'deadLine': deadLine?.toIso8601String(),
        'isCompleted': false,
        'type': typeInput}
      );
    }
    
    repository.add(newTask);
    print('Tâche ajoutée avec succès.');
    } on TaskExeption catch(e){
    print('Erreur: ${e.message}');
    }catch(e){
      print('Erreur inattendue: $e');
    }
  }

  void _listTasks(){
    final Tasks = repository.getAll(sort:true);
    if(Tasks.isEmpty){
      print('Aucune tâche disponible.');
      return;
    }
    print('\n------------ Liste des tâches ------------');
    for(var Task in Tasks){
      final state = Task.isCompleted ? '[✔]' : (Task.isOverdue() ? 'retard' : '[ ]');
      final priorityLabel = Task.status.name.toUpperCase();
      final deadLineLabel = Task.deadLine != null ? '(échéance: ${Task.deadLine!.toLocal()})' : '';
      print('$state ${Task.id} : ${Task.title} - $priorityLabel $deadLineLabel');
    }
  }

  void _markTaskAsCompleted(){
    stdout.write('Entrez l\'ID de la tâche à marquer comme terminée: ');
    final input =stdin.readLineSync()?.trim() ?? "";
    final id = int.parse(input);
    if(id == null){
      print('id invalide');
      return;
    }
    try{
      repository.complete(id);
      print('Tâche marquée comme terminée.');
    }on TaskNotFoundException catch(e){
      print('$e');
    }
  }

  void _deleteTask(){
    stdout.write('Entrez l\'ID de la tâche à supprimer: ');
    final inpu = stdin.readLineSync()?.trim() ?? '';
    final id = int.parse(inpu);
    if(id == null){
      print('id invalide');
      return;
    }
    try{
      repository.delete(id);
      print('Tâche supprimée avec succès.');
    }on TaskNotFoundException catch(e){
      print('$e');
    }
  }
}