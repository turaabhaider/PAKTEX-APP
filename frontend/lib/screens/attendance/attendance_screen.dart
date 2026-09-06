import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../services/api_service.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() =>
      _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final api = ApiService();

  List<dynamic> attendance = [];
  bool loading = true;
  bool actionLoading = false;

  @override
  void initState() {
    super.initState();
    loadAttendance();
  }

  Future<void> loadAttendance() async {
    try {
      final data = await api.getTodayAttendance();

      if (!mounted) return;

      setState(() {
        attendance = data;
        loading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });
    }
  }

  Future<void> checkIn() async {
    setState(() => actionLoading = true);

    try {
      await api.checkIn();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Check-in successful'),
        ),
      );

      await loadAttendance();
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
        setState(() => actionLoading = false);
      }
    }
  }

  Future<void> checkOut() async {
    setState(() => actionLoading = true);

    try {
      await api.checkOut();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Check-out successful'),
        ),
      );

      await loadAttendance();
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
        setState(() => actionLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final present = attendance.length;

    final myId = ApiService.currentUser?['id'];

    final myAttendance = attendance.where(
          (item) => item['user_id'] == myId,
    ).toList();

    final hasCheckedIn = myAttendance.isNotEmpty;
    final hasCheckedOut =
        hasCheckedIn && myAttendance.first['check_out'] != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Attendance',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: loadAttendance,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                    title: 'Present',
                    value: '$present',
                    icon: Icons.check_circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SummaryCard(
                    title: 'Total',
                    value: '$present',
                    icon: Icons.people,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            if (!hasCheckedIn)
              SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed:
                  actionLoading ? null : checkIn,
                  icon: const Icon(
                    Icons.login,
                  ),
                  label: const Text(
                    'Check In',
                  ),
                ),
              ),

            if (hasCheckedIn && !hasCheckedOut)
              SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed:
                  actionLoading ? null : checkOut,
                  icon: const Icon(
                    Icons.logout,
                  ),
                  label: const Text(
                    'Check Out',
                  ),
                ),
              ),

            if (hasCheckedOut)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle),
                      SizedBox(width: 12),
                      Text(
                        'You completed attendance for today.',
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 30),

            const Text(
              "Today's Team",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            ...attendance.map(
                  (item) => Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(
                    item['name'] ?? 'Unknown',
                  ),
                  subtitle: Text(
                    item['position'] ?? 'Employee',
                  ),
                  trailing: const Icon(
                    Icons.check_circle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _SummaryCard({
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
          children: [
            Icon(icon, size: 28),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(title),
          ],
        ),
      ),
    );
  }
}