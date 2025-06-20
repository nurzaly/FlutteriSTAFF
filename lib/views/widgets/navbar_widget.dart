import 'package:flutter/material.dart';
import 'package:istaff/data/notifiers.dart';

class NavBarWidget extends StatelessWidget {
  const NavBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, child) {
      return NavigationBar(
        destinations: [
          NavigationDestination(icon: Icon(Icons.home), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.business), label: 'Staff'),
          NavigationDestination(icon: Icon(Icons.flag), label: 'Status'),
          NavigationDestination(icon: Icon(Icons.watch), label: 'Attendance'),
          NavigationDestination(icon: Icon(Icons.people), label: 'Profile'),
        ],
        onDestinationSelected: (int value) {
          selectedPageNotifier.value = value;
        },
        selectedIndex: selectedPage,
      );
    });
  }
}
