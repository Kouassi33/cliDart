import 'dart:io';

import '../model/normalTask.dart';
import '../model/task.dart';
import '../model/task_exception.dart';
import '../model/urgent_Task.dart';
import '../repository/taskRepository.dart';

class taskCLI {
  final taskRepository<task> repository;

  taskCLI(this.repository);

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
        throw invalidDataException('Le titre ne peut pas être vide.');
      }

      stdout.write('Type de tâche (low, medium, high): ');
      final typeInput = stdin.readLineSync()?.trim().toLowerCase() ?? "medium";
      taskStatus status;
      try{
        status = taskStatus.values.firstWhere((e)=>e.name == typeInput);
      }catch(_){
        throw invalidPriorityException(typeInput);
      }

      stdout.write('Date limite (YYYY-MM-DD) ou laissez vide: ');
      final deadLineInput = stdin.readLineSync()?.trim();
      DateTime? deadLine;
      if(deadLineInput != null && deadLineInput.isNotEmpty){
        try{
          deadLine = DateTime.parse(deadLineInput);
          if(deadLine.isBefore(DateTime.now())){
            throw invalidDataException('La date limite ne peut pas être dans le passé.');
          }
        }catch(_){
          throw invalidDataException('Format de date invalide. Veuillez utiliser YYYY-MM-DD.');
        }
      }  

      final id = DateTime.now().millisecondsSinceEpoch;

      task newTask;
      if(status == taskStatus.high && deadLine != null){
      newTask = urgentTask(
        id: id,
        title: title,
        status: status,
        deadLine: deadLine
      );
    }else if(status == taskStatus.medium && deadLine != null){
      newTask = normalTask(
        id: id,
        title: title,
        status: status,
        deadLine: deadLine
      );
    }else{
      newTask = task.fromJson(
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
    } on taskExeption catch(e){
    print('Erreur: ${e.message}');
    }catch(e){
      print('Erreur inattendue: $e');
    }
  }

  void _listTasks(){
    final tasks = repository.getAll(sort:true);
    if(tasks.isEmpty){
      print('Aucune tâche disponible.');
      return;
    }
    print('\n------------ Liste des tâches ------------');
    for(var task in tasks){
      final state = task.isCompleted ? '[✔]' : (task.isOverdue() ? 'retard' : '[ ]');
      final priorityLabel = task.status.name.toUpperCase();
      final deadLineLabel = task.deadLine != null ? '(échéance: ${task.deadLine!.toLocal()})' : '';
      print('$state ${task.id} : ${task.title} - $priorityLabel $deadLineLabel');
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
    }on taskNotFoundException catch(e){
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
    }on taskNotFoundException catch(e){
      print('$e');
    }
  }
}