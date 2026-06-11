import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/setting_screen.dart';
import '../models/note.dart';
import '../services/firestore_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  
  final List<Note> _notes = [];
  bool _isLoading = false;
  bool _hasMore = true;   
  @override
  void initState() {
    super.initState();
    _loadMoreNotes();
  }

  Future<void> _loadMoreNotes() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    final newNotes = await _firestoreService.getNotesPage();

    setState(() {
      _isLoading = false;
      if (newNotes.length < 5) { 
        _hasMore = false;
      }
      _notes.addAll(newNotes);
    });
  }

  Future<void> _refreshNotes() async {
    _firestoreService.resetPagination();
    setState(() {
      _notes.clear();
      _hasMore = true;
    });
    await _loadMoreNotes();
  }

  Future<void> _logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Logout')),
        ],
      ),
    );
    if (shouldLogout == true) {
      await FirebaseAuth.instance.signOut();
    }
  }

  void _showNoteDialog({Note? note}) {
    final titleController = TextEditingController(text: note?.title ?? '');
    final contentController = TextEditingController(text: note?.content ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(note == null ? 'New Note' : 'Edit Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
            TextField(controller: contentController, decoration: const InputDecoration(labelText: 'Content'), maxLines: 3),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
                if (note == null) {
                  await _firestoreService.createNote(titleController.text, contentController.text);
                } else {
                  await _firestoreService.updateNote(note.id, titleController.text, contentController.text);
                }
                if (context.mounted) {
                  Navigator.pop(context);
                }
                _refreshNotes();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Notes (${user.email})'),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen())),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNoteDialog(),
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshNotes,
        child: _notes.isEmpty && _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _notes.isEmpty
                ? const Center(child: Text('No notes yet. Click + to add one!'))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _notes.length + 1, 
                    itemBuilder: (context, index) {
                      if (index == _notes.length) {
                        if (_hasMore) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: _isLoading
                                  ? const CircularProgressIndicator()
                                  : ElevatedButton(
                                      onPressed: _loadMoreNotes,
                                      child: const Text('Load More'),
                                    ),
                            ),
                          );
                        } else {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: Text('All notes loaded 🎉')),
                          );
                        }
                      }

                      final note = _notes[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(note.content),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _showNoteDialog(note: note),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  await _firestoreService.deleteNote(note.id);
                                  _refreshNotes();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}