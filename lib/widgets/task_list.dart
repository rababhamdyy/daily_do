import 'package:daily_do/models/task_model.dart';
import 'package:flutter/material.dart';

class TaskList extends StatelessWidget {
  const TaskList({
    super.key,
    required this.tasks,
    this.onCompletedChanged,
    required this.textDecoration,
    this.onEdit,
    this.onDelete,
  });
  final TaskModel tasks;
  final ValueChanged<bool?>? onCompletedChanged;
  final TextDecoration textDecoration;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      decoration: BoxDecoration(
        color: Colors.deepPurple[400],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Checkbox(
          value: tasks.isCompleted,
          onChanged: onCompletedChanged,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(color: Colors.white, width: 1.5),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.date_range, color: Colors.grey[300], size: 16),
                const SizedBox(width: 2),
                Text(
                  tasks.dueDate,
                  style: TextStyle(color: Colors.grey[300], fontSize: 12),
                ),
                const SizedBox(width: 8),
                Icon(Icons.access_time, color: Colors.grey[300], size: 16),
                const SizedBox(width: 2),
                Text(
                  tasks.dueTime,
                  style: TextStyle(color: Colors.grey[300], fontSize: 12),
                ),
              ],
            ),
            Text(
              tasks.title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                decoration: textDecoration,
              ),
            ),
          ],
        ),
        subtitle: Text(
          tasks.description,
          style: TextStyle(color: Colors.white, decoration: textDecoration),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: onEdit,
              child: Icon(
                Icons.mode_edit_outlined,
                color: Colors.grey[300],
                size: 20,
              ),
            ),
            SizedBox(height: 8),
            GestureDetector(
              onTap: onDelete,
              child: Icon(
                Icons.delete_outline,
                color: Colors.black87,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
