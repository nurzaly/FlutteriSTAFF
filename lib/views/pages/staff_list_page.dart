import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:istaff/data/constants.dart' as constants;
import 'package:istaff/views/widgets/staff_list_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StaffListPage extends StatefulWidget {
  final String status;
  
  final String title;

  const StaffListPage({
    super.key,
    required this.status,
    required this.title
    });

  @override
  State<StaffListPage> createState() => _StaffListPageState();
}

class _StaffListPageState extends State<StaffListPage> {
  List<dynamic> staff = [];
  List<dynamic> filteredStaff = [];
  bool isLoadingStaff = true;
  bool errorLoadingStaff = false;

    @override
  void initState() {
    super.initState();
    fetchStaff();
  }

  

  Future<void> fetchStaff() async {
    setState(() {
      isLoadingStaff = true;
      errorLoadingStaff = false;
    });
    final prefs = await SharedPreferences.getInstance();

    try {
      final response = await http.get(
        Uri.parse('${constants.apiBaseUrl}/staff?status=${widget.status}'),
        headers: {
          'Authorization':
              'Bearer ${prefs.getString(constants.Kprefs.authTokenKey)}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          staff = data['data'];
          filteredStaff = staff; // Show all by default
        });
      } else {
        setState(() => errorLoadingStaff = true);
        print('Get staff failed with status: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => errorLoadingStaff = true);
      print('Get Staff error: $e');
    } finally {
      setState(() => isLoadingStaff = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('STAFF ${widget.title}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchStaff,
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          key: const ValueKey("staffContent"),
          children: [
            Expanded(
              child: isLoadingStaff
                  ? const Center(child: CircularProgressIndicator())
                  :StaffListWidget(
                staff: staff,
                filteredStaff: filteredStaff,
                clearFilter: (){},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
