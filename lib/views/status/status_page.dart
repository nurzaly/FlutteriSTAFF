import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:istaff/data/constants.dart' as constants;
import 'package:istaff/utils/status_utils.dart';
import 'package:istaff/views/widgets/shimmer_widget.dart';
import 'package:istaff/views/status/status_fab.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({super.key});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  bool isLoadingStatus = true;
  bool isLoadingUserStatus = true;
  bool errorLoadingStatus = false;
  bool errorLoadingUserStatus = false;

  List<dynamic> userStatuses = [];
  List<dynamic> statuses = [];

  String? selecteYear = DateTime.now().year.toString();
  DateTime? singleDate;
  DateTimeRange? dateRange;

  @override
  void initState() {
    super.initState();
    fetchUserStatus();
    fetchStatus();
    
  }

  Future<void> fetchStatus() async {
    setState(() {
      isLoadingUserStatus = true;
      errorLoadingUserStatus = false;
    });

    final prefs = await SharedPreferences.getInstance();

    try {
      final response = await http.get(
        Uri.parse('${constants.apiBaseUrl}/status'),
        headers: {
          'Authorization':
              'Bearer ${prefs.getString(constants.Kprefs.authTokenKey)}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          statuses = data['data'];
        });
      } else {
        setState(() => errorLoadingStatus = true);
      }
    } catch (e) {
      setState(() => errorLoadingStatus = true);
    } finally {
      setState(() => isLoadingStatus = false);
    }
  }

  Future<void> fetchUserStatus() async {
    setState(() {
      isLoadingStatus = true;
      errorLoadingStatus = false;
    });

    final prefs = await SharedPreferences.getInstance();

    try {
      final response = await http.get(
        Uri.parse('${constants.apiBaseUrl}/staff/status?year=$selecteYear'),
        headers: {
          'Authorization':
              'Bearer ${prefs.getString(constants.Kprefs.authTokenKey)}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          userStatuses = data['data'];
        });
      } else {
        setState(() => errorLoadingUserStatus = true);
      }
    } catch (e) {
      setState(() => errorLoadingUserStatus = true);
    } finally {
      setState(() => isLoadingUserStatus = false);
    }
  }

  String titleCase(String input) {
    return input
        .split(' ')
        .map((word) {
          if (word.isEmpty) return '';
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  List<int> getYearsList() {
    int currentYear = DateTime.now().year;
    return [for (int year = 2024; year <= currentYear; year++) year];
  }

  void clearFilter() {
    setState(() {
      selecteYear = DateTime.now().year.toString();
    });
  }

  void handleFABSubmit(Map<String, dynamic> formData) {
    // Example: handle the data
    print('Status: ${formData['type']}');
    print('Notes: ${formData['notes']}');
    print('From: ${formData['from']}');
    print('To: ${formData['to']}');

    // TODO: Add to list or call API, then refresh UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child:
            isLoadingStatus
                ? buildShimmerList()
                : errorLoadingStatus
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Failed to load staff."),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: fetchStatus,
                        icon: const Icon(Icons.refresh),
                        label: const Text("Retry"),
                      ),
                    ],
                  ),
                )
                : Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    key: const ValueKey("statusContent"),
                    children: [
                      ListTile(
                        title: const Text('Filter by Year'),
                        trailing: DropdownButton<String>(
                          value: selecteYear,
                          hint: const Text("Select Year"),
                          items:
                              getYearsList().map<DropdownMenuItem<String>>((
                                int year,
                              ) {
                                final yearStr = year.toString();
                                return DropdownMenuItem<String>(
                                  value: yearStr,
                                  child: Text(yearStr),
                                );
                              }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selecteYear = newValue!;
                              fetchStatus();
                            });
                          },
                        ),
                      ),

                      Expanded(
                        child: ListView.builder(
                          itemCount: userStatuses.length,
                          itemBuilder: (context, index) {
                            final item = userStatuses[index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7.0),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              child: ListTile(
                                leading: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: StatusColor.getColor(item['key']),
                                      width: 3.0,
                                    ),
                                  ),
                                  child: Icon(
                                    StatusIcons.getStatusIcon(item['key']),
                                    color: StatusColor.getColor(item['key']),
                                    size: 40,
                                  ),
                                ),
                                title: Text(
                                  item['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getStatusDateTimeText(item),
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    if (item['notes'] != null &&
                                        item['notes'].isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        item['notes'].toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
      ),
      floatingActionButton: StatusFAB(statuses: statuses, isLoading: isLoadingStatus),
    );
  }
}
