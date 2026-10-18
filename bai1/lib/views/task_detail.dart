import 'package:flutter/material.dart';

import '../controllers/task_controller.dart';
import '../models/task.dart';

class TaskDetail extends StatefulWidget {
  final Task task;

  const TaskDetail({super.key, required this.task});

  @override
  State<TaskDetail> createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  final TaskController _taskController = TaskController();
  late bool _isCompleted;

  @override
  void initState() {
    super.initState();
    _isCompleted = widget.task.isCompleted;
  }

  Future<void> _onCompletedChanged(bool? value) async {
    if (value == null) return;

    setState(() => _isCompleted = value);

    widget.task.isCompleted = value;
    await _taskController.updateTask(widget.task);

    if (!mounted) return;

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.titleSmall!
        .copyWith(fontWeight: FontWeight.bold);
    final valueStyle = Theme.of(context).textTheme.bodyMedium;

    return Scaffold(
      appBar: AppBar(title: const Text('Task Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title', style: labelStyle),
            const SizedBox(height: 4),
            Text(widget.task.title, style: valueStyle),
            const SizedBox(height: 16),
            Text('Description', style: labelStyle),
            const SizedBox(height: 4),
            Text(widget.task.description, style: valueStyle),
            const SizedBox(height: 16),
            Row(
              children: [
                Text('Completed', style: labelStyle),
                Checkbox(value: _isCompleted, onChanged: _onCompletedChanged),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
