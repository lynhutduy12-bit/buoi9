import 'package:flutter/material.dart';

import '../controllers/task_controller.dart';
import '../models/task.dart';
import 'task_detail.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<Task> _tasks = [];
  final TaskController _taskController = TaskController();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _fetchTasks() async {
    final tasks = await _taskController.fetchTasks();
    setState(() => _tasks = tasks);
  }

  Future<void> _addTask() async {
    final title = titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Vui lòng nhập Title')));
      return;
    }

    await _taskController.insertTask(
      Task(title: title, description: descriptionController.text.trim()),
    );
    titleController.clear();
    descriptionController.clear();
    await _fetchTasks();
  }

  Future<void> _deleteLastTask() async {
    if (_tasks.isEmpty) return;
    await _taskController.deleteTask(_tasks.last.id!);
    await _fetchTasks();
  }

  Future<void> _openDetail(Task task) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => TaskDetail(task: task)),
    );
    if (changed == true) {
      await _fetchTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleMedium!;

    return Scaffold(
      appBar: AppBar(title: const Text('Task List')),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: textStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: textStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _addTask,
                    child: const Text('Add Task'),
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _deleteLastTask,
                    child: const Text('Delete Task'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  final task = _tasks[index];
                  return Card(
                    color: task.isCompleted ? Colors.green[100] : Colors.white,
                    elevation: 2.0,
                    child: ListTile(
                      title: Text(task.title),
                      subtitle: Text(task.description),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _openDetail(task),
                      ),
                      onTap: () => _openDetail(task),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
