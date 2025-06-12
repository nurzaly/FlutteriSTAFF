import 'package:flutter/material.dart';
import 'package:istaff/utils/datetime_utils.dart';

class StatusIcons {
  static const Map<String, IconData> statusIcons = {
    'CUTI': Icons.beach_access,
    'SAKIT': Icons.sick ,
    'RASMI': Icons.airplanemode_active ,
    'KURSUS': Icons.school,
    '4JAM': Icons.access_time,
    'KELOMPOK': Icons.child_friendly ,
    'BERTUGAS': Icons.work,
    'TIADA-STATUS': Icons.help_outline,
  };

  /// Returns the IconData for a given status key
  static IconData getStatusIcon(String key) {
    return statusIcons[key] ?? Icons.help_outline; // fallback icon
  }
}

class StatusColor {
  static const Map<String, Color> statusColors = {
    'CUTI': Colors.cyan,
    'SAKIT': Colors.pink,
    'RASMI': Colors.deepOrange,
    'KURSUS': Colors.amber,
    '4JAM': Colors.deepPurple,
    'KELOMPOK': Colors.indigo,
    'BERTUGAS': Colors.green,
    'TIADA-STATUS': Colors.blueGrey,
  };

  /// Returns the Color for a given status key
  static Color getColor(String key) {
    return statusColors[key] ?? Colors.grey; // fallback color
  }
}

Color getBorderColor(Map<String, dynamic> item) {
  // Status key to color mapping
  const Map<String, Color> statusColors = {
    'CUTI': Colors.cyan,
    'SAKIT': Colors.purple,
    'RASMI': Colors.orange,
    'KURSUS': Colors.yellow,
    '4JAM': Colors.deepPurple,
    'BERTUGAS': Colors.green,
    'TIADA-STATUS': Colors.grey,
  };

  if (item['status'] != null &&
      item['status'] is List &&
      item['status'].isNotEmpty &&
      item['status'][0] is Map &&
      item['status'][0]['key'] != null) {
    final key = item['status'][0]['key'];
    return statusColors[key] ?? Colors.grey; // fallback if key not in map
  } else if (item['attendance'] != null &&
      item['attendance'].isNotEmpty &&
      item['attendance'][0] != null) {
    return Colors.green;
  }

  return Colors.grey; // default if no valid status
}

bool isFourJam(Map<String, dynamic> item) {
  if (item['status'] != null &&
      item['status'] is List &&
      item['status'].isNotEmpty &&
      item['status'][0] is Map &&
      item['status'][0]['key'] == '4JAM') {
    return true;
  }
  return false;
}

bool isCurrentTimeBetween(String startTime, String endTime) {
  final now = TimeOfDay.now();

  TimeOfDay parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  final start = parseTime(startTime);
  final end = parseTime(endTime);

  bool isAfterOrEqual(TimeOfDay a, TimeOfDay b) =>
      a.hour > b.hour || (a.hour == b.hour && a.minute >= b.minute);

  bool isBeforeOrEqual(TimeOfDay a, TimeOfDay b) =>
      a.hour < b.hour || (a.hour == b.hour && a.minute <= b.minute);

  if (isAfterOrEqual(end, start)) {
    // Normal case: e.g. 09:00 - 17:00
    return isAfterOrEqual(now, start) && isBeforeOrEqual(now, end);
  } else {
    // Overnight case: e.g. 22:00 - 06:00
    return isAfterOrEqual(now, start) || isBeforeOrEqual(now, end);
  }
}

String getStatusDateTimeText(Map<String, dynamic> item) {

  if (item.isNotEmpty) {
    final dates = item['dates'] as Map?;
    final datesList = dates?['date'];
    final timesList = dates?['time'];

    if(item['key'] == '4JAM' && timesList is List && timesList.length >= 2) {
      final time1 = formatTime(timesList[0]);
      final time2 = formatTime(timesList[1]);
      return '${formatDateDMYText(datesList[0])} [ $time1 - $time2 ]';
    }

    if (datesList is List) {
      if (datesList.length >= 2) {
        final date1 = datesList[0];
        final date2 = datesList.last;
        return '${formatDateDMYText(date1)} - ${formatDateDMYText(date2)}';
      } else if (datesList.length == 1) {
        return formatDateDMYText(datesList[0]);
      }
    }
  }

  return '';
}

String getStatusText(Map<String, dynamic> item) {
  final statusList = item['status'];
  if (statusList is List && statusList.isNotEmpty && statusList[0] is Map) {
    final status = statusList[0];
    final name = status['name'] ?? '';
    final dates = status['dates'] as Map?;
    final times = dates?['time'];
    final datesList = dates?['date'];

    if (isFourJam(item) && times is List && times.length >= 2) {
      final time1 = formatTime(times[0]);
      final time2 = formatTime(times[1]);
      return '$name [ $time1 - $time2 ]';
    }

    if (datesList is List) {
      if (datesList.length >= 2) {
        final date1 = datesList[0];
        final date2 = datesList.last;
        return '$name [ ${formatDateRange(date1, date2)} ]';
      } else if (datesList.length == 1) {
        final date1 = formatDateDMYText(datesList[0]);
        return '$name: $date1';
      }
    }
  }

  return '';
}

