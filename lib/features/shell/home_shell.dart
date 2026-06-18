import 'package:flutter/material.dart';
import '../../theme/hearth_theme.dart';
import '../discover/discover_screen.dart';
import '../search/search_screen.dart';
import '../bookings/bookings_screen.dart';
import '../messages/messages_list_screen.dart';
import '../profile/profile_screen.dart';

class HomeShell extends StatefulWidget {
  final int initialTab;
  const HomeShell({super.key, this.initialTab = 0});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  late int index = widget.initialTab;

  static const _tabs = [
    DiscoverScreen(),
    SearchScreen(),
    BookingsScreen(),
    MessagesListScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: index, children: _tabs),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: HC.card,
          border: Border(top: BorderSide(color: HC.hairline)),
        ),
        child: SafeArea(
          top: false,
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              backgroundColor: HC.card,
              indicatorColor: HC.terracotta.withValues(alpha: 0.12),
              labelTextStyle: WidgetStateProperty.resolveWith((s) => HearthTheme.body(
                  11.5,
                  w: FontWeight.w600,
                  color: s.contains(WidgetState.selected) ? HC.terracotta : HC.muted)),
            ),
            child: NavigationBar(
              height: 64,
              selectedIndex: index,
              onDestinationSelected: (i) => setState(() => index = i),
              destinations: const [
                NavigationDestination(
                    icon: Icon(Icons.explore_outlined, color: HC.muted),
                    selectedIcon: Icon(Icons.explore, color: HC.terracotta),
                    label: 'Discover'),
                NavigationDestination(
                    icon: Icon(Icons.search, color: HC.muted),
                    selectedIcon: Icon(Icons.search, color: HC.terracotta),
                    label: 'Search'),
                NavigationDestination(
                    icon: Icon(Icons.event_note_outlined, color: HC.muted),
                    selectedIcon: Icon(Icons.event_note, color: HC.terracotta),
                    label: 'Bookings'),
                NavigationDestination(
                    icon: Icon(Icons.chat_bubble_outline, color: HC.muted),
                    selectedIcon: Icon(Icons.chat_bubble, color: HC.terracotta),
                    label: 'Messages'),
                NavigationDestination(
                    icon: Icon(Icons.person_outline, color: HC.muted),
                    selectedIcon: Icon(Icons.person, color: HC.terracotta),
                    label: 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
