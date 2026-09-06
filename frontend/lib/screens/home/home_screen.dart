import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final api = ApiService();

  bool loading = true;

  List<dynamic> tasks = [];
  List<dynamic> attendance = [];
  List<dynamic> users = [];

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  String get todayString {
    final now = DateTime.now();

    return '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
  }

  bool isToday(dynamic item) {
    final date = item['date'];

    if (date == null) return false;

    return date.toString().startsWith(todayString);
  }

  Future<void> loadDashboard() async {
    try {
      final taskResult = await api.getTasks();

      List<dynamic> attendanceResult = [];

      try {
        if (ApiService.isAdmin) {
          attendanceResult = await api.getTodayAttendance();
        } else {
          attendanceResult = await api.getMyAttendance();
        }
      } catch (error) {
        debugPrint('ATTENDANCE LOAD ERROR: $error');
      }

      List<dynamic> userResult = [];

      if (ApiService.isAdmin) {
        try {
          userResult = await api.getUsers();
        } catch (error) {
          debugPrint('USERS LOAD ERROR: $error');
        }
      }

      if (!mounted) return;

      setState(() {
        tasks = taskResult;
        attendance = attendanceResult;
        users = userResult;
        loading = false;
      });
    } catch (error) {
      debugPrint('DASHBOARD LOAD ERROR: $error');

      if (!mounted) return;

      setState(() {
        loading = false;
      });
    }
  }

  Future<void> giveTask(dynamic employee) async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    final employeeId = int.tryParse(
      employee['id'].toString(),
    );

    if (employeeId == null) return;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Give Task to ${employee['name'] ?? 'Employee'}',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Task title',
                  hintText: 'Enter task title',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter task description',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final title = titleController.text.trim();
                final description =
                descriptionController.text.trim();

                if (title.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a task title'),
                    ),
                  );
                  return;
                }

                try {
                  await api.createTask(
                    title: title,
                    description: description,
                    assignedTo: employeeId,
                  );

                  if (!context.mounted) return;

                  Navigator.pop(context, true);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Task created successfully'),
                    ),
                  );
                } catch (error) {
                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to create task: $error'),
                    ),
                  );
                }
              },
              child: const Text('Create Task'),
            ),
          ],
        );
      },
    );

    titleController.dispose();
    descriptionController.dispose();

    if (result == true) {
      await loadDashboard();
    }
  }

  @override
  Widget build(BuildContext context) {
    final completed = tasks.where(
          (task) => task['status'] == 'completed',
    ).length;

    final pending = tasks.where(
          (task) => task['status'] == 'pending',
    ).length;

    final progress = tasks.isEmpty
        ? 0
        : ((completed / tasks.length) * 100).round();

    final name =
        ApiService.currentUser?['name'] ?? 'User';

    // Employee: only count today's own attendance.
    // Admin: attendance endpoint already returns today's attendance.
    final todayAttendance = ApiService.isAdmin
        ? attendance
        : attendance.where(isToday).toList();

    // Never show the admin in the employee list.
    final employees = users.where((user) {
      final email =
      '${user['email'] ?? ''}'.trim().toLowerCase();

      return email != 'zeekhi.work@gmail.com';
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          AppStrings.appName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: loading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : RefreshIndicator(
        onRefresh: loadDashboard,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              'Good morning, $name 👋',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Here is your team overview for today.',
              style: TextStyle(
                fontSize: 15,
                color: AppColors.text.withOpacity(0.6),
              ),
            ),

            const SizedBox(height: 28),

            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Present',
                    value: '${todayAttendance.length}',
                    icon: Icons.people,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    title: 'Tasks',
                    value: '${tasks.length}',
                    icon: Icons.task_alt,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Completed',
                    value: '$completed',
                    icon: Icons.check_circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    title: 'Pending',
                    value: '$pending',
                    icon: Icons.pending_actions,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            const Text(
              "Today's Progress",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Team Tasks',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '$progress%',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    LinearProgressIndicator(
                      value: progress / 100,
                      minHeight: 8,
                      borderRadius:
                      BorderRadius.circular(10),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      '$completed of ${tasks.length} tasks completed',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.text
                            .withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ADMIN ONLY
            if (ApiService.isAdmin) ...[
              const SizedBox(height: 32),

              const Text(
                'Employees',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              ...employees.map(
                    (employee) {
                  final employeeId =
                  int.tryParse(
                    employee['id'].toString(),
                  );

                  final isPresent =
                      employeeId != null &&
                          attendance.any(
                                (item) =>
                            item['user_id'] ==
                                employeeId &&
                                isToday(item),
                          );

                  return Card(
                    margin:
                    const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding:
                      const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            child: Text(
                              '${employee['name'] ?? 'E'}'
                                  .substring(0, 1)
                                  .toUpperCase(),
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  employee['name'] ??
                                      'Employee',
                                  style: const TextStyle(
                                    fontWeight:
                                    FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  employee['position'] ??
                                      employee['email'] ??
                                      '',
                                  style: TextStyle(
                                    color: AppColors.text
                                        .withOpacity(0.6),
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  isPresent
                                      ? 'Present'
                                      : 'Not Present',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight:
                                    FontWeight.w600,
                                    color: isPresent
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          ElevatedButton(
                            onPressed: () =>
                                giveTask(employee),
                            child:
                            const Text('Give Task'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28),
            const SizedBox(height: 14),
            Text(
              value,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: AppColors.text.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}