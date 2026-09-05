import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class AddEmployeeScreen extends StatelessWidget {
  const AddEmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Add Employee',
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
          const Text(
            'New Team Member',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Add the employee details below.',
            style: TextStyle(
              fontSize: 15,
              color: AppColors.text.withOpacity(0.6),
            ),
          ),

          const SizedBox(height: 28),

          const TextField(
            decoration: InputDecoration(
              labelText: 'Full Name',
              hintText: 'Enter full name',
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),

          const SizedBox(height: 16),

          const TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'Enter email address',
              prefixIcon: Icon(Icons.email_outlined),
            ),
          ),

          const SizedBox(height: 16),

          const TextField(
            decoration: InputDecoration(
              labelText: 'Role',
              hintText: 'Enter employee role',
              prefixIcon: Icon(Icons.work_outline),
            ),
          ),

          const SizedBox(height: 16),

          const TextField(
            decoration: InputDecoration(
              labelText: 'Department',
              hintText: 'Enter department',
              prefixIcon: Icon(Icons.business_outlined),
            ),
          ),

          const SizedBox(height: 28),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Add Employee',
                style: TextStyle(
                  fontSize: 16,
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