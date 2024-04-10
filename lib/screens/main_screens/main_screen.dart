import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_project/screens/main_screens/add_book_screen.dart';
import 'package:graduation_project/screens/main_screens/user_chats_screen.dart';

import 'home_screen.dart';
import 'notifications_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;
  final List<Widget> _screens = [
    const HomeScreen(),
    const Text('Community Screen'),
    const AddBookScreen(),
    const UserChatsScreen(),
    const NotificationsScreens(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        // labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        height: 90,
        // surfaceTintColor: Colors.transparent,
        onDestinationSelected: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },
        // indicatorColor: iconRed,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        destinations: const [
          NavigationDestination(
            icon: FaIcon(
              FontAwesomeIcons.house,
              size: 20,
            ),
            selectedIcon: FaIcon(FontAwesomeIcons.house, size: 20),
            label: 'Home',
          ),
          NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.userGroup, size: 20),
            selectedIcon: FaIcon(FontAwesomeIcons.userGroup, size: 20),
            label: 'Community',
          ),
          NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.plus, size: 20),
            selectedIcon: FaIcon(FontAwesomeIcons.plus, size: 20),
            label: 'Add book',
          ),
          NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.solidMessage, size: 20),
            selectedIcon: FaIcon(FontAwesomeIcons.solidMessage, size: 20),
            label: 'Chats',
          ),
          NavigationDestination(
            icon: FaIcon(
              FontAwesomeIcons.solidBell,
              size: 20,
            ),
            selectedIcon: FaIcon(FontAwesomeIcons.solidBell, size: 20),
            label: 'Notifications',
          ),
        ],
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: _screens,
      ),
    );
  }
}
