import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final TextEditingController controller = TextEditingController();
  final FirestoreService firestore = FirestoreService();

  File? selectedImage;
  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Journal')),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            const Text(
              'What’s on your mind?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            // 📝 TEXT INPUT
            TextField(
              controller: controller,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Write your thoughts...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 📸 PICK IMAGE
            ElevatedButton(
              onPressed: () async {
                final picked =
                    await picker.pickImage(source: ImageSource.gallery);

                if (picked != null) {
                  setState(() {
                    selectedImage = File(picked.path);
                  });
                }
              },
              child: const Text('Pick Image'),
            ),

            const SizedBox(height: 10),

            // 🖼️ PREVIEW IMAGE
            if (selectedImage != null)
              Image.file(
                selectedImage!,
                height: 120,
              ),

            const SizedBox(height: 10),

            // 💾 SAVE BUTTON
            FilledButton(
              onPressed: () async {
                String? imageUrl;

                if (selectedImage != null) {
                  imageUrl = await firestore.uploadImage(selectedImage!);
                }

                await firestore.saveJournalWithImage(
                  controller.text.trim(),
                  imageUrl,
                );

                controller.clear();

                setState(() {
                  selectedImage = null;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Journal saved')),
                );
              },
              child: const Text('Save Journal'),
            ),

            const SizedBox(height: 20),
            const Divider(),

            const Text(
              'Journal History',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // 🔥 FIRESTORE STREAM LIST
            Expanded(
              child: StreamBuilder(
                stream: firestore.getJournals(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data!.docs;

                  if (docs.isEmpty) {
                    return const Center(child: Text("No entries yet"));
                  }

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text(data['text'] ?? ''),
                            ),

                            // 🖼️ SHOW IMAGE IF EXISTS
                            if (data['imageUrl'] != null)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.network(
                                  data['imageUrl'],
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                              ),
                          ],
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