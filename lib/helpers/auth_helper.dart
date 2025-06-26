
import 'package:flutter/material.dart';
import 'package:istaff/data/constants.dart' as constants;
import 'package:istaff/views/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthHelper {
  static Future<void> handleUnauthorizedAccess(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(constants.Kprefs.authTokenKey);
    await prefs.remove(constants.Kprefs.userNameKey);
    await prefs.remove(constants.Kprefs.userEmailKey);
    await prefs.remove(constants.Kprefs.userAvatarUrlKey);
    print('Unauthorized access detected.');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
      (route) => false,
    );
  }
}