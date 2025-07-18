import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/task_model.dart';
import 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(const TaskState());

  void addTask(TaskModel task) async {
    emit(state.copyWith(status: TaskStatus.loading));
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      emit(
        state.copyWith(
          tasks: List.from(state.tasks)..add(task),
          status: TaskStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: TaskStatus.error, errorMessage: e.toString()),
      );
    }
  }

  void updateTask(int index, TaskModel updatedTask) async {
    emit(state.copyWith(status: TaskStatus.loading));
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final updatedTasks = List<TaskModel>.from(state.tasks);
      updatedTasks[index] = updatedTask;
      emit(state.copyWith(tasks: updatedTasks, status: TaskStatus.success));
    } catch (e) {
      emit(
        state.copyWith(status: TaskStatus.error, errorMessage: e.toString()),
      );
    }
  }

  void deleteTask(int index) async {
    emit(state.copyWith(status: TaskStatus.loading));
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final updatedTasks = List<TaskModel>.from(state.tasks)..removeAt(index);
      emit(state.copyWith(tasks: updatedTasks, status: TaskStatus.success));
    } catch (e) {
      emit(
        state.copyWith(status: TaskStatus.error, errorMessage: e.toString()),
      );
    }
  }

  void toggleComplete(int index, bool isCompleted) async {
    emit(state.copyWith(status: TaskStatus.loading));
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final updatedTasks = List<TaskModel>.from(state.tasks);
      updatedTasks[index] = updatedTasks[index].copyWith(
        isCompleted: isCompleted,
      );
      emit(state.copyWith(tasks: updatedTasks, status: TaskStatus.success));
    } catch (e) {
      emit(
        state.copyWith(status: TaskStatus.error, errorMessage: e.toString()),
      );
    }
  }
}
