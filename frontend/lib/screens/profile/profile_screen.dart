import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../services/api_service.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = ApiService.currentUser;

    final name = user?['name'] ?? 'User';
    final email = user?['email'] ?? '';
    final role = user?['role'] ?? 'employee';
    final position = user?['position'] ?? 'Not specified';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const CircleAvatar(
            radius: 50,
            child: Icon(
              Icons.person,
              size: 50,
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
              position,
              style: TextStyle(
                color: AppColors.text.withOpacity(0.6),
              ),
            ),
          ),

          const SizedBox(height: 30),

          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.email_outlined),
                  title: const Text('Email'),
                  subtitle: Text(email),
                ),
                ListTile(
                  leading: const Icon(Icons.work_outline),
                  title: const Text('Position'),
                  subtitle: Text(position),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.admin_panel_settings_outlined,
                  ),
                  title: const Text('Role'),
                  subtitle: Text(
                    role == 'admin'
                        ? 'Administrator'
                        : 'Employee',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 50,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                    const EditProfileScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profile'),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                ApiService.logout();

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                      (route) => false,
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }
}