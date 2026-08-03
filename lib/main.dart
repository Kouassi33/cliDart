import 'package:dart_cli/repository/taskRepository.dart';

import 'interfaceCLI/task_cli.dart';
import 'model/task.dart';

void main() {
  const filePath = 'tasks.json';
  final repository = TaskRepository<Task>(filePath);
  final cli = TaskCLI(repository);
  cli.start();
}