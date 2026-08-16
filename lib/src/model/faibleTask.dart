import 'package:dart_cli/src/model/task.dart';

class FaibleTask extends Task {
  FaibleTask({
    required super.id,
    required super.title,
    super.status = TaskStatus.low,
    required super.deadLine,
    super.isCompleted = false,
  });

  Map<String, dynamic> tojson() => {...super.tojson(), 'status': 'low'};

  factory FaibleTask.fromjson(Map<String, dynamic> json) {
    return FaibleTask(
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
