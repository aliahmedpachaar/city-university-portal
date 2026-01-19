import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AssignmentsPage extends StatefulWidget {
  const AssignmentsPage({super.key});

  @override
  State<AssignmentsPage> createState() => _AssignmentsPageState();
}

class _AssignmentsPageState extends State<AssignmentsPage> {
  bool isAdmin = false;
  bool loading = true;
  bool editing = false;

  // Default blank block
  static Map<String, String> _emptyAssignment() => {
    'subject': '',
    'title': '',
    'dueDate': '',
    'description': '',
  };

  // 9 placeholders
  final List<Map<String, String>> assignments = List.generate(
    9,
    (_) => _emptyAssignment(),
  );

  @override
  void initState() {
    super.initState();
    _checkAdmin();
    _loadAssignments();
  }

  Future<void> _checkAdmin() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final doc = await FirebaseFirestore.instance
        .collection('students')
        .doc(uid)
        .get();
    setState(() {
      isAdmin = (doc.data()?['isAdmin'] == true);
    });
  }

  Future<void> _loadAssignments() async {
    final doc = await FirebaseFirestore.instance
        .collection('assignments')
        .doc('main')
        .get();
    final data = doc.data();
    if (data != null && data['items'] is List) {
      final loaded = List<Map<String, String>>.from(
        (data['items'] as List).map(
          (e) => {..._emptyAssignment(), ...Map<String, String>.from(e)},
        ),
      );
      for (int i = 0; i < 9; i++) {
        assignments[i] = i < loaded.length ? loaded[i] : _emptyAssignment();
      }
    }
    setState(() => loading = false);
  }

  Future<void> _saveAssignments() async {
    final cleaned = assignments
        .map((a) => a.map((k, v) => MapEntry(k, v.trim())))
        .toList(growable: false);

    await FirebaseFirestore.instance.collection('assignments').doc('main').set({
      'items': cleaned,
    });

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Assignments saved')));
    }
  }

  // ─────────────────────────────── UI Widgets
  Widget _field(String label, String value, ValueChanged<String> onChanged) {
    final enabled = isAdmin && editing;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        initialValue: value,
        enabled: enabled,
        onChanged: enabled ? onChanged : null,
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

  Widget _block(int i) {
    final a = assignments[i];
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Assignment ${i + 1}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _field('Subject', a['subject']!, (v) => a['subject'] = v),
            _field('Title', a['title']!, (v) => a['title'] = v),
            _field('Due Date', a['dueDate']!, (v) => a['dueDate'] = v),
            _field(
              'Description',
              a['description']!,
              (v) => a['description'] = v,
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────── BUILD
  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignments'),
        backgroundColor: const Color.fromARGB(255, 235, 9, 9),
        actions: isAdmin
            ? [
                IconButton(
                  icon: Icon(editing ? Icons.save : Icons.edit),
                  tooltip: editing ? 'Save' : 'Edit',
                  onPressed: () async {
                    if (editing) await _saveAssignments();
                    setState(() => editing = !editing);
                  },
                ),
              ]
            : null,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: assignments.length,
        itemBuilder: (_, i) => _block(i),
      ),
    );
  }
}
