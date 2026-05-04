import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get uid => _auth.currentUser?.uid;

  // ======================
  // 🧠 SAVE MOOD
  // ======================
  Future<void> saveMood(String mood, String note) async {
    if (uid == null) return;

    await _db.collection('users').doc(uid).collection('moods').add({
      'mood': mood,
      'note': note,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // ======================
  // 📊 GET MOODS
  // ======================
  Stream<QuerySnapshot> getMoods() {
    if (uid == null) return const Stream.empty();

    return _db
        .collection('users')
        .doc(uid)
        .collection('moods')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // ======================
  // 📝 SAVE JOURNAL
  // ======================
  Future<void> saveJournal(String text) async {
    if (uid == null) return;

    await _db.collection('users').doc(uid).collection('journals').add({
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // ======================
  // 📝 SAVE JOURNAL WITH IMAGE
  // ======================
  Future<void> saveJournalWithImage(String text, String? imageUrl) async {
    if (uid == null) return;

    await _db.collection('users').doc(uid).collection('journals').add({
      'text': text,
      'imageUrl': imageUrl,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // ======================
  // 📚 GET JOURNALS
  // ======================
  Stream<QuerySnapshot> getJournals() {
    if (uid == null) return const Stream.empty();

    return _db
        .collection('users')
        .doc(uid)
        .collection('journals')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // ======================
  // 📈 7-DAY MOODS (INSIGHTS)
  // ======================
  Future<List<Map<String, dynamic>>> getLast7DayMoods() async {
    if (uid == null) return [];

    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));

    final snapshot = await _db
        .collection('users')
        .doc(uid)
        .collection('moods')
        .where('timestamp',
            isGreaterThanOrEqualTo: Timestamp.fromDate(sevenDaysAgo))
        .orderBy('timestamp', descending: false)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  // ======================
  // 📸 UPLOAD IMAGE
  // ======================
  Future<String?> uploadImage(File file) async {
    if (uid == null) return null;

    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('users')
          .child(uid!)
          .child('journal_images')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      print("Upload error: $e");
      return null;
    }
  }
}