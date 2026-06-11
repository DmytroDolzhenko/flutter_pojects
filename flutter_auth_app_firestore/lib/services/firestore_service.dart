import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/note.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DocumentSnapshot? _lastDocument; 
  static const int _pageSize = 5;

  CollectionReference _getNotesCollection() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Користувач не авторизований!');
    return _firestore.collection('users').doc(user.uid).collection('notes');
  }

  void resetPagination() {
    _lastDocument = null;
  }

  Future<void> createNote(String title, String content) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await _getNotesCollection().add({
      'title': title,
      'content': content, 
      'userId': user.uid,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

Future<List<Note>> getNotesPage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    Query query = _getNotesCollection()
        .orderBy('createdAt', descending: true)
        .limit(_pageSize);

    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    final snapshot = await query.get();

    if (snapshot.docs.isNotEmpty) {
      _lastDocument = snapshot.docs.last;
    }

    return snapshot.docs.map((doc) {
      return Note.fromJson(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  Stream<List<Note>> getNotes() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return Stream.value([]);

    return _getNotesCollection()
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Note.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<void> updateNote(String noteId, String title, String content) async {
    await _getNotesCollection().doc(noteId).update({
      'title': title,
      'content': content,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteNote(String noteId) async {
    await _getNotesCollection().doc(noteId).delete();
  }
}