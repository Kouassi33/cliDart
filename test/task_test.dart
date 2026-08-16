import 'dart:io';

import 'package:dart_cli/src/model/faibleTask.dart';
import 'package:dart_cli/src/model/normalTask.dart';
import 'package:dart_cli/src/model/task.dart';
import 'package:dart_cli/src/model/task_exception.dart';
import 'package:dart_cli/src/model/urgent_Task.dart';
import 'package:dart_cli/src/repository/taskRepository.dart';
import 'package:test/test.dart';


void main(){
  //Test 1: Exception si tache introuvable
  test("suprimer une tache inexistante lève une exception", () {
    const path = 'test_task_empty.json';
    final file = File(path);

    if(file.existsSync()) file.deleteSync();

    final repo = TaskRepository<Task>(path,Task.fromJson);
    repo.load();

    expect(() => repo.delete(1), throwsA(isA<TaskNotFoundException>()));

    if(file.existsSync()) file.deleteSync();
  });

  //Test 2: creation d'une tache normale
  test("création d\'une tache normale",(){
    final tasks =NormalTask(
      id: 1, 
      title: "tester le code",
      status: TaskStatus.medium, 
      deadLine: null
    );
    expect(tasks.title, "tester le code");
    expect(tasks.isCompleted,false);
    expect(tasks.isOverdue(), false);
  });

  //Test 3: tache urgente
  test("creation d\'une tache urgente", (){
    final futur = DateTime.now().add(Duration(days: 2));
    final tasks =UrgentTask(
      id: 1, 
      title: "tester le code urgement", 
      deadLine: futur
    );
    expect(tasks.isOverdue(), false);
    expect(tasks.status, TaskStatus.high);
    expect(tasks.isCompleted, false);
  });

  //Test 4: trie des tache par priorité
  test("trie des tache", (){
    final t1 = FaibleTask(id: 1, title: "tache mineur", status: TaskStatus.low, deadLine: null);
    final t2 = NormalTask(id: 2, title: "tache normal", status: TaskStatus.medium, deadLine: null);
    final t3 = NormalTask(id: 3, title: "tache urgente", status: TaskStatus.high, deadLine: null);
    final task =[t1,t2,t3]..sort();
    expect(task[0], t1);
    expect(task[1], t2);
    expect(task[2], t3);
  });

  //Test 5: verification deadline
  test("une tache avec une deadline passé est en retard", (){
    final past = DateTime.now().subtract(Duration(days: 1));
    final tasks = UrgentTask(
      id: 1, 
      title: "tache urgente", 
      deadLine: past
    );
    expect(tasks.isOverdue(), true);
  });
}