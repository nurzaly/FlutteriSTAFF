import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:istaff/data/constants.dart' as constants;
import 'package:istaff/data/notifiers.dart';
import 'package:istaff/views/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = '';
  String userEmail = '';
  String userRole = '';
  String userAvatarUrl = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProfileData();
  }

  Future<void> loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      userName = prefs.getString(constants.Kprefs.userNameKey) ?? 'Unknown';
      userEmail = prefs.getString(constants.Kprefs.userEmailKey) ?? 'Unknown';
      userRole = prefs.getString('user_role') ?? 'Staff';
      userAvatarUrl =
          prefs.getString(constants.Kprefs.userAvatarUrlKey) ?? 'avatar.png';
      isLoading = false;
    });
  }

  Future<void> handleLogout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    // Optional: Call your backend logout endpoint here
    try {
      final response = await http.post(
        Uri.parse(constants.apiBaseUrl + '/logout'),
        headers: {
          'Authorization':
              'Bearer ${prefs.getString(constants.Kprefs.authTokenKey)}',
        },
      );

      if (response.statusCode == 200) {
        print('Logout successful');
      } else {
        print('Logout failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Logout error: $e');
    }

    selectedPageNotifier.value = 0;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
      (route) => false,
    );

    await prefs.remove(constants.Kprefs.authTokenKey);
    await prefs.remove(constants.Kprefs.userNameKey);
    await prefs.remove(constants.Kprefs.userEmailKey);
    await prefs.remove(constants.Kprefs.userAvatarUrlKey);
    // Optionally remove saved credentials
    // await prefs.remove('saved_email');
    // await prefs.remove('saved_password');

    // Navigate back to login
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Text('Profile Page'),
            SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                constants.avatarPath + userAvatarUrl,
              ),
            ),
            SizedBox(height: 20),
            Text(userName),
            SizedBox(height: 10),
            Text('Email: $userEmail'),
            SizedBox(height: 10),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () async {
                final shouldLogout = await showDialog<bool>(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: Text('Logout'),
                        content: Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: Text('Logout'),
                          ),
                        ],
                      ),
                );

                if (shouldLogout == true) {
                  await handleLogout(context);
                }
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
