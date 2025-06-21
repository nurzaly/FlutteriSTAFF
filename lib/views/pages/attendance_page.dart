import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:istaff/data/constants.dart';
import 'package:istaff/data/models/attendance_model.dart';
import 'package:istaff/data/models/holiday_model.dart';
import 'package:istaff/data/models/status_model.dart';
import 'dart:convert';

import 'package:istaff/data/repositories/attendance_repository.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({Key? key}) : super(key: key);

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  DateTime selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  Map<String, Map<String, String>> attendanceMap = {}; // key: yyyy-MM-dd
  List<Holiday> holidays = [];
  List<StatusModel> statuses = [];
  bool isLoadingAttendance = true;

  int totalPresent = 0;
  int totalAbsent = 0;
  int totalLate = 0;

  @override
  void initState() {
    super.initState();
    _loadAttendanceData();
  }

  Future<void> _loadAttendanceData() async {
    try {
      isLoadingAttendance = true;
      final data = await AttendanceRepository().fetchUserAttendances(
        selectedMonth.month
            .toString(), // replace with selectedMonth.year and selectedMonth.month
      );

      holidays = data.holidays;
      statuses = data.statuses;

      final Map<String, List<Attendance>> grouped = {};

      for (var att in data.attendances) {
        final dateKey = DateFormat('yyyy-MM-dd').format(att.checktime);
        grouped.putIfAbsent(dateKey, () => []).add(att);
      }

      // Reset counts
      totalPresent = 0;
      totalLate = 0;
      totalAbsent = 0;
      attendanceMap.clear();

      grouped.forEach((dateKey, records) {
        // Sort checktimes
        records.sort((a, b) => a.checktime.compareTo(b.checktime));

        final checkInTime = records.first.checktime;
        final checkOutTime = records.last.checktime;

        attendanceMap[dateKey] = {
          'checkIn': DateFormat('HH:mm').format(checkInTime),
          'checkOut': DateFormat('HH:mm').format(checkOutTime),
          'hours': _calculateHours(checkInTime, checkOutTime),
        };

        totalPresent++;

        final lateThreshold = DateTime(
          checkInTime.year,
          checkInTime.month,
          checkInTime.day,
          9,
          1,
        );

        if (checkInTime.isAfter(lateThreshold)) {
          totalLate++;
        }
      });

      // Count absent days in selected month
      final currentMonthDays = _getDaysInMonth(selectedMonth);
      for (var day in currentMonthDays) {
        final key = DateFormat('yyyy-MM-dd').format(day);
        if (!attendanceMap.containsKey(key)) {
          totalAbsent++;
        }
      }

      setState(() {});
    } catch (e) {
      print('API Error: $e');
    } finally {
      setState(() {
        isLoadingAttendance = false;
      });
    }
  }

  String _calculateHours(DateTime checkIn, DateTime checkOut) {
    final duration = checkOut.difference(checkIn);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  Widget _buildSummaryItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          '$count',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = _getDaysInMonth(selectedMonth);

    return Scaffold(
      // appBar: AppBar(title: const Text('User Attendance')),
      body:
          isLoadingAttendance
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Container(child: _buildMonthDropdown()),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(
                  //     horizontal: 16,
                  //     vertical: 8,
                  //   ),
                  //   child: Card(
                  //     elevation: 2,
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(12),
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //         children: [
                  //           _buildSummaryItem(
                  //             "Present",
                  //             totalPresent,
                  //             Colors.green,
                  //           ),
                  //           _buildSummaryItem("Late", totalLate, Colors.orange),
                  //           _buildSummaryItem(
                  //             "Absent",
                  //             totalAbsent,
                  //             Colors.red,
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  Expanded(
                    child: ListView.builder(
                      itemCount: daysInMonth.length,
                      itemBuilder: (context, index) {
                        final day = daysInMonth[index];
                        final dayKey = DateFormat('yyyy-MM-dd').format(day);
                        final weekday = DateFormat(
                          'E',
                        ).format(day); // e.g., Mon
                        final isWeekend =
                            day.weekday == DateTime.saturday ||
                            day.weekday == DateTime.sunday;
                        final data = attendanceMap[dayKey];

                        final holiday = getHolidayForDate(
                          day.day,
                          day.month,
                          day.year,
                        );

                        final isLate =
                            data != null &&
                            data['checkIn'] != null &&
                            DateFormat('HH:mm')
                                .parse(data['checkIn']!)
                                .isAfter(DateFormat('HH:mm').parse('09:00'));

                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    holiday != null
                                        ? Colors.pink[200]
                                        : isWeekend
                                        ? Colors.grey[600]
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(
                                  16,
                                ), // Rounded corners
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    // Left: Day in circle
                                    CircleAvatar(
                                      backgroundColor:
                                          isWeekend
                                              ? Colors.grey[800]
                                              : Colors.deepPurple,
                                      radius: 24,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${day.day}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            weekday,
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 16),

                                    // Right side: Check-in/out info
                                    Expanded(
                                      child:
                                          data == null
                                              ? buildAbsentText(
                                                day.day,
                                                day.month,
                                                day.year,
                                                isWeekend,
                                              )
                                              : buildCheckInOut(data: data, isLate: isLate),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildMonthDropdown() {
    List<DateTime> months = List.generate(
      12,
      (i) => DateTime(DateTime.now().year, i + 1),
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: DropdownButton<DateTime>(
        isExpanded: true,
        value: selectedMonth,
        items:
            months.map((month) {
              return DropdownMenuItem<DateTime>(
                value: month,
                child: Text(DateFormat('MMMM yyyy').format(month)),
              );
            }).toList(),
        onChanged: (value) {
          print('Selected month: $value');
          if (value != null) {
            setState(() {
              selectedMonth = value;
            });
            _loadAttendanceData(); // re-fetch for new month
          }
        },
      ),
    );
  }

  List<DateTime> _getDaysInMonth(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    return List.generate(
      lastDay.day,
      (i) => DateTime(month.year, month.month, i + 1),
    );
  }

  String? getHolidayForDate(int day, int month, int year) {
    DateTime givenDate = DateTime(year, month, day);

    for (var holiday in holidays) {
      DateTime holidayDate = DateTime.parse(holiday.date.toIso8601String());
      if (holidayDate.year == givenDate.year &&
          holidayDate.month == givenDate.month &&
          holidayDate.day == givenDate.day) {
        return holiday.name;
      }
    }

    return null; // No match found
  }

  bool isBetween(DateTime givenDate, DateTime startDate, DateTime endDate) {
    return (givenDate.isAtSameMomentAs(startDate) ||
            givenDate.isAfter(startDate)) &&
        (givenDate.isAtSameMomentAs(endDate) || givenDate.isBefore(endDate));
  }

  String? getStatusForDate(int day, int month, int year) {
    DateTime givenDate = DateTime(year, month, day);

    for (var status in statuses) {
      // DateTime statusDate = DateTime.parse(status.date.toIso8601String());
      if (status.endDate != null) {
        if (isBetween(givenDate, status.startDate, status.endDate!)) {
          return '${status.name!.toUpperCase()} - ${status.notes!.toUpperCase()}';
        }
      }
      if (status.startDate != null &&
          givenDate.isAtSameMomentAs(status.startDate)) {
        return '${status.name!.toUpperCase()} - ${status.notes!.toUpperCase()}';
      }
    }

    return null; // No match found
  }

  bool isBeforeOrEqualToday(int day, int month, int year) {
    DateTime givenDate = DateTime(DateTime.now().year, month, day);
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    return givenDate.isBefore(today) || givenDate.isAtSameMomentAs(today);
  }

  Widget buildAbsentText(int day, int month, int year, bool isWeekend) {
    final holiday = getHolidayForDate(day, month, year);
    final status = getStatusForDate(day, month, year);

    if (holiday != null) {
      return Text(
        holiday,
        style: const TextStyle(color: Colors.pink, fontWeight: FontWeight.bold),
      );
    }
    if (status != null) {
      return Text(
        status,
        style: const TextStyle(color: Colors.pink, fontWeight: FontWeight.bold),
      );
    }

    if (isBeforeOrEqualToday(day, month, year)) {
      return Text(
        isWeekend ? '' : 'Absent',
        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      );
    } else {
      return const Text('', style: TextStyle());
    }
  }
}

class buildCheckInOut extends StatelessWidget {
  const buildCheckInOut({
    super.key,
    required this.data,
    required this.isLate,
  });

  final Map<String, String>? data;
  final bool isLate;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment
              .spaceBetween,
      children: [
        Row(
          children: [
            const Icon(
              Icons.login,
              size: 20,
              color: Colors.green,
            ),
            const SizedBox(width: 6),
            Text(
              data?['checkIn'] ??
                  '--:--',
              style: TextStyle(
                color:
                    isLate
                        ? Colors.red
                        : Colors
                            .green,
                fontWeight:
                    FontWeight.w600,
                    fontSize: 24,
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Icon(
              Icons.logout,
              size: 20,
              color: Colors.red,
            ),
            const SizedBox(width: 6),
            Text(
              data?['checkOut'] ??
                  '--:--',
              style: const TextStyle(
                fontWeight:
                    FontWeight.w600,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
