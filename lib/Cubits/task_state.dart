import 'package:equatable/equatable.dart';
import '../models/task_model.dart';

enum TaskStatus { initial, loading, success, error }

class TaskState extends Equatable {
  final List<TaskModel> tasks;
  final TaskStatus status;
  final String? errorMessage;

  const TaskState({
    this.tasks = const [],
    this.status = TaskStatus.initial,
    this.errorMessage,
  });

  TaskState copyWith({
    List<TaskModel>? tasks,
    TaskStatus? status,
    String? errorMessage,
  }) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [tasks, status, errorMessage];
}
