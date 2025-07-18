import 'package:daily_do/models/task_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Cubits/task_cubit.dart';
import '../Cubits/task_state.dart';
import '../widgets/task_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Today\'s Tasks',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: BlocBuilder<TaskCubit, TaskState>(
                  builder: (context, state) {
                    if (state.tasks.isEmpty) {
                      return const Center(child: Text('No tasks available'));
                    }
                    return ListView.builder(
                      itemCount: state.tasks.length,
                      itemBuilder: (context, index) {
                        return TaskList(
                          tasks: state.tasks[index],
                          onCompletedChanged: (value) {
                            context.read<TaskCubit>().toggleComplete(
                              index,
                              value!,
                            );
                          },
                          textDecoration:
                              state.tasks[index].isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                          onEdit: () async {
                            final updatedTask = await Navigator.pushNamed(
                              context,
                              '/edit_task',
                              arguments: state.tasks[index],
                            );
                            if (updatedTask != null) {
                              context.read<TaskCubit>().updateTask(
                                index,
                                updatedTask as TaskModel,
                              );
                            }
                          },
                          onDelete: () {
                            context.read<TaskCubit>().deleteTask(index);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
