import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:istaff/data/constants.dart' as constants;
import 'package:istaff/data/repositories/dashboard_repository.dart';
import 'package:istaff/utils/datetime_utils.dart';
import 'package:istaff/views/widgets/dashboard_status_widget.dart';
import 'package:istaff/views/widgets/today_attendance_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoadingAttendance = true;
  bool _isLoadingStatus = true;

  List<String> checkinout = ['00:00', '00:00', '00:00'];
  List<String> checkinoutTitle = [
    'Daftar Masuk\n',
    'Sah Daftar\nKeluar',
    'Daftar Keluar\n',
  ];
  List<dynamic> statuses = [];

  @override
  void initState() {
    super.initState();
    fetchDashboardAttendance();
    // fetchDashboardStatus();
  }

  Future<void> fetchDashboardAttendance() async {
    final url = Uri.parse('${constants.apiBaseUrl}/dashboard/attendance');
    final prefs = await SharedPreferences.getInstance();
    try {
      final data = await DashboardRepository().fetchUserStatus();

      print(data);

      // if (response.statusCode == 200) {
      //   // Handle successful response
      //   // Example: print(response.body);
      //   final data = jsonDecode(response.body)['data'];

      //   checkinout[0] =
      //       data.isNotEmpty
      //           ? formatDateTimeTo12Hour(data[0]['checktime']) ?? '00:00'
      //           : '00:00';

      //   checkinout[1] =
      //       data.isNotEmpty ? getSahKeluar(data[0]['checktime']) : '00:00';

      //   if (data.isNotEmpty && data.length >= 2) {
      //     checkinout[2] =
      //         formatDateTimeTo12Hour(data.last['checktime']) ?? '00:00';
      //   } else {
      //     checkinout[2] = '00:00';
      //   }
      // } else {
      //   // Handle error response
      //   print('Error: ${response.statusCode}');
      // }
    } catch (e) {
      // Handle network or parsing errors
      print('Exception: $e');
    } finally {
      setState(() {
        _isLoadingAttendance = false;
      });
    }
  }

  Future<void> fetchDashboardStatus() async {
    final url = Uri.parse('${constants.apiBaseUrl}/dashboard/status');
    final prefs = await SharedPreferences.getInstance();
    
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization':
              'Bearer ${prefs.getString(constants.Kprefs.authTokenKey)}',
        },
      );
      if (response.statusCode == 200) {
        // Handle successful response
        // Example: print(response.body);
        final data = jsonDecode(response.body)['data'];
        if (data.isNotEmpty) {
          statuses = data;
        }

      } else {
        // Handle error response
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or parsing errors
      print('Exception: $e');
    } finally {
      setState(() {
        _isLoadingStatus = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TodayAttendanceWidget(checkinout: checkinout, checkinoutTitle: checkinoutTitle, isLoading: _isLoadingAttendance),
            DashboardStatusWidget(
              isLoading: _isLoadingStatus, errorLoadingUnits: false, statuses: statuses,
            ),
          ],
        ),
      ),
    );
  }

  String getSahKeluar(String time) {
    // Expects time in 'HH:mm:ss' or 'HH:mm'

    if (time.isEmpty) return '--:--';
    time = extractTimeFromDateTime(time);
    final parts = time.split(':');
    if (parts.length >= 2) {
      int hour = int.tryParse(parts[0]) ?? 0;
      int minute = int.tryParse(parts[1]) ?? 0;
      if (hour < 7 || (hour == 7 && minute < 30)) {
        // Time is before 07:30
        time = '16:30';
      } else if (hour >= 9) {
        time = '18:00';
      } else {
        time = addNineHoursOneMinute(time);
      }
    }

    return convertOnlyTimeTo12Hours(time);
  }
}
