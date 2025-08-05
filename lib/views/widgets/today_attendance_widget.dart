import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:istaff/utils/datetime_utils.dart';

class TodayAttendanceWidget extends StatelessWidget {
  var checkinout;

  var isLoading;

  var checkinoutTitle;

  TodayAttendanceWidget({
    super.key,
    required this.checkinout,
    required this.checkinoutTitle,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'KEHADIRAN HARI INI',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(3, (index) {
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Text(
                                checkinoutTitle[index],
                                style: const TextStyle(height: 1),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                getHourFrom12HourTime(checkinout[index]),
                                style: GoogleFonts.robotoCondensed(
                                  fontSize: 70,
                                  height: 0.8,
                                ),
                              ),
                              Text(
                                getMinuteFrom12HourTime(checkinout[index]),
                                style: const TextStyle(
                                  fontSize: 60,
                                  height: 0.8,
                                ),
                              ),
                              Text(
                                getAmPmFrom12HourTime(checkinout[index]),
                                style: TextStyle(
                                  fontSize: 40,
                                  color: Colors.grey[700],
                                  height: 0.8,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
