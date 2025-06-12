import 'package:flutter/material.dart';
import '../status_form_viewmodel.dart';

class DatePickerField extends StatelessWidget {
  final StatusFormViewModel vm;
  const DatePickerField({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.date_range),
      label: Text(vm.singleDate == null ? 'Pick Date' : _format(vm.singleDate!)),
      onPressed: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: vm.singleDate ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (picked != null) vm.setSingleDate(picked);
      },
    );
  }

  String _format(DateTime date) => "${date.day}/${date.month}/${date.year}";
}
