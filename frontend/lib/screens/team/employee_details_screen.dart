import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../services/api_service.dart';

class EmployeeDetailsScreen extends StatefulWidget {
  final int userId;

  const EmployeeDetailsScreen({
    super.key,
    required this.userId,
  });

  @override
  State<EmployeeDetailsScreen> createState() =>
      _EmployeeDetailsScreenState();
}

class _EmployeeDetailsScreenState
    extends State<EmployeeDetailsScreen> {
  Map<String, dynamic>? user;
  bool loading = true;
  bool deleting = false;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    try {
      final data =
      await ApiService().getUser(widget.userId);

      if (!mounted) return;

      setState(() {
        user = data;
        loading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });
    }
  }

  Future<void> deleteEmployee() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Remove Employee?'),
        content: Text(
          'Remove ${user?['name'] ?? 'this employee'} from Paktex?',
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () =>
                Navigator.pop(context, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      deleting = true;
    });

    try {
      await ApiService().deleteUser(widget.userId);

      if (!mounted) return;

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

      setState(() {
        deleting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('Employee not found'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Employee Details'),
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

          const SizedBox(height: 20),

          Center(
            child: Text(
              user!['name'] ?? '',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 6),

          Center(
            child: Text(
              user!['position'] ?? 'Employee',
            ),
          ),

          const SizedBox(height: 30),

          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.email),
                  title: const Text('Email'),
                  subtitle: Text(
                    user!['email'] ?? '',
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.admin_panel_settings,
                  ),
                  title: const Text('Role'),
                  subtitle: Text(
                    user!['role'] ?? '',
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.work),
                  title: const Text('Position'),
                  subtitle: Text(
                    user!['position'] ?? 'Not specified',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          if (ApiService.isAdmin &&
              user!['id'] != ApiService.currentUser?['id'])
            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed:
                deleting ? null : deleteEmployee,
                icon: const Icon(Icons.delete_outline),
                label: const Text('Remove Employee'),
              ),
            ),
        ],
      ),
    );
  }
}