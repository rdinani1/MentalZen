import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'mood_screen.dart';
import 'journal_screen.dart';
import 'insights_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Widget buildCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService().logout();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                ),
              );
            },
          ),
        ],
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

            buildCard(
              title: 'Mood Tracker',
              subtitle: 'Log today’s mood',
              icon: Icons.emoji_emotions,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MoodScreen(),
                  ),
                );
              },
            ),

            buildCard(
              title: 'Journal',
              subtitle: 'Write a private reflection',
              icon: Icons.edit_note,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => JournalScreen(),
                  ),
                );
              },
            ),

            buildCard(
              title: 'Insights',
              subtitle: 'View 7-day mood trends',
              icon: Icons.insights,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => InsightsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}