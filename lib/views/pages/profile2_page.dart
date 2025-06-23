import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const UserProfilePage({Key? key, required this.userData}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  bool isEditing = false;

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController extensionController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.userData['name']);
    emailController = TextEditingController(text: widget.userData['email']);
    phoneController = TextEditingController(text: widget.userData['phone']);
    extensionController = TextEditingController(
      text: widget.userData['extension_number'],
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    extensionController.dispose();
    super.dispose();
  }

  void updateProfile() {
    final updatedData = {
      'name': nameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
      'extension_number': extensionController.text,
    };

    print('Updated user data: $updatedData');

    // You can call your API here

    setState(() {
      isEditing = false;
    });
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
                final current = currentPasswordController.text;
                final newPass = newPasswordController.text;
                final confirm = confirmPasswordController.text;

                if (newPass != confirm) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'New password and confirmation do not match.',
                      ),
                    ),
                  );
                  return;
                }

                print('Change password: $current → $newPass');
                // TODO: Call password update API here

                Navigator.pop(context);
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.userData;
    final avatarUrl = 'https://your-api.com/storage/${user['avatar_url']}';

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(radius: 50, backgroundImage: NetworkImage(avatarUrl)),
            const SizedBox(height: 16),
            buildTextField('Name', nameController),
            buildTextField('Email', emailController),
            buildTextField('Phone', phoneController),
            buildTextField('Extension Number', extensionController),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    if (isEditing) {
                      updateProfile();
                    } else {
                      setState(() => isEditing = true);
                    }
                  },
                  icon: Icon(isEditing ? Icons.save : Icons.edit),
                  label: Text(isEditing ? 'Save Profile' : 'Edit Profile'),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: showChangePasswordDialog,
                  icon: const Icon(Icons.lock),
                  label: const Text('Change Password'),
                ),
                
                
              ],
            ),

            const SizedBox(height: 16),
            
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
    String label,
    TextEditingController controller, {
    bool obscure = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        readOnly: !isEditing,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
