import 'package:dart_cli/src/repository/taskRepository.dart';

import 'src/interfaceCLI/task_cli.dart';
import 'src/model/task.dart';

void main() {
  const filePath = 'tasks.json';
  final repository = TaskRepository<Task>(filePath, Task.fromJson);
  final cli = TaskCLI(repository);
  cli.start();
}
