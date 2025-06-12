import 'package:flutter/material.dart';
import '../status_form_viewmodel.dart';

class TimeRangePickerField extends StatelessWidget {
  final StatusFormViewModel vm;
  const TimeRangePickerField({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.access_time),
            label: Text(vm.startTime == null ? 'Start Time' : vm.startTime!.format(context)),
            onPressed: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: vm.startTime ?? TimeOfDay.now(),
              );
              if (picked != null) vm.setStartTime(picked);
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.access_time),
            label: Text(vm.endTime == null ? 'End Time' : vm.endTime!.format(context)),
            onPressed: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: vm.endTime ?? TimeOfDay.now(),
              );
              if (picked != null) vm.setEndTime(picked);
            },
          ),
        ),
      ],
    );
  }
}
