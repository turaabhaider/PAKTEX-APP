import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../services/api_service.dart';
import 'add_employee_screen.dart';
import 'employee_details_screen.dart';

class TeamScreen extends StatefulWidget {
  const TeamScreen({super.key});

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  final api = ApiService();

  List<dynamic> users = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    try {
      final data = await api.getUsers();

      if (!mounted) return;

      setState(() {
        users = data;
        loading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Team',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      floatingActionButton: ApiService.isAdmin
          ? FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
              const AddEmployeeScreen(),
            ),
          );

          loadUsers();
        },
        child: const Icon(Icons.person_add),
      )
          : null,
      body: loading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : RefreshIndicator(
        onRefresh: loadUsers,
        child: ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];

            return Card(
              margin: const EdgeInsets.only(
                bottom: 12,
              ),
              child: ListTile(
                contentPadding:
                const EdgeInsets.all(14),
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: Text(
                  user['name'] ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  user['position'] ??
                      user['role'] ??
                      'Employee',
                ),
                trailing:
                const Icon(Icons.chevron_right),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          EmployeeDetailsScreen(
                            userId: user['id'],
                          ),
                    ),
                  );

                  loadUsers();
                },
              ),
            );
          },
        ),
      ),
    );
  }
}