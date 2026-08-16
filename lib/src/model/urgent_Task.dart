import 'package:dart_cli/src/model/task.dart';

class UrgentTask extends Task {
  UrgentTask({
    required super.id,
    required super.title,
    super.status = TaskStatus.high,
    required super.deadLine,
    super.isCompleted = false,
  }) : assert(deadLine != null, "Urgent Task must have a deadline");

  Map<String, dynamic> tojson() => {...super.tojson(), 'status': 'high'};

  factory UrgentTask.fromjson(Map<String, dynamic> json) {
    return UrgentTask(
      id: json['id'],
      title: json['title'],
      status: TaskStatus.values.firstWhere((e) => e.name == json['status']),
      deadLine: json['deadLine'] != null
          ? DateTime.parse(json['deadLine'])
          : null,
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}
