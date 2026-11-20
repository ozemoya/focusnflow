import 'package:flutter/material.dart';

import 'ui/study_art.dart';

void main() => runApp(const FocusNFlowApp());
const cream = Color(0xfffffdf6),
    brown = Color(0xff825345),
    forest = Color(0xff285742),
    tan = Color(0xffd8ae76),
    muted = Color(0xff837c72);
const sections = <String, String>{
  'Today': 'A little space to focus.',
  'Rooms': 'Find your kind of quiet.',
  'Groups': 'Good company. Better focus.',
  'Plan': 'Make a little room.',
  'Focus': 'One thing at a time.',
  'Profile': 'Your study rhythm.',
};

class FocusNFlowApp extends StatelessWidget {
  const FocusNFlowApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'FocusNFlow',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: cream,
      colorScheme: ColorScheme.fromSeed(seedColor: forest, surface: cream),
      dividerColor: const Color(0xffe8e4da),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Color(0xff302d29),
          height: 1.45,
        ),
        titleLarge: TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.w800,
          letterSpacing: -.8,
        ),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),
    home: const StudyHome(),
  );
}

class StudyHome extends StatefulWidget {
  const StudyHome({super.key});
  @override
  State<StudyHome> createState() => _StudyHomeState();
}

class _StudyHomeState extends State<StudyHome> {
  String selected = 'Today', roomFilter = 'All', duration = '25 min';
  bool bookmarked = false, reminders = false;
  double textSize = 16;
  final tabs = ['Today', 'Rooms', 'Groups', 'Profile'];
  void go(String page) => setState(() => selected = page);
  TextStyle get heading => const TextStyle(
    fontSize: 23,
    fontWeight: FontWeight.w800,
    letterSpacing: -.8,
    height: 1.1,
  );
  Widget label(String title, {VoidCallback? action}) => Padding(
    padding: const EdgeInsets.only(top: 25, bottom: 13),
    child: Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 17,
              letterSpacing: -.4,
            ),
          ),
        ),
        if (action != null)
          TextButton(
            onPressed: action,
            child: const Text(
              'See all',
              style: TextStyle(color: muted, fontSize: 12),
            ),
          ),
      ],
    ),
  );
  Widget chip(String text, bool active, VoidCallback action) => Padding(
    padding: const EdgeInsets.only(right: 8),
    child: ChoiceChip(
      label: Text(text),
      selected: active,
      onSelected: (_) => action(),
      showCheckmark: false,
      side: BorderSide.none,
      selectedColor: forest,
      backgroundColor: const Color(0xffefeee8),
      labelStyle: TextStyle(fontSize: 12, color: active ? Colors.white : muted),
      shape: const StadiumBorder(),
    ),
  );
  Widget chips(
    List<String> values,
    String value,
    ValueChanged<String> action,
  ) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: values
          .map((s) => chip(s, s == value, () => action(s)))
          .toList(),
    ),
  );
  Widget artCard({
    required String title,
    required String subtitle,
    required int scene,
    required VoidCallback onTap,
  }) => Expanded(
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: StudyArt(scene: scene),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
          ),
          Text(subtitle, style: const TextStyle(color: muted, fontSize: 11)),
        ],
      ),
    ),
  );
  Widget circlePerson(String initials, Color background) => CircleAvatar(
    radius: 24,
    backgroundColor: background,
    child: Text(
      initials,
      style: const TextStyle(
        color: forest,
        fontWeight: FontWeight.w800,
        fontSize: 15,
      ),
    ),
  );
  Widget note(String text) => Padding(
    padding: const EdgeInsets.only(top: 12),
    child: Text(
      text,
      style: const TextStyle(fontSize: 11, color: muted, height: 1.4),
    ),
  );
  void previewMessage(String title, String message) =>
      showModalBottomSheet<void>(
        context: context,
        backgroundColor: cream,
        showDragHandle: true,
        builder: (context) => Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 35),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: heading),
              const SizedBox(height: 16),
              Text(message),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Got it'),
              ),
            ],
          ),
        ),
      );

  List<Widget> today() => [
    Text('A little space\nto focus.', style: heading.copyWith(fontSize: 31)),
    const SizedBox(height: 18),
    SizedBox(
      height: 202,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: const StudyArt(),
            ),
          ),
          Positioned(
            left: 13,
            top: 13,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: cream,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'A fresh start',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          Positioned(
            right: 13,
            bottom: 13,
            child: IconButton.filled(
              style: IconButton.styleFrom(backgroundColor: forest),
              onPressed: () => go('Focus'),
              tooltip: 'Open focus timer',
              icon: const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ),
    label('Find your next spot', action: () => go('Rooms')),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        artCard(
          title: 'A window & a notebook',
          subtitle: 'Explore quiet rooms',
          scene: 1,
          onTap: () => go('Rooms'),
        ),
        const SizedBox(width: 14),
        artCard(
          title: 'Room for your people',
          subtitle: 'Find a course group',
          scene: 2,
          onTap: () => go('Groups'),
        ),
      ],
    ),
    label('Your study toolkit'),
    _SoftRow(
      icon: Icons.auto_awesome_outlined,
      title: 'Make a study plan',
      subtitle: 'Deadlines, with a little breathing room',
      onTap: () => go('Plan'),
    ),
    _SoftRow(
      icon: Icons.timer_outlined,
      title: 'Settle into a focus session',
      subtitle: 'Choose your pace',
      onTap: () => go('Focus'),
    ),
  ];
  List<Widget> rooms() => [
    Text(sections['Rooms']!, style: heading.copyWith(fontSize: 29)),
    const SizedBox(height: 18),
    TextField(
      decoration: InputDecoration(
        hintText: 'Search rooms',
        prefixIcon: const Icon(Icons.search, size: 19),
        filled: true,
        fillColor: const Color(0xffeeeee6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: (_) {},
      readOnly: true,
      onTap: () => previewMessage(
        'Room search',
        'Search will use the room catalog after Firebase is connected.',
      ),
    ),
    const SizedBox(height: 14),
    chips(
      ['All', 'Quiet', 'Whiteboard'],
      roomFilter,
      (v) => setState(() => roomFilter = v),
    ),
    label('A place to settle in'),
    ClipRRect(
      borderRadius: BorderRadius.circular(23),
      child: const SizedBox(height: 205, child: StudyArt(scene: 1)),
    ),
    const SizedBox(height: 15),
    Text(
      roomFilter == 'Whiteboard' ? 'The idea room' : 'The reading nook',
      style: heading,
    ),
    const SizedBox(height: 6),
    Text(
      roomFilter == 'Whiteboard'
          ? '8 seats · Whiteboard · Group study'
          : '4 seats · Quiet · Natural light',
      style: const TextStyle(color: muted, fontSize: 12),
    ),
    const SizedBox(height: 16),
    const _StatusTag(text: 'Occupancy unknown', color: Color(0xffefe4cb)),
    note('Illustrative room only. No occupancy report has been received.'),
    label('Before you head over'),
    const _SoftRow(
      icon: Icons.update_rounded,
      title: 'Freshness matters',
      subtitle: 'Old or missing reports will stay clearly labeled.',
    ),
    OutlinedButton.icon(
      onPressed: () => previewMessage(
        'No live report yet',
        'The room catalog and occupancy feed are not connected. This preview cannot confirm availability.',
      ),
      icon: const Icon(Icons.refresh_rounded),
      label: const Text('Check room status'),
    ),
  ];
  List<Widget> groups() => [
    Text(sections['Groups']!, style: heading.copyWith(fontSize: 29)),
    const SizedBox(height: 20),
    ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: const SizedBox(height: 210, child: StudyArt(scene: 2)),
    ),
    label('Find your study circle'),
    const Text(
      'A shared table makes a good starting point.',
      style: TextStyle(color: muted),
    ),
    const SizedBox(height: 17),
    _SoftRow(
      icon: Icons.menu_book_rounded,
      title: 'Course study group',
      subtitle: 'Example group · membership not connected',
      onTap: () => previewMessage(
        'Your group, together',
        'Group creation, membership, and private chat will be connected in a later increment. No group has been joined.',
      ),
    ),
    const SizedBox(height: 10),
    FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: forest,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      onPressed: () => previewMessage(
        'Start a group',
        'Account access and membership rules come first. Group creation is not connected in this design preview.',
      ),
      child: const Text('Create a study group'),
    ),
    label('Built for a shared rhythm'),
    _SoftRow(
      icon: Icons.calendar_today_outlined,
      title: 'Find a time that fits',
      subtitle: 'Plan around shared availability',
      onTap: () => go('Plan'),
    ),
    _SoftRow(
      icon: Icons.timelapse_rounded,
      title: 'Focus together',
      subtitle: 'One session. A shared clock.',
      onTap: () => go('Focus'),
    ),
  ];
  List<Widget> plan() => [
    Text(sections['Plan']!, style: heading.copyWith(fontSize: 29)),
    const SizedBox(height: 12),
    const Text(
      'Start with what needs doing. Leave space for the rest.',
      style: TextStyle(color: muted),
    ),
    label('Your tasks'),
    Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xffecefdb),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.edit_note_rounded, size: 35, color: forest),
          const SizedBox(height: 14),
          Text('A clean page.', style: heading),
          const SizedBox(height: 8),
          const Text(
            'No tasks yet. Add deadlines and available time when your account is connected.',
            style: TextStyle(color: muted),
          ),
          const SizedBox(height: 18),
          OutlinedButton(
            onPressed: () => previewMessage(
              'Add a task',
              'Task entry and persistence are planned for the scheduling increment. This screen has not generated a study plan.',
            ),
            child: const Text('Add your first task'),
          ),
        ],
      ),
    ),
    label('How your plan will work'),
    const _SoftRow(
      icon: Icons.calendar_month_outlined,
      title: 'Work with your availability',
      subtitle: 'Keep existing commitments clear.',
    ),
    const _SoftRow(
      icon: Icons.compare_arrows_rounded,
      title: 'Compare two approaches',
      subtitle: 'Suggested sequence and deadline-first.',
    ),
    const _SoftRow(
      icon: Icons.lightbulb_outline_rounded,
      title: 'Know what did not fit',
      subtitle: 'Uncovered work stays visible.',
    ),
    note(
      'No scheduling results or evaluation metrics are shown before the helper is implemented and tested.',
    ),
  ];
  List<Widget> focus() => [
    Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: brown,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'A CHAPTER OF FOCUS',
            style: TextStyle(
              fontSize: 10,
              letterSpacing: 1.5,
              color: Color(0xffead8c1),
            ),
          ),
          const SizedBox(height: 17),
          Text(
            'One thing\nat a time.',
            style: heading.copyWith(color: cream, fontSize: 30),
          ),
          const SizedBox(height: 30),
          Center(
            child: Text(
              duration == '45 min'
                  ? '45:00'
                  : duration == '60 min'
                  ? '60:00'
                  : '25:00',
              style: const TextStyle(
                fontSize: 62,
                fontWeight: FontWeight.w500,
                color: cream,
                letterSpacing: -2,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              'No shared session active',
              style: TextStyle(fontSize: 12, color: Color(0xffead8c1)),
            ),
          ),
          const SizedBox(height: 25),
          const Text(
            'Take a breath. Choose your pace. Your group’s shared clock will begin only after the server confirms it.',
            style: TextStyle(color: Color(0xfff1e1cd), height: 1.6),
          ),
          const SizedBox(height: 20),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: cream,
              foregroundColor: brown,
              minimumSize: const Size(double.infinity, 48),
            ),
            onPressed: () => previewMessage(
              'Not connected yet',
              'Shared timer controls need an authenticated group and server state. Choosing a duration only changes this preview; it does not start a real session.',
            ),
            child: const Text('Start a focus session'),
          ),
        ],
      ),
    ),
    label('Find your pace'),
    chips(
      ['25 min', '45 min', '60 min'],
      duration,
      (v) => setState(() => duration = v),
    ),
    label('A little reading comfort'),
    Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xffefece2),
        borderRadius: BorderRadius.circular(23),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.text_fields_rounded, size: 20),
              Expanded(
                child: Slider(
                  value: textSize,
                  min: 14,
                  max: 22,
                  divisions: 4,
                  label: textSize.toInt().toString(),
                  onChanged: (v) => setState(() => textSize = v),
                ),
              ),
            ],
          ),
          Text(
            'Give one small task your full attention.',
            style: TextStyle(fontSize: textSize, color: brown, height: 1.5),
          ),
        ],
      ),
    ),
  ];
  List<Widget> profile() => [
    Row(
      children: [
        circlePerson('YOU', const Color(0xfff0cd83)),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your corner.', style: heading.copyWith(fontSize: 29)),
              const Text(
                'Not signed in',
                style: TextStyle(color: muted, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    ),
    label('Make yourself at home'),
    _SoftRow(
      icon: Icons.person_outline_rounded,
      title: 'Account & courses',
      subtitle: 'Keep your study world together.',
      onTap: () => previewMessage(
        'Account setup',
        'Email/password, Google sign-in, and password reset will be added in the authentication increment.',
      ),
    ),
    _SoftRow(
      icon: Icons.schedule_rounded,
      title: 'Your availability',
      subtitle: 'Share only the free time you choose.',
      onTap: () => go('Plan'),
    ),
    SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text(
        'Reminder preview',
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      ),
      subtitle: const Text(
        'Local preference only. No alerts are sent.',
        style: TextStyle(fontSize: 11, color: muted),
      ),
      value: reminders,
      onChanged: (v) => setState(() => reminders = v),
      activeThumbColor: forest,
    ),
    _SoftRow(
      icon: Icons.bookmark_border_rounded,
      title: 'Saved places',
      subtitle: bookmarked
          ? 'One preview bookmark'
          : 'A spot worth coming back to.',
      onTap: () => setState(() => bookmarked = !bookmarked),
    ),
    label('A slower kind of progress'),
    ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: const SizedBox(height: 190, child: StudyArt()),
    ),
    note(
      'This is a design preview. Account preferences and bookmarks are not stored remotely.',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    final pages = {
      'Today': today,
      'Rooms': rooms,
      'Groups': groups,
      'Plan': plan,
      'Focus': focus,
      'Profile': profile,
    };
    return ColoredBox(
      color: tan,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Scaffold(
            body: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 14, 20, 10),
                    child: Row(
                      children: [
                        if (!tabs.contains(selected))
                          IconButton(
                            onPressed: () => go('Today'),
                            tooltip: 'Back to Today',
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 18,
                            ),
                          ),
                        Expanded(
                          child: Text(
                            selected == 'Today' ? 'FocusNFlow' : selected,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1,
                            ),
                          ),
                        ),
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xff5b9b73),
                            borderRadius: BorderRadius.circular(17),
                          ),
                          child: PopupMenuButton<String>(
                            key: const Key('all-screens'),
                            tooltip: 'All screens',
                            icon: const Icon(
                              Icons.tune_rounded,
                              color: Colors.white,
                              size: 21,
                            ),
                            onSelected: go,
                            itemBuilder: (context) => sections.keys
                                .map(
                                  (name) => PopupMenuItem(
                                    value: name,
                                    key: ValueKey('nav-$name'),
                                    child: Text(name),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'DESIGN PREVIEW · NOT CONNECTED',
                        style: TextStyle(
                          fontSize: 9,
                          letterSpacing: 1.2,
                          color: muted,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      key: ValueKey(selected),
                      padding: const EdgeInsets.fromLTRB(24, 21, 24, 28),
                      children: pages[selected]!(),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 10,
                ),
                decoration: const BoxDecoration(
                  color: cream,
                  border: Border(top: BorderSide(color: Color(0xffece9e0))),
                ),
                child: Row(
                  children: [
                    for (var i = 0; i < tabs.length; i++)
                      Expanded(
                        child: InkWell(
                          key: ValueKey('tab-${tabs[i]}'),
                          onTap: () => go(tabs[i]),
                          borderRadius: BorderRadius.circular(18),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 9),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  [
                                    Icons.home_rounded,
                                    Icons.search_rounded,
                                    Icons.bookmark_border_rounded,
                                    Icons.person_outline_rounded,
                                  ][i],
                                  size: 21,
                                  color: selected == tabs[i] ? forest : muted,
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  tabs[i],
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: selected == tabs[i]
                                        ? FontWeight.w800
                                        : FontWeight.w400,
                                    color: selected == tabs[i] ? forest : muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SoftRow extends StatelessWidget {
  const _SoftRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });
  final IconData icon;
  final String title, subtitle;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    minLeadingWidth: 24,
    leading: Icon(icon, size: 23, color: forest),
    title: Text(
      title,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
    ),
    subtitle: Text(
      subtitle,
      style: const TextStyle(fontSize: 11, color: muted, height: 1.5),
    ),
    trailing: onTap != null
        ? const Icon(Icons.chevron_right_rounded, size: 18, color: muted)
        : null,
    onTap: onTap,
  );
}

class _StatusTag extends StatelessWidget {
  const _StatusTag({required this.text, required this.color});
  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: brown,
        ),
      ),
    ),
  );
}
