import 'package:flutter/material.dart';

import 'edit_profile_screen.dart';
import '../../core/constants/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const CircleAvatar(
            radius: 45,
            child: Icon(
              Icons.person,
              size: 45,
            ),
          ),

          const SizedBox(height: 16),

          const Center(
            child: Text(
              'Turaab Haider',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 6),

          Center(
            child: Text(
              'Full Stack Developer',
              style: TextStyle(
                fontSize: 15,
                color: AppColors.text.withOpacity(0.6),
              ),
            ),
          ),

          const SizedBox(height: 32),

          Card(
            elevation: 0,
            child: Column(
              children: const [
                ListTile(
                  leading: Icon(Icons.email_outlined),
                  title: Text('Email'),
                  subtitle: Text('turaab@paktex.com'),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.business_outlined),
                  title: Text('Department'),
                  subtitle: Text('IT'),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.work_outline),
                  title: Text('Role'),
                  subtitle: Text('Full Stack Developer'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EditProfileScreen(),
                  ),
                );
              },
              child: const Text('Edit Profile'),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                      (route) => false,
                );
              },
              child: const Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }
}