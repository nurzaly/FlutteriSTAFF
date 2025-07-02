import 'package:flutter/material.dart';
import 'package:istaff/data/notifiers.dart';
import 'package:istaff/views/pages/attendance_page.dart';
import 'package:istaff/views/pages/home_page.dart';
import 'package:istaff/views/pages/profile2_page.dart';
import 'package:istaff/views/pages/profile_page3.dart';
import 'package:istaff/views/pages/setting_page.dart';
import 'package:istaff/views/pages/staff_page.dart';
import 'package:istaff/views/status/status_page.dart';
import 'package:istaff/views/widgets/navbar_widget.dart';
import 'package:istaff/views/pages/profile_page.dart';

List<Widget> pages = [HomePage(), StaffPage(), StatusPage(), AttendancePage(), UserProfilePage3()];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("iSTAFF"),
        actions: [
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: isDarkModeNotifier,
              builder: (builderContext, isDarkMode, child) {
                return Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode);
              },
            ),
            onPressed: () {
              isDarkModeNotifier.value = !isDarkModeNotifier.value;
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context){
                  return SettingPage();
                }),
              );
            },
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: selectedPageNotifier,
        builder: (context, selectedPage, child) {
          return pages.elementAt(selectedPage);
        },
      ),
      bottomNavigationBar: NavBarWidget(),
    );
  }
}
