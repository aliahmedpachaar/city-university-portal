import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (!context.mounted) return;
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 250,
            color: Colors.red.shade300,
            child: Column(
              children: [
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.admin_panel_settings,
                      size: 32,
                      color: Colors.white,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Admin Panel',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                ListTile(
                  leading: const Icon(Icons.schedule, color: Colors.white),
                  title: const Text(
                    'Timetable',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () => Navigator.pushNamed(context, '/admin_timetable'),
                ),
                ListTile(
                  leading: const Icon(Icons.book, color: Colors.white),
                  title: const Text(
                    'Courses',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () => Navigator.pushNamed(context, '/admin_courses'),
                ),
                ListTile(
                  leading: const Icon(Icons.assignment, color: Colors.white),
                  title: const Text(
                    'Assignments',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () =>
                      Navigator.pushNamed(context, '/admin_assignments'),
                ),
                ListTile(
                  leading: const Icon(Icons.file_present, color: Colors.white),
                  title: const Text(
                    'Notes',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () => Navigator.pushNamed(context, '/admin_notes'),
                ),
                const Spacer(),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.white),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () => _logout(context),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(30),
              color: Colors.grey.shade100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SizedBox(height: 20),
                  Text(
                    'Welcome Admin',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Use the left panel to manage all student data including timetable, courses, assignments, and notes.',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  SizedBox(height: 30),
                  // You can add summary stats or dashboard cards here
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
