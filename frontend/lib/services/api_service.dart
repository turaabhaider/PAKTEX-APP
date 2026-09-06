import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'https://paktex-app-production.up.railway.app';

  static String? token;
  static Map<String, dynamic>? currentUser;

  Map<String, String> get headers => {
    'Content-Type': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  };

  // ============================================================
  // AUTH - REGISTER
  // ============================================================

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String? position,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/register'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'position': position,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return Map<String, dynamic>.from(data);
    }

    throw Exception(
      data['message'] ?? 'Registration failed',
    );
  }

  // ============================================================
  // AUTH - LOGIN
  // ============================================================

  Future<Map<String, dynamic>> login(
      String email,
      String password,
      ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      token = data['token'];

      currentUser = Map<String, dynamic>.from(
        data['user'],
      );

      return data;
    }

    throw Exception(
      data['message'] ?? 'Login failed',
    );
  }

  // ============================================================
  // USERS
  // ============================================================

  Future<List<dynamic>> getUsers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/users'),
      headers: headers,
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(
      data['message'] ?? 'Failed to load users',
    );
  }

  Future<Map<String, dynamic>> getUser(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/users/$id'),
      headers: headers,
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(data);
    }

    throw Exception(
      data['message'] ?? 'Failed to load user',
    );
  }

  Future<void> createUser({
    required String name,
    required String email,
    required String password,
    required String role,
    required String position,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/users'),
      headers: headers,
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'role': role,
        'position': position,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 201) {
      throw Exception(
        data['message'] ?? 'Failed to create user',
      );
    }
  }

  Future<void> updateUser({
    required int id,
    required String name,
    required String email,
    required String role,
    required String position,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/users/$id'),
      headers: headers,
      body: jsonEncode({
        'name': name,
        'email': email,
        'role': role,
        'position': position,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(
        data['message'] ?? 'Failed to update user',
      );
    }

    if (currentUser?['id'] == id) {
      currentUser = {
        ...?currentUser,
        'name': name,
        'email': email,
        'role': role,
        'position': position,
      };
    }
  }

  Future<void> deleteUser(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/users/$id'),
      headers: headers,
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(
        data['message'] ?? 'Failed to delete user',
      );
    }
  }

  // ============================================================
  // ATTENDANCE
  // ============================================================

  Future<List<dynamic>> getTodayAttendance() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/attendance/today'),
      headers: headers,
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(
      data['message'] ?? 'Failed to load attendance',
    );
  }

  Future<List<dynamic>> getMyAttendance() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/attendance/my'),
      headers: headers,
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(
      data['message'] ?? 'Failed to load attendance',
    );
  }

  Future<void> checkIn() async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/attendance/check-in'),
      headers: headers,
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 201) {
      throw Exception(
        data['message'] ?? 'Check-in failed',
      );
    }
  }

  Future<void> checkOut() async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/attendance/check-out'),
      headers: headers,
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(
        data['message'] ?? 'Check-out failed',
      );
    }
  }

  // ============================================================
  // TASKS
  // ============================================================

  Future<List<dynamic>> getTasks() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/tasks'),
      headers: headers,
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(
      data['message'] ?? 'Failed to load tasks',
    );
  }

  Future<Map<String, dynamic>> getTask(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/tasks/$id'),
      headers: headers,
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(data);
    }

    throw Exception(
      data['message'] ?? 'Failed to load task',
    );
  }

  Future<void> createTask({
    required String title,
    required String description,
    required int assignedTo,
    String? dueDate,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/tasks'),
      headers: headers,
      body: jsonEncode({
        'title': title,
        'description': description,
        'assigned_to': assignedTo,
        'due_date': dueDate,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 201) {
      throw Exception(
        data['message'] ?? 'Failed to create task',
      );
    }
  }

  Future<void> updateTask({
    required int id,
    String? title,
    String? description,
    String? status,
    int? progress,
    String? dueDate,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/tasks/$id'),
      headers: headers,
      body: jsonEncode({
        if (title != null) 'title': title,
        if (description != null) 'description': description,
        if (status != null) 'status': status,
        if (progress != null) 'progress': progress,
        if (dueDate != null) 'due_date': dueDate,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(
        data['message'] ?? 'Failed to update task',
      );
    }
  }

  Future<void> deleteTask(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/tasks/$id'),
      headers: headers,
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(
        data['message'] ?? 'Failed to delete task',
      );
    }
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  static void logout() {
    token = null;
    currentUser = null;
  }

  // ============================================================
  // ADMIN
  // ============================================================

  static bool get isAdmin {
    return currentUser?['role'] == 'admin';
  }
}