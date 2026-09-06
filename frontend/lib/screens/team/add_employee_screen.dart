import 'package:flutter/material.dart';

import '../../services/api_service.dart';

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({super.key});

  @override
  State<AddEmployeeScreen> createState() =>
      _AddEmployeeScreenState();
}

class _AddEmployeeScreenState
    extends State<AddEmployeeScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final positionController = TextEditingController();

  String role = 'employee';
  bool saving = false;

  Future<void> addEmployee() async {
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Name, email and password are required',
          ),
        ),
      );
      return;
    }

    setState(() {
      saving = true;
    });

    try {
      await ApiService().createUser(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        role: role,
        position: positionController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Employee added successfully'),
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
    passwordController.dispose();
    positionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Employee'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              prefixIcon: Icon(Icons.person),
            ),
          ),

          const SizedBox(height: 18),

          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email),
            ),
          ),

          const SizedBox(height: 18),

          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Temporary Password',
              prefixIcon: Icon(Icons.lock),
            ),
          ),

          const SizedBox(height: 18),

          TextField(
            controller: positionController,
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
              prefixIcon: Icon(Icons.admin_panel_settings),
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
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  role = value;
                });
              }
            },
          ),

          const SizedBox(height: 28),

          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: saving ? null : addEmployee,
              child: saving
                  ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
                  : const Text(
                'Add Employee',
                style: TextStyle(
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