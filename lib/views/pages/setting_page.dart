import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  TextEditingController controller = TextEditingController();
  bool isChecked = false;
  bool isSwitched = false;
  String? menuItem;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Text Field'),
            subtitle: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Enter text',
              ),
            ),
          ),
          ListTile(
            title: const Text('Checkbox'),
            trailing: Checkbox(
              value: isChecked,
              onChanged: (value) {
                setState(() {
                  isChecked = value!;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Switch'),
            trailing: Switch(
              value: isSwitched,
              onChanged: (value) {
                setState(() {
                  isSwitched = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Dropdown Menu'),
            trailing: DropdownButton<String>(
              value: menuItem,
              items: <String>['Item 1', 'Item 2', 'Item 3']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  menuItem = newValue;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
