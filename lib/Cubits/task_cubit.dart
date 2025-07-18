import 'package:daily_do/data/database_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/task_model.dart';
import 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  TaskCubit() : super(const TaskState()) {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    emit(state.copyWith(status: TaskStatus.loading));
    try {
      final tasks = await _databaseHelper.getAllTasks();
      emit(state.copyWith(tasks: tasks, status: TaskStatus.success));
    } catch (e) {
      emit(
        state.copyWith(status: TaskStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> addTask(TaskModel task) async {
    emit(state.copyWith(status: TaskStatus.loading));
    try {
      final id = await _databaseHelper.insertTask(task);
      final newTask = task.copyWith(id: id);
      emit(
        state.copyWith(
          tasks: List.from(state.tasks)..add(newTask),
          status: TaskStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: TaskStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> updateTask(int index, TaskModel updatedTask) async {
    emit(state.copyWith(status: TaskStatus.loading));
    try {
      final taskId = updatedTask.id;
      if (taskId != null) {
        await _databaseHelper.updateTask(updatedTask);
        final updatedTasks = List<TaskModel>.from(state.tasks);
        final existingIndex = updatedTasks.indexWhere((t) => t.id == taskId);
        if (existingIndex != -1) {
          updatedTasks[existingIndex] = updatedTask;
        }
        emit(state.copyWith(tasks: updatedTasks, status: TaskStatus.success));
      }
    } catch (e) {
      emit(
        state.copyWith(status: TaskStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> deleteTask(int index) async {
    emit(state.copyWith(status: TaskStatus.loading));
    try {
      final taskToDelete = state.tasks[index];
      if (taskToDelete.id != null) {
        await _databaseHelper.deleteTask(taskToDelete.id!);
        final updatedTasks = List<TaskModel>.from(state.tasks)
          ..removeWhere((t) => t.id == taskToDelete.id);
        emit(state.copyWith(tasks: updatedTasks, status: TaskStatus.success));
      }
    } catch (e) {
      emit(
        state.copyWith(status: TaskStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> toggleComplete(int index, bool isCompleted) async {
    emit(state.copyWith(status: TaskStatus.loading));
    try {
      final taskToUpdate = state.tasks[index].copyWith(
        isCompleted: isCompleted,
      );
      await _databaseHelper.updateTask(taskToUpdate);
      final updatedTasks = List<TaskModel>.from(state.tasks);
      updatedTasks[index] = taskToUpdate;
      emit(state.copyWith(tasks: updatedTasks, status: TaskStatus.success));
    } catch (e) {
      emit(
        state.copyWith(status: TaskStatus.error, errorMessage: e.toString()),
      );
    }
  }
}
