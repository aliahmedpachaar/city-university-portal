import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TimetablePage extends StatefulWidget {
  const TimetablePage({super.key});

  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  final List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  final List<String> slots = ['8-11', '11-2', '2-5'];
  Map<String, Map<String, String>> timetable = {}; // day -> slot -> subject
  bool isAdmin = false;
  bool loading = true;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadTimetable();
  }

  Future<void> _loadTimetable() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final userDoc = await FirebaseFirestore.instance
        .collection('students')
        .doc(uid)
        .get();
    final userData = userDoc.data();
    if (userData == null) return;

    setState(() {
      isAdmin = userData['isAdmin'] == true;
    });

    final ttDoc = await FirebaseFirestore.instance
        .collection('timetable')
        .doc('main')
        .get();
    final fetched = ttDoc.data() ?? {};

    for (var day in days) {
      timetable[day] = {};
      for (var slot in slots) {
        timetable[day]![slot] = fetched['$day-$slot'] ?? '';
      }
    }

    setState(() => loading = false);
  }

  Future<void> _saveTimetable() async {
    Map<String, dynamic> data = {};
    for (var day in days) {
      for (var slot in slots) {
        data['$day-$slot'] = timetable[day]![slot];
      }
    }
    await FirebaseFirestore.instance
        .collection('timetable')
        .doc('main')
        .set(data);
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Timetable saved')));
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Timetable'),
        backgroundColor: Colors.red.shade300,
        actions: isAdmin
            ? [
                IconButton(
                  icon: Icon(isEditing ? Icons.edit_off : Icons.edit),
                  onPressed: () {
                    setState(() => isEditing = !isEditing);
                  },
                  tooltip: isEditing ? 'Disable Edit Mode' : 'Enable Edit Mode',
                ),
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: _saveTimetable,
                  tooltip: 'Save Timetable',
                ),
              ]
            : null,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            const DataColumn(label: Text('Day')),
            ...slots.map((slot) => DataColumn(label: Text(slot))),
          ],
          rows: days.map((day) {
            return DataRow(
              cells: [
                DataCell(Text(day)),
                ...slots.map((slot) {
                  final subject = timetable[day]![slot] ?? '';
                  if (isAdmin && isEditing) {
                    return DataCell(
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: subject,
                              onChanged: (value) =>
                                  timetable[day]![slot] = value,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 4,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              size: 18,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() => timetable[day]![slot] = '');
                            },
                          ),
                        ],
                      ),
                    );
                  } else {
                    return subject.isNotEmpty
                        ? DataCell(Text(subject))
                        : const DataCell(Text('-'));
                  }
                }),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
