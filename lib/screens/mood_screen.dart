import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key});

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  String selectedMood = 'Calm';
  final noteController = TextEditingController();
  final firestore = FirestoreService();

  final moods = ['Happy', 'Calm', 'Stressed', 'Sad', 'Anxious'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mood Tracker')),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            const Text(
              'Select your mood',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // 🔹 Mood chips
            Wrap(
              spacing: 10,
              children: moods.map((mood) {
                return ChoiceChip(
                  label: Text(mood),
                  selected: selectedMood == mood,
                  onSelected: (_) {
                    setState(() {
                      selectedMood = mood;
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // 🔹 Note field
            TextField(
              controller: noteController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Optional note',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Save button
            FilledButton(
              onPressed: () async {
                await firestore.saveMood(
                  selectedMood,
                  noteController.text.trim(),
                );

                noteController.clear();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mood saved')),
                );
              },
              child: const Text('Save Mood'),
            ),

            const SizedBox(height: 20),

            const Divider(),

            const SizedBox(height: 10),

            const Text(
              'Recent Moods',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // 🔥 FIRESTORE LIST
            Expanded(
              child: StreamBuilder(
                stream: firestore.getMoods(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data!.docs;

                  if (docs.isEmpty) {
                    return const Center(child: Text("No moods yet"));
                  }

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index];

                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.emoji_emotions),
                          title: Text(data['mood']),
                          subtitle: Text(data['note'] ?? ''),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}