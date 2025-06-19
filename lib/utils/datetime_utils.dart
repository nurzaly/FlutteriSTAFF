import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String convertOnlyTimeTo12Hours(String time24) {
  // Expects time in 'HH:mm:ss' or 'HH:mm'
  try {
    final parts = time24.split(':');
    if (parts.length < 2) return time24;

    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    String period = hour >= 12 ? 'PM' : 'AM';

    int hour12 = hour % 12 == 0 ? 12 : hour % 12;
    String hourStr = hour12.toString().padLeft(2, '0');
    String minuteStr = minute.toString().padLeft(2, '0');

    if (parts.length > 2) {
      // With seconds
      int second = int.parse(parts[2]);
      String secondStr = second.toString().padLeft(2, '0');
      return '$hourStr:$minuteStr:$secondStr $period';
    } else {
      // Without seconds
      return '$hourStr:$minuteStr $period';
    }
  } catch (e) {
    return time24;
  }
}

// Extracts the time part from a date-time string.
// Expects date-time in 'yyyy-MM-dd HH:mm:ss' format.
String extractTimeFromDateTime(String dateTimeStr) {
  // Expects 'yyyy-MM-dd HH:mm:ss'
  try {
    final dateTime = DateTime.parse(dateTimeStr);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(dateTime.hour)}:${twoDigits(dateTime.minute)}:${twoDigits(dateTime.second)}';
  } catch (e) {
    return '';
  }
}

// Adds 8 hours and 1 minute to a given time string in 'HH:mm' or 'HH:mm:ss' format.
// Returns the new time in the same format.
String addNineHoursOneMinute(String time24) {
  // Expects time in 'HH:mm' or 'HH:mm:ss'
  try {
    List<String> parts = time24.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    int second = parts.length > 2 ? int.parse(parts[2]) : 0;

    DateTime now = DateTime.now();
    DateTime dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,
      second,
    );
    DateTime newTime = dateTime.add(const Duration(hours: 9, minutes: 1));

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(newTime.hour)}:${twoDigits(newTime.minute)}${parts.length > 2 ? ':${twoDigits(newTime.second)}' : ''}';
  } catch (e) {
    return time24;
  }
}

// Converts a date-time string to a 12-hour format.
// Expects date-time in 'yyyy-MM-dd HH:mm:ss' format.
String convertDateTimeStringTo12Hour(String dateTimeStr) {
  try {
    final dateTime = DateTime.parse(dateTimeStr);
    int hour = dateTime.hour;
    int minute = dateTime.minute;
    String period = hour >= 12 ? 'PM' : 'AM';
    int hour12 = hour % 12 == 0 ? 12 : hour % 12;
    return '${hour12.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  } catch (e) {
    return dateTimeStr;
  }
}

// Converts a time string from 24-hour format to 12-hour format.
// Expects time in 'HH:mm' or 'HH:mm:ss' format.
String convertTo12HourFormat(String time) {
  // Expects time in 'HH:mm' or 'HH:mm:ss'
  final parts = time.split(':');
  if (parts.length < 2) return time;
  int hour = int.tryParse(parts[0]) ?? 0;
  int minute = int.tryParse(parts[1]) ?? 0;
  String period = hour >= 12 ? 'PM' : 'AM';
  int hour12 = hour % 12 == 0 ? 12 : hour % 12;
  return '${hour12.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
}

// Formats a date-time string to a 12-hour format.
// Expects date-time in 'yyyy-MM-dd HH:mm:ss' format.
String formatDateTimeTo12Hour(String dateTimeStr) {
  // Expects 'yyyy-MM-dd HH:mm:ss'
  try {
    final dateTime = DateTime.parse(dateTimeStr);
    int hour = dateTime.hour;
    int minute = dateTime.minute;
    String period = hour >= 12 ? 'PM' : 'AM';
    int hour12 = hour % 12 == 0 ? 12 : hour % 12;
    return '${hour12.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  } catch (e) {
    return dateTimeStr;
  }
}

// Extracts the hour part from a time string.
// Expects time in 'HH:mm:ss' or 'HH:mm' format.
String getHourFromTime(String time) {
  if (time.contains(' ')) {
    // Assumes time is in 'yyyy-MM-dd HH:mm:ss' format
    final parts = time.split(' ');
    if (parts.length > 1) {
      final hourPart = parts[1].split(':').first;
      return hourPart;
    }
  }
  return time.split(':').first;
}

// Extracts the hour part from a 12-hour formatted time string.
// Expects time in 'hh:mm AM/PM' format.
String getHourFrom12HourTime(String time) {
  // Expects time in 'hh:mm AM/PM'
  final parts = time.split(':');
  if (parts.isEmpty) return '';
  return parts[0];
}

// Extracts the minute part from a 12-hour formatted time string.
// Expects time in 'hh:mm AM/PM' format.
String getMinuteFrom12HourTime(String time) {
  // Expects time in 'hh:mm AM/PM'
  final parts = time.split(':');
  if (parts.length < 2) return '';
  final minutePart = parts[1].split(' ').first;
  return minutePart;
}

// Extracts the AM/PM part from a 12-hour formatted time string.
// Expects time in 'hh:mm AM/PM' format.
String getAmPmFrom12HourTime(String time) {
  // Expects time in 'hh:mm AM/PM'
  final parts = time.split(' ');
  if (parts.length < 2) return '';
  return parts[1];
}

// Formats a date range string based on the provided date strings.
// If both dates are in the same month, it formats as '1 - 5 Jun 2024'.
String formatDateRange(String dateStr1, String dateStr2) {
  try {
    final date1 = DateTime.parse(dateStr1);
    final date2 = DateTime.parse(dateStr2);

    final sameMonth = date1.month == date2.month && date1.year == date2.year;

    final day1 = date1.day.toString().padLeft(2, '0');
    final day2 = date2.day.toString().padLeft(2, '0');

    if (sameMonth) {
      // Example: 01 - 05 Jun 2024
      final month = DateFormat.MMM().format(date1);
      final year = date1.year;
      return '$day1 - $day2 $month $year';
    } else {
      // Example: 28 May - 02 Jun 2024
      final month1 = DateFormat.MMM().format(date1);
      final month2 = DateFormat.MMM().format(date2);
      final year = date2.year;
      return '$day1 $month1 - $day2 $month2 $year';
    }
  } catch (e) {
    return '$dateStr1 - $dateStr2';
  }
}


// Formats a date string to 'd MMM yyyy' format, e.g., '1 Jun 2024'.
String formatDateDMYText(String dateStr) {
  try {
    final date = DateTime.parse(dateStr);
    return DateFormat('dd MMM yyyy').format(date); // Leading zero for day
  } catch (e) {
    return dateStr;
  }
}

// Formats a date string to 'd-M-yyyy' format, e.g., '1-6-2024'.
String formatDateDMY(String dateStr) {
  try {
    final date = DateTime.parse(dateStr);
    return '${date.day}-${date.month}-${date.year}';
  } catch (e) {
    return dateStr;
  }
}

// Formats a time string from 'HH:mm' to 'h:mm a' (12-hour format).
String formatTime(String timeStr) {
  final format = DateFormat.Hm(); // 24-hour input
  final displayFormat = DateFormat.jm(); // output: 6:15 PM
  final time = format.parse(timeStr);
  return displayFormat.format(time);
}
