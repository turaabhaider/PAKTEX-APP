import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  String selectedPriority = 'Medium';

  void createTask() {
    final title = titleController.text;
    final description = descriptionController.text;

    print('Title: $title');
    print('Description: $description');
    print('Priority: $selectedPriority');

    Navigator.pop(context);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Create Task',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'New Task',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Create and assign a task to your team.',
            style: TextStyle(
              fontSize: 15,
              color: AppColors.text.withOpacity(0.6),
            ),
          ),

          const SizedBox(height: 28),

          const Text(
            'Task Title',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 8),

          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              hintText: 'Enter task title',
              prefixIcon: Icon(Icons.task_outlined),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Description',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 8),

          TextField(
            controller: descriptionController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Describe the task',
              prefixIcon: Icon(Icons.description_outlined),
              alignLabelWithHint: true,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Priority',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 8),

          DropdownButtonFormField<String>(
            initialValue: selectedPriority,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.flag_outlined),
            ),
            items: const [
              DropdownMenuItem(
                value: 'High',
                child: Text('High'),
              ),
              DropdownMenuItem(
                value: 'Medium',
                child: Text('Medium'),
              ),
              DropdownMenuItem(
                value: 'Low',
                child: Text('Low'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedPriority = value;
                });
              }
            },
          ),

          const SizedBox(height: 28),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: createTask,
              icon: const Icon(Icons.add_task),
              label: const Text(
                'Create Task',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}