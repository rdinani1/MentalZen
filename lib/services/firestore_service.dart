import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  // SAVE MOOD
  Future<void> saveMood(String mood, String note) async {
    await _db.collection('users').doc(uid).collection('moods').add({
      'mood': mood,
      'note': note,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // GET MOODS
  Stream<QuerySnapshot> getMoods() {
    return _db
        .collection('users')
        .doc(uid)
        .collection('moods')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // SAVE JOURNAL
  Future<void> saveJournal(String text) async {
    await _db.collection('users').doc(uid).collection('journals').add({
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // GET JOURNALS
  Stream<QuerySnapshot> getJournals() {
    return _db
        .collection('users')
        .doc(uid)
        .collection('journals')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}