import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import 'add_employee_screen.dart';
import 'employee_details_screen.dart';

class TeamScreen extends StatelessWidget {
  const TeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Our Team',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddEmployeeScreen(),
                ),
              );
            },
            icon: const Icon(Icons.person_add_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Team Members',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'View your colleagues and their roles.',
            style: TextStyle(
              fontSize: 15,
              color: AppColors.text.withOpacity(0.6),
            ),
          ),

          const SizedBox(height: 28),

          const _TeamMember(
            name: 'Zeeshan Khan',
            role: 'General Manager',
            department: 'Management',
          ),

          const SizedBox(height: 12),

          const _TeamMember(
            name: 'Daniyal Khan',
            role: 'IT Director',
            department: 'IT',
          ),

          const SizedBox(height: 12),

          const _TeamMember(
            name: 'Turaab Haider',
            role: 'Full Stack Developer',
            department: 'IT',
          ),

          const SizedBox(height: 12),

          const _TeamMember(
            name: 'Mavia',
            role: 'Merchandising',
            department: 'Merchandising',
          ),

          const SizedBox(height: 12),

          const _TeamMember(
            name: 'Mehwish',
            role: 'Merchandising',
            department: 'Merchandising',
          ),
        ],
      ),
    );
  }
}

class _TeamMember extends StatelessWidget {
  final String name;
  final String role;
  final String department;

  const _TeamMember({
    required this.name,
    required this.role,
    required this.department,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EmployeeDetailsScreen(
                name: name,
                role: role,
                department: department,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 6,
          ),
          child: ListTile(
            leading: CircleAvatar(
              radius: 24,
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
                fontSize: 16,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '$role • $department',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.text.withOpacity(0.6),
                ),
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
          ),
        ),
      ),
    );
  }
}