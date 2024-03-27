import 'package:flutter/material.dart';
import 'package:graduation_project/screens/add_book_screen.dart';
import 'package:graduation_project/screens/user_chats_screen.dart';

import '../constants/colors.dart';
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
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        height: 70,
        surfaceTintColor: Colors.transparent,
        onDestinationSelected: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },
        indicatorColor: iconRed,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        destinations: const [
          NavigationDestination(
            icon: Icon(
              Icons.home_rounded,
            ),
            selectedIcon: Icon(
              Icons.home_rounded,
              color: Colors.white,
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.groups_3_rounded),
            selectedIcon: Icon(
              Icons.groups_3_rounded,
              color: Colors.white,
            ),
            label: 'Community',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_rounded),
            selectedIcon: Icon(
              Icons.add_rounded,
              color: Colors.white,
            ),
            label: 'Add book',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_rounded),
            selectedIcon: Icon(
              Icons.chat_rounded,
              color: Colors.white,
            ),
            label: 'Chats',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_rounded),
            selectedIcon: Icon(
              Icons.notifications_rounded,
              color: Colors.white,
            ),
            label: 'Profile',
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
