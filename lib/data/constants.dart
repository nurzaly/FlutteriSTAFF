import 'package:flutter/material.dart';

const String appName = 'Flutter App';
const String appVersion = '1.0.0';
const String apiBaseUrl = 'https://istaff.agsdk.my/api';
const String baseUrl = 'https://istaff.agsdk.my';
// const String apiBaseUrl = 'http://10.0.2.2:8000/api';
// const String baseUrl = 'http://10.0.2.2:8000';
// const String apiBaseUrl = 'http://127.0.0.1:8000/api';
const String loginEndpoint = '/login';
const String avatarPath = '$baseUrl/avatars/';
const String privacyPolicyUrl = 'https://example.com/privacy-policy';
const String termsOfServiceUrl = 'https://example.com/terms-of-service';

const Color primaryColor = Color(0xFF6200EE);
const Color secondaryColor = Color(0xFF03DAC6);
const Color backgroundColor = Color(0xFFF5F5F5);
const Color errorColor = Color(0xFFB00020);
const Color textColor = Color(0xFF212121);
const Color buttonColor = Color(0xFF6200EE);
const double defaultPadding = 16.0;
const double defaultMargin = 16.0;
const double borderRadius = 8.0;
const double iconSize = 24.0; 
const double fontSizeSmall = 12.0;
const double fontSizeMedium = 16.0; 
const double fontSizeLarge = 20.0;
const String defaultFontFamily = 'Roboto';

class StatusColorHelper {
  static const Map<String, Color> statusColors = {
    'CUTI': Colors.cyan,
    'SAKIT': Colors.purple,
    'RASMI': Colors.orange,
    'KURSUS': Colors.yellow,
    '4JAM': Colors.deepPurple,
  };

  /// Returns the Color for a given status key
  static Color getColor(String key) {
    return statusColors[key] ?? Colors.grey; // fallback color
  }
}

class Kprefs {
  static const String isDarkModeKey = 'isDarkMode';
  static const String authTokenKey = 'auth_token';
  static const String savedEmailKey = 'saved_email';  
  static const String savedPasswordKey = 'saved_password';
  static const String selectedPageKey = 'selected_page';
  static const String isLoggedInKey = 'is_logged_in';
  static const String userProfileKey = 'user_profile';  
  static const String userNameKey = 'user_name';
  static const String userEmailKey = 'user_email';
  static const String userRoleKey = 'user_role';
  static const String userAvatarUrlKey = 'user_avatar_url';
 
}



class KTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: fontSizeLarge,
    fontWeight: FontWeight.bold,
    color: textColor,
    fontFamily: defaultFontFamily,
  );

  static const TextStyle subheading = TextStyle(
    fontSize: fontSizeMedium,
    fontWeight: FontWeight.w600,
    color: textColor,
    fontFamily: defaultFontFamily,
  );

  static const TextStyle body = TextStyle(
    fontSize: fontSizeSmall,
    color: textColor,
    fontFamily: defaultFontFamily,
  );

  static const TextStyle button = TextStyle(
    fontSize: fontSizeMedium,
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontFamily: defaultFontFamily,
  );
}