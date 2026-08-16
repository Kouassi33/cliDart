class TaskExeption implements Exception {
  final String message;
  TaskExeption(this.message);

  @override
  String toString() {
    return "TaskExeption: $message";
  }
}

class TaskNotFoundException extends TaskExeption {
  TaskNotFoundException(String id) : super("Task with id $id not found");
}

class InvalidPriorityException extends TaskExeption {
  InvalidPriorityException(String value)
    : super("Invalid priority value: $value , use low, medium or high");
}

class InvalidDataException extends TaskExeption {
  InvalidDataException(String reason) : super("Invalid data: $reason");
}
