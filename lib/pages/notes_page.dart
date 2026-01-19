import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  bool isAdmin = true; // ← set false for student view

  List<Map<String, String>> notes = [];

  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _urlCtrl = TextEditingController();

  static const _prefsKey = 'saved_notes';

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw != null) {
      final List decoded = jsonDecode(raw);
      setState(() {
        notes = List<Map<String, String>>.from(
          decoded.map((e) => Map<String, String>.from(e)),
        );
      });
    } else {
      // default demo notes
      notes = [
        {'title': 'Lecture 1 Notes', 'url': 'https://example.com/lecture1.pdf'},
        {
          'title': 'Assignment Instructions',
          'url': 'https://example.com/assignment.pdf',
        },
      ];
    }
  }

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, jsonEncode(notes));
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Notes saved locally')));
    }
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not open the link')));
    }
  }

  void _addNoteDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add New Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _urlCtrl,
              decoration: const InputDecoration(labelText: 'URL'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (_titleCtrl.text.isNotEmpty && _urlCtrl.text.isNotEmpty) {
                setState(() {
                  notes.add({
                    'title': _titleCtrl.text.trim(),
                    'url': _urlCtrl.text.trim(),
                  });
                  _titleCtrl.clear();
                  _urlCtrl.clear();
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        backgroundColor: Colors.red.shade300,
        actions: isAdmin
            ? [
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'Add Note',
                  onPressed: _addNoteDialog,
                ),
                IconButton(
                  icon: const Icon(Icons.save),
                  tooltip: 'Save Notes',
                  onPressed: _saveNotes,
                ),
              ]
            : null,
      ),
      body: notes.isEmpty
          ? const Center(child: Text('No notes available'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: notes.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (_, i) {
                final note = notes[i];
                return ListTile(
                  leading: const Icon(Icons.picture_as_pdf),
                  title: Text(note['title'] ?? 'Unnamed'),
                  trailing: ElevatedButton(
                    onPressed: () => _launchURL(note['url'] ?? ''),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    child: const Text(
                      'Download',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
