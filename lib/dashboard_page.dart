import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/courses_page.dart';
import 'pages/timetable_page.dart';
import 'pages/assignments_page.dart';
import 'pages/notes_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  final _pages = const [
    CoursesPage(),
    TimetablePage(),
    AssignmentsPage(),
    NotesPage(),
  ];

  final _pageTitles = const [
    'My Courses',
    'Timetable',
    'Assignments',
    'Download Notes',
  ];

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // —— Left Navigation Panel ——
          Container(
            color: const Color.fromARGB(255, 216, 15, 15),
            child: Column(
              children: [
                const SizedBox(height: 40),
                const Icon(Icons.school, color: Colors.white, size: 40),
                const SizedBox(height: 10),
                const Text(
                  "CITYU Portal",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const Divider(color: Colors.white70, thickness: 1),
                Expanded(
                  child: NavigationRail(
                    selectedIndex: _selectedIndex,
                    onDestinationSelected: (i) =>
                        setState(() => _selectedIndex = i),
                    labelType: NavigationRailLabelType.all,
                    backgroundColor: Colors.red.shade300,
                    unselectedLabelTextStyle: const TextStyle(
                      color: Colors.white,
                    ),
                    selectedLabelTextStyle: const TextStyle(
                      color: Colors.black,
                    ),
                    unselectedIconTheme: const IconThemeData(
                      color: Colors.white,
                    ),
                    selectedIconTheme: const IconThemeData(color: Colors.black),
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.book),
                        label: Text('Courses'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.calendar_month),
                        label: Text('Timetable'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.assignment),
                        label: Text('Assignments'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.file_download),
                        label: Text('Notes'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                IconButton(
                  tooltip: 'Logout',
                  icon: const Icon(Icons.logout, color: Colors.white),
                  onPressed: _logout,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // —— Right Content Panel ——
          const VerticalDivider(width: 1),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.red.shade100,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Text(
                    'Welcome to CityU Student Portal — ${_pageTitles[_selectedIndex]}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _pages[_selectedIndex],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
