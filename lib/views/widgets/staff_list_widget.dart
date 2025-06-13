import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:istaff/data/constants.dart' as constants;
import 'package:istaff/utils/status_utils.dart';

class StaffListWidget extends StatelessWidget {

  var staff;
  var filteredStaff;
  void Function() clearFilter;

  StaffListWidget({
    super.key, 
    required this.staff, 
    required this.filteredStaff,
    required this.clearFilter,
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        key: const ValueKey("staffContent"),
        children: [
          if (filteredStaff.length != staff.length)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                onPressed: clearFilter,
                icon: const Icon(Icons.clear),
                label: const Text("Clear Filter"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredStaff.length,
              itemBuilder: (context, index) {
                final item = filteredStaff[index];
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
                          color: getBorderColor(item),
                          width: 3.0,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 26,
                        backgroundImage: CachedNetworkImageProvider(
                          '${constants.baseUrl}/thumbs/${item['avatar_url']}',
                        ),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    title: Text(
                      item['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['email']),
                        const SizedBox(height: 4),
                        if (item['today_status'] != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            getStatusText(item),
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ],
                    ),
                    trailing: Text(
                      item['extension_number'] ?? '',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
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
}
