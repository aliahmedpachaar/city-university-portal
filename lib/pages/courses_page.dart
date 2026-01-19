import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  bool isAdmin = false;
  bool loading = true;
  bool editing = false;

  /// Always keep 9 course maps in memory
  final List<Map<String, String>> courses = List.generate(
    9,
    (_) => _emptyCourse(),
  );

  static Map<String, String> _emptyCourse() => {
    'subjectName': '',
    'subjectCode': '',
    'lecturerName': '',
    'lecturerEmail': '',
  };

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
    _loadCourses();
  }

  Future<void> _checkAdminStatus() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final doc = await FirebaseFirestore.instance
        .collection('students')
        .doc(uid)
        .get();
    setState(() {
      isAdmin = doc.data()?['isAdmin'] == true;
    });
  }

  // ─────────────────────────────── LOAD
  Future<void> _loadCourses() async {
    final doc = await FirebaseFirestore.instance
        .collection('courses')
        .doc('main')
        .get();
    final data = doc.data();
    if (data != null && data['courses'] is List) {
      final List loaded = data['courses'];
      for (int i = 0; i < 9; i++) {
        if (i < loaded.length && loaded[i] is Map) {
          // merge with default to ensure all keys exist
          courses[i] = {
            ..._emptyCourse(),
            ...Map<String, String>.from(loaded[i]),
          };
        }
      }
    }
    setState(() => loading = false);
  }

  // ─────────────────────────────── SAVE
  Future<void> _saveCourses() async {
    // trim whitespace to avoid accidental empty strings with spaces
    final cleaned = courses
        .map((c) => c.map((k, v) => MapEntry(k, v.trim())))
        .toList(growable: false);

    await FirebaseFirestore.instance.collection('courses').doc('main').set({
      'courses': cleaned,
    });

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Courses saved')));
  }

  // ─────────────────────────────── UI HELPERS
  Widget _buildCourseBlock(int idx) {
    final course = courses[idx];
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Course ${idx + 1}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _field(
              'Subject Name',
              course['subjectName']!,
              (v) => course['subjectName'] = v,
            ),
            _field(
              'Subject Code',
              course['subjectCode']!,
              (v) => course['subjectCode'] = v,
            ),
            _field(
              'Lecturer Name',
              course['lecturerName']!,
              (v) => course['lecturerName'] = v,
            ),
            _field(
              'Lecturer Email',
              course['lecturerEmail']!,
              (v) => course['lecturerEmail'] = v,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _action('Assignment'),
                _action('Project'),
                _action('Tutorial'),
                _action('Quizz'),
                _action('Midterm Exam'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(String label, String value, ValueChanged<String> onChanged) {
    final enabled = isAdmin && editing;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        initialValue: value,
        onChanged: enabled ? onChanged : null,
        enabled: enabled,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          border: const OutlineInputBorder(),
          isDense: true,
          disabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _action(String label) => ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.red.shade300,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
    child: Text(label, style: const TextStyle(color: Colors.white)),
  );

  // ─────────────────────────────── BUILD
  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
        backgroundColor: Colors.red.shade300,
        actions: isAdmin
            ? [
                IconButton(
                  icon: Icon(editing ? Icons.save : Icons.edit),
                  onPressed: () {
                    if (editing) _saveCourses();
                    setState(() => editing = !editing);
                  },
                ),
              ]
            : null,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: courses.length,
        itemBuilder: (_, i) => _buildCourseBlock(i),
      ),
    );
  }
}
