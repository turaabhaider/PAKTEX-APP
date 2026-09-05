import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class TaskDetailsScreen extends StatefulWidget {
  final String title;
  final String description;
  final String status;
  final String priority;

  const TaskDetailsScreen({
    super.key,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
  });

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  late String currentStatus;

  @override
  void initState() {
    super.initState();
    currentStatus = widget.status;
  }

  void updateStatus() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Pending'),
                onTap: () {
                  setState(() {
                    currentStatus = 'Pending';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('In Progress'),
                onTap: () {
                  setState(() {
                    currentStatus = 'In Progress';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Completed'),
                onTap: () {
                  setState(() {
                    currentStatus = 'Completed';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
            widget.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            widget.description,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.text.withOpacity(0.6),
            ),
          ),

          const SizedBox(height: 28),

          Card(
            elevation: 0,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.flag_outlined),
                  title: const Text('Priority'),
                  subtitle: Text(widget.priority),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.task_alt),
                  title: const Text('Status'),
                  subtitle: Text(currentStatus),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: updateStatus,
              child: const Text('Update Status'),
            ),
          ),
        ],
      ),
    );
  }
}