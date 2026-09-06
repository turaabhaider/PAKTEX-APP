import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../services/api_service.dart';
import 'create_task_screen.dart';
import 'task_details_screen.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final api = ApiService();

  List<dynamic> tasks = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    try {
      final data = await api.getTasks();

      if (!mounted) return;

      setState(() {
        tasks = data;
        loading = false;
      });
    } catch (error) {
      debugPrint('TASKS LOAD ERROR: $error');

      if (!mounted) return;

      setState(() {
        loading = false;
      });
    }
  }

  String statusLabel(String status) {
    switch (status) {
      case 'in_progress':
        return 'In Progress';

      case 'completed':
        return 'Completed';

      default:
        return 'Pending';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text(
          'Tasks',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),

      // ADMIN ONLY
      floatingActionButton: ApiService.isAdmin
          ? FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateTaskScreen(),
            ),
          );

          await loadTasks();
        },
        child: const Icon(Icons.add),
      )
          : null,

      body: loading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : RefreshIndicator(
        onRefresh: loadTasks,
        child: tasks.isEmpty
            ? const Center(
          child: Text(
            'No tasks found',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];

            final title =
                task['title']?.toString() ?? '';

            final description =
                task['description']?.toString() ??
                    'No description';

            final status =
                task['status']?.toString() ??
                    'pending';

            final progress =
                task['progress'] ?? 0;

            return Card(
              margin: const EdgeInsets.only(
                bottom: 12,
              ),

              child: ListTile(
                contentPadding:
                const EdgeInsets.all(16),

                title: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                subtitle: Padding(
                  padding:
                  const EdgeInsets.only(
                    top: 8,
                  ),

                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [
                      Text(
                        description,
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      Text(
                        '${statusLabel(status)} • $progress%',
                        style: TextStyle(
                          color:
                          AppColors.text
                              .withOpacity(
                            0.65,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                trailing: const Icon(
                  Icons.chevron_right,
                ),

                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          TaskDetailsScreen(
                            taskId: task['id'],
                          ),
                    ),
                  );

                  await loadTasks();
                },
              ),
            );
          },
        ),
      ),
    );
  }
}