import 'package:flutter/material.dart';
import 'package:istaff/data/notifiers.dart';
import 'package:istaff/utils/status_utils.dart';
import 'package:istaff/views/pages/staff_list_page.dart';
import 'package:istaff/views/widgets/shimmer_widget.dart';

class DashboardStatusWidget extends StatelessWidget {
  final bool isLoading;

  final bool errorLoadingUnits;

  final dynamic statuses;

  const DashboardStatusWidget({
    Key? key,
    required this.isLoading,
    required this.errorLoadingUnits,
    required this.statuses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'STATUS KAKITANGAN',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // Placeholder for status content
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                    key: const ValueKey("statusContent"),
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 4.0,
                        ),
                    itemCount: statuses.length,
                    shrinkWrap: true, // ✅ important
                    physics:
                        NeverScrollableScrollPhysics(), // ✅ disables GridView's internal scroll
                    itemBuilder: (context, index) {
                      final status = statuses[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return StaffListPage(status: status['key'], 
                                  title: status['name']);
                              },
                            ),
                          );
                        }, // fixed usage of _onStatusTap
                        child: Card(
                          elevation: 4.0,

                          child: Container(
                            decoration: BoxDecoration(
                              color: StatusColor.getColor(
                                status['key'],
                              ), // background color
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  status['user_count'].toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 50.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  status['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            ],
          ),
        ),
      ),
    );
  }
}