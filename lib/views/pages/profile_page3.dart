import 'package:flutter/material.dart';

class UserProfilePage3 extends StatelessWidget {
  const UserProfilePage3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fancy User Profile',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.indigo,
        cardColor: Colors.white,
        scaffoldBackgroundColor: Colors.indigo[50],
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.indigo,
        cardColor: Colors.grey[900],
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const UserProfilePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  final String avatarUrl = 'https://i.pravatar.cc/150?img=3';
  final String name = 'Jane Doe';
  final String email = 'jane.doe@example.com';
  final String phone = '+1 234 567 8901';
  final String extension = '1234';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(avatarUrl),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      name,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Divider(thickness: 1, color: isDark ? Colors.grey[700] : Colors.grey[300]),
                    const SizedBox(height: 16),
                    _buildInfoRow(Icons.email, 'Email', email),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.phone, 'Phone', phone),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.extension, 'Extension', extension),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Implement edit action here
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Edit button pressed')),
          );
        },
        icon: const Icon(Icons.edit),
        label: const Text('Edit'),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.indigo),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Text(value,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w500)),
          ],
        )
      ],
    );
  }
}
