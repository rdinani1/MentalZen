import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  final firestore = FirestoreService();

  int moodScore(String mood) {
    switch (mood.toLowerCase()) {
      case 'happy':
        return 5;
      case 'calm':
        return 4;
      case 'stressed':
        return 2;
      case 'sad':
        return 1;
      case 'anxious':
        return 2;
      default:
        return 3;
    }
  }

  String getTrend(List<Map<String, dynamic>> moods) {
    if (moods.length < 2) {
      return 'Not enough data yet';
    }

    final first = moodScore(moods.first['mood']);
    final last = moodScore(moods.last['mood']);

    if (last > first) {
      return 'Improving';
    } else if (last < first) {
      return 'Declining';
    } else {
      return 'Stable';
    }
  }

  String getSuggestion(String trend) {
    if (trend == 'Improving') {
      return 'Great progress. Keep journaling and continue the habits that helped you feel better.';
    } else if (trend == 'Declining') {
      return 'Your recent mood trend looks lower. Try a breathing exercise, short walk, or writing about what triggered the change.';
    } else if (trend == 'Stable') {
      return 'Your mood has been steady. Keep checking in daily to build stronger self-awareness.';
    } else {
      return 'Log at least two mood entries to generate a 7-day insight.';
    }
  }

  Map<String, int> countMoods(List<Map<String, dynamic>> moods) {
    final counts = <String, int>{};

    for (final mood in moods) {
      final label = mood['mood'] ?? 'Unknown';
      counts[label] = (counts[label] ?? 0) + 1;
    }

    return counts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(title: const Text('Insights')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: firestore.getLast7DayMoods(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final moods = snapshot.data!;
          final trend = getTrend(moods);
          final suggestion = getSuggestion(trend);
          final moodCounts = countMoods(moods);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Icon(Icons.insights, size: 48, color: Colors.teal),
                        const SizedBox(height: 12),
                        const Text(
                          '7-Day Mood Trend',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          trend,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          suggestion,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Mood Frequency',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        if (moodCounts.isEmpty)
                          const Text('No mood entries from the last 7 days.'),

                        ...moodCounts.entries.map((entry) {
                          return ListTile(
                            leading: const Icon(Icons.circle, color: Colors.teal),
                            title: Text(entry.key),
                            trailing: Text('${entry.value}'),
                          );
                        }),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'Entries analyzed: ${moods.length}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}