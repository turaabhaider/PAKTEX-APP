import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class EmployeeDetailsScreen extends StatelessWidget {
  final String name;
  final String role;
  final String department;

  const EmployeeDetailsScreen({
    super.key,
    required this.name,
    required this.role,
    required this.department,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Employee Details',
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
          CircleAvatar(
            radius: 48,
            child: Text(
              name[0],
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 18),

          Center(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 6),

          Center(
            child: Text(
              role,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.text.withOpacity(0.6),
              ),
            ),
          ),

          const SizedBox(height: 30),

          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.work_outline),
                  title: const Text(
                    'Role',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(role),
                ),

                const Divider(height: 1),

                ListTile(
                  leading: const Icon(Icons.business_outlined),
                  title: const Text(
                    'Department',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(department),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.delete_outline),
              label: const Text('Remove Employee'),
            ),
          ),
        ],
      ),
    );
  }
}