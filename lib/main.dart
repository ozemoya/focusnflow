import 'package:flutter/material.dart';

void main() => runApp(const FocusNFlowApp());

class FocusNFlowApp extends StatelessWidget {
  const FocusNFlowApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'FocusNFlow',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorSchemeSeed: const Color(0xff27685b),
      scaffoldBackgroundColor: const Color(0xfff8f7f3),
    ),
    home: const StudyHome(),
  );
}

const sections = <String, String>{
  'Today': 'Your next study session, pending invitations, and tasks will appear here.',
  'Rooms': 'Filter by capacity and amenities. Room freshness and unknown occupancy will stay visible.',
  'Groups':
      'Your course groups and member-only conversations will appear here.',
  'Plan': 'Add deadlines and availability, then compare a suggested sequence with deadline-first ordering.',
  'Focus': 'No shared session is active. Timer controls will require an authorized group and server acknowledgement.',
  'Profile': 'Course, availability, contact preferences, and account controls will appear here.',
};

class StudyHome extends StatefulWidget {
  const StudyHome({super.key});
  @override
  State<StudyHome> createState() => _StudyHomeState();
}

class _StudyHomeState extends State<StudyHome> {
  String selected = 'Today';
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(selected == 'Today' ? 'FocusNFlow' : selected)),
    drawer: Drawer(
      child: SafeArea(
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'FocusNFlow',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            for (final name in sections.keys)
              ListTile(
                title: Text(name),
                selected: selected == name,
                onTap: () {
                  setState(() => selected = name);
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    ),
    body: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text(
          'Design preview — cloud services are not connected',
          style: TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 24),
        Text(
          selected == 'Today' ? 'Make room for focused work.' : selected,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        Text(sections[selected]!),
        const SizedBox(height: 24),
        if (selected == 'Today') ...[
          for (final name in sections.keys.where((name) => name != 'Today'))
            Card(
              child: ListTile(
                title: Text(name),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () => setState(() => selected = name),
              ),
            ),
        ] else ...[
          const Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text('Empty state\nNo records have been created.'),
            ),
          ),
          TextButton(
            onPressed: () => setState(() => selected = 'Today'),
            child: const Text('Back to Today'),
          ),
        ],
      ],
    ),
  );
}
