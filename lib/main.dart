// Student: Farah Alhasan
// Student Number: 21120205709
//
// Week 5 Homework - User Profile Card App
//  1. A "Send Message" button was added next to "Refresh User". It opens a
//     UBYS-style dialog to write an instant message or e-mail (UI only).
//  2. Extra pages were added: About, Mission & Vision and Contact.
//  3. The pages are reachable through a mobile-friendly bottom navigation bar
//     and a side menu (drawer). On wide screens a navigation rail is used.
//
// Topics from the lecture: Future, async/await, Future.delayed, setState,
// initState and conditional rendering.

import 'package:flutter/material.dart';

import 'pages/about_page.dart';
import 'pages/contact_page.dart';
import 'pages/mission_vision_page.dart';
import 'pages/profile_page.dart';
import 'widgets/message_dialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Week 5 Flutter App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainShell(),
    );
  }
}

/// One entry of the menu / navigation bar.
class NavItem {
  final String label;
  final String title;
  final IconData icon;
  final IconData selectedIcon;

  const NavItem(this.label, this.title, this.icon, this.selectedIcon);
}

const List<NavItem> navItems = [
  NavItem(
    'Profile',
    'Profile Card (Week 5)',
    Icons.person_outline,
    Icons.person,
  ),
  NavItem('About', 'About', Icons.info_outline, Icons.info),
  NavItem('Mission', 'Mission & Vision', Icons.flag_outlined, Icons.flag),
  NavItem(
    'Contact',
    'Contact',
    Icons.contact_mail_outlined,
    Icons.contact_mail,
  ),
];

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedIndex = 0;
  bool _isLoading = false;
  Map<String, String>? _userData;

  // Async data fetching simulation (Future & async/await)
  Future<void> _fetchUserData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulates a 2 second network delay
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    // Sample API data
    setState(() {
      _userData = {
        'name': 'M Sinan',
        'title': 'Flutter Software Specialist',
        'email': 'muhammet.asarslan@medenyet.edu.tr',
        'phone': '+90 216 280 00 00',
        'location': 'Istanbul, Türkiye',
        'office': 'Engineering Faculty, Room B-204',
        'officeHours': 'Mon & Wed, 13:00 - 15:00',
        'website': 'www.medeniyet.edu.tr',
        'avatar': 'https://i.pravatar.cc/300',
      };
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Fetch the data when the page opens
  }

  void _selectPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _openMessageDialog([
    MessageMode mode = MessageMode.message,
  ]) async {
    final user = _userData;
    if (user == null) return;

    final sentAs = await showMessageDialog(
      context,
      recipient: user,
      initialMode: mode,
    );
    if (sentAs == null || !mounted) return;

    final kind = sentAs == MessageMode.email ? 'E-mail' : 'Message';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$kind sent to ${user['name']}.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildPage() {
    switch (_selectedIndex) {
      case 1:
        return AboutPage(userData: _userData);
      case 2:
        return const MissionVisionPage();
      case 3:
        return ContactPage(
          userData: _userData,
          onSendMessage: _openMessageDialog,
        );
      default:
        return ProfilePage(isLoading: _isLoading, userData: _userData);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 640;
    final page = _buildPage();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(navItems[_selectedIndex].title),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: isWide ? null : _buildDrawer(),
      body: isWide
          ? Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _selectPage,
                  labelType: NavigationRailLabelType.all,
                  destinations: [
                    for (final item in navItems)
                      NavigationRailDestination(
                        icon: Icon(item.icon),
                        selectedIcon: Icon(item.selectedIcon),
                        label: Text(item.label),
                      ),
                  ],
                ),
                const VerticalDivider(width: 1),
                Expanded(child: page),
              ],
            )
          : page,
      bottomNavigationBar: isWide
          ? null
          : NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _selectPage,
              destinations: [
                for (final item in navItems)
                  NavigationDestination(
                    icon: Icon(item.icon),
                    selectedIcon: Icon(item.selectedIcon),
                    label: item.label,
                  ),
              ],
            ),
      floatingActionButton: _selectedIndex == 0 ? _buildActionButtons() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // "Refresh User" and "Send Message" buttons side by side
  Widget _buildActionButtons() {
    final colors = Theme.of(context).colorScheme;
    final canMessage = !_isLoading && _userData != null;

    // FittedBox shrinks the buttons slightly on very narrow phones
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton.extended(
              heroTag: 'refresh',
              onPressed: _isLoading ? null : _fetchUserData,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh User'),
            ),
            const SizedBox(width: 12),
            FloatingActionButton.extended(
              heroTag: 'message',
              onPressed: canMessage ? _openMessageDialog : null,
              backgroundColor: canMessage
                  ? colors.primary
                  : colors.surfaceContainerHighest,
              foregroundColor: canMessage ? colors.onPrimary : colors.outline,
              icon: const Icon(Icons.send),
              label: const Text('Send Message'),
            ),
          ],
        ),
      ),
    );
  }

  // Side menu for mobile screens
  Widget _buildDrawer() {
    final user = _userData;

    return NavigationDrawer(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) {
        _scaffoldKey.currentState?.closeDrawer();
        _selectPage(index);
      },
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 24, 16, 16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: user == null
                    ? null
                    : NetworkImage(user['avatar']!),
                onBackgroundImageError: user == null ? null : (_, _) {},
                child: user == null ? const Icon(Icons.person) : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?['name'] ?? 'Loading...',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (user != null)
                      Text(
                        user['title']!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(indent: 28, endIndent: 28),
        for (final item in navItems)
          NavigationDrawerDestination(
            icon: Icon(item.icon),
            selectedIcon: Icon(item.selectedIcon),
            label: Text(item.label),
          ),
        const Divider(indent: 28, endIndent: 28),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ListTile(
            enabled: user != null,
            leading: const Icon(Icons.send),
            title: const Text('Send Message'),
            shape: const StadiumBorder(),
            onTap: () {
              _scaffoldKey.currentState?.closeDrawer();
              _openMessageDialog();
            },
          ),
        ),
      ],
    );
  }
}
