

class taskExeption implements Exception {
  final String message;
  taskExeption(this.message);

  @override
  String toString() {
    return "taskExeption: $message";
  }
}

class taskNotFoundException extends taskExeption {
  taskNotFoundException(String id) : super("Task with id $id not found");
}

class invalidPriorityException extends taskExeption {
  invalidPriorityException(String value) : super("Invalid priority value: $value , use low, medium or high");
}

class invalidDataException extends taskExeption {
  invalidDataException(String reason) : super("Invalid data: $reason");
}