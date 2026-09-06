import 'package:flutter/material.dart';

import '../../services/api_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController positionController;

  String role = 'employee';
  bool saving = false;

  @override
  void initState() {
    super.initState();

    final user = ApiService.currentUser ?? {};

    nameController = TextEditingController(
      text: user['name'] ?? '',
    );

    emailController = TextEditingController(
      text: user['email'] ?? '',
    );

    positionController = TextEditingController(
      text: user['position'] ?? '',
    );

    role = user['role'] ?? 'employee';
  }

  Future<void> saveChanges() async {
    final id = ApiService.currentUser?['id'];

    if (id == null) return;

    if (!ApiService.isAdmin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Only admins can update profiles with the current API',
          ),
        ),
      );
      return;
    }

    setState(() {
      saving = true;
    });

    try {
      await ApiService().updateUser(
        id: id,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        role: role,
        position: positionController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
        ),
      );

      Navigator.pop(context);
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
        setState(() {
          saving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    positionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = ApiService.isAdmin;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          TextField(
            controller: nameController,
            enabled: isAdmin,
            decoration: const InputDecoration(
              labelText: 'Name',
              prefixIcon: Icon(Icons.person),
            ),
          ),

          const SizedBox(height: 18),

          TextField(
            controller: emailController,
            enabled: isAdmin,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email),
            ),
          ),

          const SizedBox(height: 18),

          TextField(
            controller: positionController,
            enabled: isAdmin,
            decoration: const InputDecoration(
              labelText: 'Position',
              prefixIcon: Icon(Icons.work),
            ),
          ),

          const SizedBox(height: 18),

          DropdownButtonFormField<String>(
            value: role,
            decoration: const InputDecoration(
              labelText: 'Role',
              prefixIcon: Icon(
                Icons.admin_panel_settings,
              ),
            ),
            items: const [
              DropdownMenuItem(
                value: 'employee',
                child: Text('Employee'),
              ),
              DropdownMenuItem(
                value: 'admin',
                child: Text('Admin'),
              ),
            ],
            onChanged: isAdmin
                ? (value) {
              if (value != null) {
                setState(() {
                  role = value;
                });
              }
            }
                : null,
          ),

          const SizedBox(height: 28),

          if (isAdmin)
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: saving ? null : saveChanges,
                child: saving
                    ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
                    : const Text(
                  'Save Changes',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          else
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Profile editing is currently restricted to administrators.',
                ),
              ),
            ),
        ],
      ),
    );
  }
}