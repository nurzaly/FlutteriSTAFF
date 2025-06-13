import 'package:flutter/material.dart';
import '../../data/models/status_model.dart';
import '../../data/repositories/status_repository.dart';


class StatusFormViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final notesController = TextEditingController();

  String? selectedType;
  DateTime? singleDate;
  DateTimeRange? dateRange;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  final List<String> statusTypes = ["Present", "Remote", "Absent", "On Leave"];

  void setType(String? value) {
    selectedType = value;
    resetSelections();
    notifyListeners();
  }

  void setSingleDate(DateTime date) {
    singleDate = date;
    notifyListeners();
  }

  void setDateRange(DateTimeRange range) {
    dateRange = range;
    notifyListeners();
  }

  void setStartTime(TimeOfDay time) {
    startTime = time;
    notifyListeners();
  }

  void setEndTime(TimeOfDay time) {
    endTime = time;
    notifyListeners();
  }

  void resetSelections() {
    singleDate = null;
    dateRange = null;
    startTime = null;
    endTime = null;
  }

  bool validateForm(BuildContext context) {
    if (!formKey.currentState!.validate()) return false;

    if ((selectedType == 'Present' || selectedType == 'Remote') && singleDate == null) {
      _showSnack(context, "Please select a date");
      return false;
    }

    if ((selectedType == 'Absent' || selectedType == 'On Leave') && dateRange == null) {
      _showSnack(context, "Please select a date range");
      return false;
    }

    if (selectedType == 'Remote') {
      if (startTime == null || endTime == null) {
        _showSnack(context, "Please select start and end time");
        return false;
      }
      if (!_isTimeRangeValid()) {
        _showSnack(context, "End time must be after start time");
        return false;
      }
    }

    return true;
  }

  bool _isTimeRangeValid() {
    if (startTime == null || endTime == null) return false;
    final start = DateTime(0, 0, 0, startTime!.hour, startTime!.minute);
    final end = DateTime(0, 0, 0, endTime!.hour, endTime!.minute);
    return end.isAfter(start);
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Map<String, dynamic> getFormData() {
    return {
      'type': selectedType,
      'notes': notesController.text,
      'singleDate': singleDate,
      'dateRange': dateRange,
      'startTime': startTime,
      'endTime': endTime,
    };
  }

  Future<void> submitForm(BuildContext context) async {
  if (!validateForm(context)) return;

  final status = StatusModel(
    type: selectedType!,
    notes: notesController.text,
    startDate: singleDate ?? dateRange?.start ?? DateTime.now(),
    endDate: selectedType == 'Remote' || selectedType == 'Present' ? null : dateRange?.end,
    startTime: startTime?.format(context),
    endTime: endTime?.format(context),
  );

  print("Submitting status: $status");

  try {
    await StatusRepository().submitStatus(status);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Status submitted")));
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
  }
}

}
