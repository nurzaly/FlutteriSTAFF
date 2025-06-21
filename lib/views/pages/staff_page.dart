import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:istaff/data/constants.dart' as constants;
import 'package:istaff/utils/status_utils.dart';
import 'package:istaff/views/widgets/staff_list_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/shimmer_widget.dart';

class StaffPage extends StatefulWidget {
  const StaffPage({super.key});

  @override
  State<StaffPage> createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage>
    with SingleTickerProviderStateMixin {
  List<dynamic> staff = [];
  List<dynamic> units = [];
  List<dynamic> filteredStaff = [];
  late TabController _tabController;
  bool isLoadingUnits = true;
  bool isLoadingStaff = true;
  bool errorLoadingUnits = false;
  bool errorLoadingStaff = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchUnits();
    fetchStaff();
  }

  Future<void> fetchUnits() async {
    setState(() {
      isLoadingUnits = true;
      errorLoadingUnits = false;
    });
    final prefs = await SharedPreferences.getInstance();

    try {
      // await Future.delayed(Duration(seconds: 2));
      final response = await http.get(
        Uri.parse('${constants.apiBaseUrl}/units'),
        headers: {
          'Authorization':
              'Bearer ${prefs.getString(constants.Kprefs.authTokenKey)}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          units = data['data']; // Show all by default
        });
      } else {
        setState(() => errorLoadingUnits = true);
        print('Get Units failed with status: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => errorLoadingUnits = true);
      print('Get Units error: $e');
    } finally {
      setState(() => isLoadingUnits = false);
    }
  }

  Future<void> fetchStaff() async {
    setState(() {
      isLoadingStaff = true;
      errorLoadingStaff = false;
    });
    final prefs = await SharedPreferences.getInstance();

    try {
      final response = await http.get(
        Uri.parse('${constants.apiBaseUrl}/staff'),
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

  void _onUnitTap(int unitId) {
    setState(() {
      filteredStaff = staff.where((s) => s['unit'] == unitId).toList();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tabController.animateTo(0);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 5.0,
          bottom: TabBar(
            controller: _tabController,
            tabs: const [ Tab(text: 'KAKITANGAN'), Tab(text: 'UNIT')],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            // === KAKITANGAN TAB ===
            AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              child:
                  isLoadingStaff
                      ? buildShimmerList()
                      : errorLoadingStaff
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Failed to load staff."),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: fetchStaff,
                              icon: Icon(Icons.refresh),
                              label: Text("Retry"),
                            ),
                          ],
                        ),
                      )
                      : StaffListWidget(
                        staff: staff,
                        filteredStaff: filteredStaff,
                        clearFilter: () {
                          setState(() {
                            filteredStaff = staff; // Reset to show all staff
                          });
                        },
                      ),
            ),
          
            // === UNIT TAB ===
            AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              child:
                  isLoadingUnits
                      ? buildShimmerGrid()
                      : errorLoadingUnits
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Failed to load units."),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: fetchUnits,
                              icon: Icon(Icons.refresh),
                              label: Text("Retry"),
                            ),
                          ],
                        ),
                      )
                      : GridView.builder(
                        key: const ValueKey("unitContent"),
                        padding: const EdgeInsets.all(16.0),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16.0,
                              mainAxisSpacing: 16.0,
                            ),
                        itemCount: units.length,
                        itemBuilder: (context, index) {
                          final unit = units[index];
                          return GestureDetector(
                            onTap: () => _onUnitTap(unit['id']),

                            child: Card(
                              elevation: 4.0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl:
                                        '${constants.baseUrl}/${unit['image_url']}',
                                    height: 48.0,
                                    width: 48.0,
                                    fit: BoxFit.cover,
                                    color: Colors.blue, // <- The tint color
                                    colorBlendMode:
                                        BlendMode
                                            .srcIn, // <- Blend mode for coloring
                                    placeholder:
                                        (context, url) =>
                                            const CircularProgressIndicator(),
                                    errorWidget:
                                        (context, url, error) =>
                                            const Icon(Icons.error),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    unit['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
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
    );
  }
}
