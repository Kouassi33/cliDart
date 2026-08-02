import 'interfaceCLI/task_cli.dart';
import 'model/task.dart';
import 'repository/taskRepository.dart';

void main() {
  const filePath = 'tasks.json';
  final repository = taskRepository<task>(filePath);
  final cli = taskCLI(repository);
  cli.start();
}