import 'package:flutter/material.dart';
import '../status_form_viewmodel.dart';

class DateRangePickerField extends StatelessWidget {
  final StatusFormViewModel vm;
  const DateRangePickerField({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.date_range),
      label: Text(vm.dateRange == null
          ? 'Pick Date Range'
          : '${_format(vm.dateRange!.start)} - ${_format(vm.dateRange!.end)}'),
      onPressed: () async {
        final picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (picked != null) vm.setDateRange(picked);
      },
    );
  }

  String _format(DateTime date) => "${date.day}/${date.month}/${date.year}";
}
