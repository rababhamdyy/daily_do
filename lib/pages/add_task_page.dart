import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Cubits/task_cubit.dart';
import '../models/task_model.dart';
import 'package:intl/intl.dart';

class AddtaskPage extends StatelessWidget {
  final TaskModel? task;
  const AddtaskPage({super.key, this.task});

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController = TextEditingController(
      text: task?.title,
    );
    final TextEditingController descController = TextEditingController(
      text: task?.description,
    );
    final TextEditingController dateController = TextEditingController(
      text: task?.dueDate,
    );
    final TextEditingController timeController = TextEditingController(
      text: task?.dueTime,
    );
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    Future<void> pickDate() async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate ?? DateTime.now(),
        firstDate:DateTime.now(),
        lastDate: DateTime(2035),
      );
      if (picked != null) {
        selectedDate = picked;
        dateController.text = DateFormat('dd-MM-yyyy').format(picked);
      }
    }

    Future<void> pickTime() async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: selectedTime ?? TimeOfDay.now(),
      );
      if (picked != null) {
        selectedTime = picked;
        final now = DateTime.now();
        final dt = DateTime(
          now.year,
          now.month,
          now.day,
          picked.hour,
          picked.minute,
        );
        timeController.text = DateFormat('hh:mm a').format(dt);
      }
    }

    void handleSubmit() {
      if (titleController.text.trim().isEmpty ||
          descController.text.trim().isEmpty ||
          dateController.text.trim().isEmpty ||
          timeController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all fields!')),
        );
        return;
      }
      final newTask = TaskModel(
        title: titleController.text,
        description: descController.text,
        dueDate: dateController.text,
        dueTime: timeController.text,
        isCompleted: task?.isCompleted ?? false,
      );
      if (task != null) {
        final args = ModalRoute.of(context)?.settings.arguments;
        if (args is TaskModel) {
          final cubit = context.read<TaskCubit>();
          final index = cubit.state.tasks.indexWhere((t) => t == args);
          if (index != -1) {
            cubit.updateTask(index, newTask);
          }
        }
        Navigator.pop(context, newTask);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task updated successfully!')),
        );
      } else {
        context.read<TaskCubit>().addTask(newTask);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task added successfully!')),
        );
      }
    }

    final isEditing = task != null;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditing ? 'Edit task' : 'Create a new task',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Task Title',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter task title',
                ),
              ),
              const Text(
                'Description',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              TextField(
                controller: descController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter task description',
                ),
                maxLines: 2,
              ),
              const Text(
                'Date',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'dd-MM-yyyy',
                ),
                readOnly: true,
                onTap: pickDate,
              ),
              const Text(
                'Time',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              TextField(
                controller: timeController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'hh:mm a',
                ),
                readOnly: true,
                onTap: pickTime,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: handleSubmit,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                      Colors.deepPurple,
                    ),
                    foregroundColor: WidgetStateProperty.all<Color>(
                      Colors.white,
                    ),
                    fixedSize: WidgetStateProperty.all<Size>(
                      const Size(200, 50),
                    ),
                    padding: WidgetStateProperty.all<EdgeInsets>(
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    ),
                    textStyle: WidgetStateProperty.all<TextStyle>(
                      const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  child: Text(isEditing ? 'Update Task' : 'Add Task'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
