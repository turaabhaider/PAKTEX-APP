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

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    try {
      final results = await Future.wait([
        api.getTasks(),
        api.getTodayAttendance(),
      ]);

      if (!mounted) return;

      setState(() {
        tasks = results[0];
        attendance = results[1];
        loading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });
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
                    value: '${attendance.length}',
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
          crossAxisAlignment: CrossAxisAlignment.start,
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