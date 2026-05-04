import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  // 📊 GET MOODS (STREAM)
  // ======================
  Stream<QuerySnapshot> getMoods() {
    if (uid == null) {
      return const Stream.empty();
    }

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
  // 📚 GET JOURNALS (STREAM)
  // ======================
  Stream<QuerySnapshot> getJournals() {
    if (uid == null) {
      return const Stream.empty();
    }

    return _db
        .collection('users')
        .doc(uid)
        .collection('journals')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // ======================
  // 📈 GET LAST 7 DAYS (FOR INSIGHTS)
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
}