import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../services/api_service.dart';

class TaskDetailsScreen extends StatefulWidget {
  final int taskId;

  const TaskDetailsScreen({
    super.key,
    required this.taskId,
  });

  @override
  State<TaskDetailsScreen> createState() =>
      _TaskDetailsScreenState();
}

class _TaskDetailsScreenState
    extends State<TaskDetailsScreen> {
  final api = ApiService();

  Map<String, dynamic>? task;
  bool loading = true;
  bool updating = false;

  @override
  void initState() {
    super.initState();
    loadTask();
  }

  Future<void> loadTask() async {
    try {
      final data = await api.getTask(widget.taskId);

      if (!mounted) return;

      setState(() {
        task = data;
        loading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });
    }
  }

  Future<void> updateProgress(int progress) async {
    setState(() {
      updating = true;
    });

    try {
      String status;

      if (progress == 100) {
        status = 'completed';
      } else if (progress > 0) {
        status = 'in_progress';
      } else {
        status = 'pending';
      }

      await api.updateTask(
        id: widget.taskId,
        progress: progress,
        status: status,
      );

      await loadTask();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task updated successfully'),
        ),
      );
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
          updating = false;
        });
      }
    }
  }

  String statusText(String status) {
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
    if (loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (task == null) {
      return const Scaffold(
        body: Center(
          child: Text('Task not found'),
        ),
      );
    }

    final progress = task!['progress'] ?? 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Task Details'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            task!['title'] ?? '',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            task!['description'] ?? 'No description',
            style: TextStyle(
              color: AppColors.text.withOpacity(0.7),
            ),
          ),

          const SizedBox(height: 24),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    statusText(task!['status'] ?? 'pending'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  LinearProgressIndicator(
                    value: progress / 100,
                    minHeight: 10,
                    borderRadius:
                    BorderRadius.circular(10),
                  ),

                  const SizedBox(height: 12),

                  Text('$progress% complete'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          if (!updating)
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                OutlinedButton(
                  onPressed: () => updateProgress(0),
                  child: const Text('Pending'),
                ),
                OutlinedButton(
                  onPressed: () => updateProgress(50),
                  child: const Text('50%'),
                ),
                OutlinedButton(
                  onPressed: () => updateProgress(75),
                  child: const Text('75%'),
                ),
                ElevatedButton(
                  onPressed: () => updateProgress(100),
                  child: const Text('Complete'),
                ),
              ],
            )
          else
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}