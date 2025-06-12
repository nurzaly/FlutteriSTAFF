import 'package:flutter/material.dart';
import 'package:istaff/data/constants.dart' as constants;
import 'package:istaff/data/notifiers.dart';
import 'package:istaff/views/pages/login_page.dart';
import 'package:istaff/views/widget_tree.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Widget? _homeWidget;

   @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(constants.Kprefs.authTokenKey);

    setState(() {
      _homeWidget = token != null ? const WidgetTree() : LoginPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(valueListenable: isDarkModeNotifier, builder: (builderContext, isDarkMode, child) {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          brightness: isDarkMode ? Brightness.dark : Brightness.light,
          primarySwatch: Colors.blue,
        ),
        home: _homeWidget ?? _buildLoadingScreen(),
        // home: const WidgetTree(),
      );
    });
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
