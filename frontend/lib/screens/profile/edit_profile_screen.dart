import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final nameController = TextEditingController(
    text: 'Turaab Haider',
  );

  final emailController = TextEditingController(
    text: 'turaab@paktex.com',
  );

  final roleController = TextEditingController(
    text: 'Full Stack Developer',
  );

  final departmentController = TextEditingController(
    text: 'IT',
  );

  void saveChanges() {
    print('Name: ${nameController.text}');
    print('Email: ${emailController.text}');
    print('Role: ${roleController.text}');
    print('Department: ${departmentController.text}');

    Navigator.pop(context);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    roleController.dispose();
    departmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
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
            'Update Profile',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Update your personal information.',
            style: TextStyle(
              fontSize: 15,
              color: AppColors.text.withOpacity(0.6),
            ),
          ),

          const SizedBox(height: 28),

          const Text(
            'Full Name',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 8),

          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.person_outline),
              hintText: 'Enter your name',
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Email',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 8),

          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.email_outlined),
              hintText: 'Enter your email',
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Role',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 8),

          TextField(
            controller: roleController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.work_outline),
              hintText: 'Enter your role',
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Department',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 8),

          TextField(
            controller: departmentController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.business_outlined),
              hintText: 'Enter your department',
            ),
          ),

          const SizedBox(height: 28),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: saveChanges,
              icon: const Icon(Icons.save_outlined),
              label: const Text(
                'Save Changes',
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