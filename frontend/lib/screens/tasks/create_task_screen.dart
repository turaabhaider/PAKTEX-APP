import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../services/api_service.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() =>
      _CreateTaskScreenState();
}

class _CreateTaskScreenState
    extends State<CreateTaskScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final api = ApiService();

  List<dynamic> users = [];
  int? selectedUser;
  bool loading = true;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    try {
      final data = await api.getUsers();

      if (!mounted) return;

      setState(() {
        users = data;
        loading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });
    }
  }

  Future<void> createTask() async {
    if (titleController.text.trim().isEmpty ||
        selectedUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Title and assigned employee are required',
          ),
        ),
      );
      return;
    }

    setState(() {
      saving = true;
    });

    try {
      await api.createTask(
        title: titleController.text.trim(),
        description:
        descriptionController.text.trim(),
        assignedTo: selectedUser!,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task created successfully'),
        ),
      );

      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          saving = false;
        });
      }
    }
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
      appBar: AppBar(
        title: const Text('Create Task'),
      ),
      body: loading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView(
        padding: const EdgeInsets.all(24),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Task title',
              prefixIcon: Icon(Icons.task),
            ),
          ),

          const SizedBox(height: 18),

          TextField(
            controller: descriptionController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Description',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.description),
            ),
          ),

          const SizedBox(height: 18),

          DropdownButtonFormField<int>(
            value: selectedUser,
            decoration: const InputDecoration(
              labelText: 'Assign to',
              prefixIcon: Icon(Icons.person),
            ),
            items: users.map<DropdownMenuItem<int>>(
                  (user) {
                return DropdownMenuItem<int>(
                  value: user['id'],
                  child: Text(
                    '${user['name']} — ${user['position'] ?? 'Employee'}',
                  ),
                );
              },
            ).toList(),
            onChanged: (value) {
              setState(() {
                selectedUser = value;
              });
            },
          ),

          const SizedBox(height: 28),

          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: saving ? null : createTask,
              child: saving
                  ? const SizedBox(
                height: 22,
                width: 22,
                child:
                CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
                  : const Text(
                'Create Task',
                style: TextStyle(
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