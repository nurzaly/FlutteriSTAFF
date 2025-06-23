import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:istaff/data/constants.dart' as constants;
import 'package:istaff/views/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfilePage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const UserProfilePage({Key? key, required this.userData}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late String name;
  late String email;
  late String phone;
  late String extensionNumber;

  @override
  void initState() {
    super.initState();
    name = widget.userData['name'];
    email = widget.userData['email'];
    phone = widget.userData['phone'];
    extensionNumber = widget.userData['extension_number'];
  }

  void showEditProfileDialog() {
    final nameController = TextEditingController(text: name);
    final emailController = TextEditingController(text: email);
    final phoneController = TextEditingController(text: phone);
    final extController = TextEditingController(text: extensionNumber);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: extController,
                  decoration: const InputDecoration(
                    labelText: 'Extension Number',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  name = nameController.text;
                  email = emailController.text;
                  phone = phoneController.text;
                  extensionNumber = extController.text;
                });

                print('Updated Profile:');
                print({
                  'name': name,
                  'email': email,
                  'phone': phone,
                  'extension_number': extensionNumber,
                });

                // TODO: Call update profile API here

                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: currentPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Current Password',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'New Password'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newPass = newPasswordController.text;
                final confirm = confirmPasswordController.text;

                if (newPass != confirm) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Passwords do not match.')),
                  );
                  return;
                }

                print('Password changed!');
                // TODO: Call change password API here

                Navigator.pop(context);
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
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

    // selectedPageNotifier.value = 0;
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
    final user = widget.userData;
    final avatarUrl = 'https://your-api.com/storage/${user['avatar_url']}';

    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(radius: 50, backgroundImage: NetworkImage(avatarUrl)),
            const SizedBox(height: 16),
            readOnlyField('Name', name),
            readOnlyField('Email', email),
            readOnlyField('Phone', phone),
            readOnlyField('Extension Number', extensionNumber),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: showChangePasswordDialog,
              icon: const Icon(Icons.lock),
              label: const Text('Change Password'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: showEditProfileDialog,
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profile'),
            ),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: () async {
                final shouldLogout = await showDialog<bool>(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('Logout'),
                        content: const Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Logout'),
                          ),
                        ],
                      ),
                );
                if (shouldLogout == true) {
                  await handleLogout(context);
                }
              },
              icon: const Icon(Icons.edit),
              label: const Text('Logout'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget readOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextField(
        controller: TextEditingController(text: value),
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
