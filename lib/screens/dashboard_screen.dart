import 'package:flutter/material.dart';
import 'mood_screen.dart';
import 'journal_screen.dart';
import 'insights_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Widget _card({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.teal),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        title: const Text('Mental Zen'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome back 🌿',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('How are you feeling today?'),
            const SizedBox(height: 24),
            _card(
              title: 'Mood Tracker',
              subtitle: 'Log today’s mood',
              icon: Icons.emoji_emotions,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MoodScreen()),
                );
              },
            ),
            _card(
              title: 'Journal',
              subtitle: 'Write a private reflection',
              icon: Icons.edit_note,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const JournalScreen()),
                );
              },
            ),
            _card(
              title: 'Insights',
              subtitle: 'View 7-day mood trends',
              icon: Icons.insights,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const InsightsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}