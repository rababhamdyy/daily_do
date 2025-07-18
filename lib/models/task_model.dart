class TaskModel {
  String title;
  String description;
  String dueDate;
  String dueTime;
  bool isCompleted;
  TaskModel({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.dueTime,
    this.isCompleted = false,
  });

  TaskModel copyWith({
    String? title,
    String? description,
    String? dueDate,
    String? dueTime,
    bool? isCompleted,
  }) {
    return TaskModel(
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      dueTime: dueTime ?? this.dueTime,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}