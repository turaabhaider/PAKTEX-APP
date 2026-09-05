import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Attendance',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: const [
          _AttendanceSummary(),

          SizedBox(height: 28),

          Text(
            'Today\'s Team',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 16),

          _EmployeeAttendance(
            name: 'Zeeshan Khan',
            role: 'General Manager',
            isPresent: true,
          ),

          SizedBox(height: 12),

          _EmployeeAttendance(
            name: 'Daniyal Khan',
            role: 'IT Director',
            isPresent: true,
          ),

          SizedBox(height: 12),

          _EmployeeAttendance(
            name: 'Turaab Haider',
            role: 'Full Stack Developer',
            isPresent: true,
          ),

          SizedBox(height: 12),

          _EmployeeAttendance(
            name: 'Mavia',
            role: 'Merchandising',
            isPresent: false,
          ),

          SizedBox(height: 12),

          _EmployeeAttendance(
            name: 'Mehwish',
            role: 'Merchandising',
            isPresent: true,
          ),
        ],
      ),
    );
  }
}

class _AttendanceSummary extends StatelessWidget {
  const _AttendanceSummary();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 22),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            _SummaryItem(
              title: 'Present',
              value: '4',
            ),
            _SummaryItem(
              title: 'Absent',
              value: '1',
            ),
            _SummaryItem(
              title: 'Total',
              value: '5',
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String title;
  final String value;

  const _SummaryItem({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            color: AppColors.text.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}

class _EmployeeAttendance extends StatelessWidget {
  final String name;
  final String role;
  final bool isPresent;

  const _EmployeeAttendance({
    required this.name,
    required this.role,
    required this.isPresent,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ),
        leading: CircleAvatar(
          child: Text(
            name[0],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(role),
        trailing: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            isPresent ? 'Present' : 'Absent',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isPresent
                  ? AppColors.primary
                  : AppColors.text.withOpacity(0.6),
            ),
          ),
        ),
      ),
    );
  }
}