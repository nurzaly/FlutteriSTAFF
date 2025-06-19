import 'package:flutter/material.dart';
import '../../data/models/status_model.dart';
import '../../data/repositories/status_repository.dart';

class StatusFormViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final notesController = TextEditingController();
  bool _disposed = false;

  String? selectedType;
  DateTime? singleDate;
  DateTimeRange? dateRange;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  // final List<String> statusTypes = ["Present", "Remote", "Absent", "On Leave"];

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

    if ((selectedType == 'Present' || selectedType == 'Remote') &&
        singleDate == null) {
      _showSnack(context, "Please select a date");
      return false;
    }

    if ((selectedType == 'Absent' || selectedType == 'On Leave') &&
        dateRange == null) {
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
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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

  bool get isDisposed => _disposed;

  @override
  void dispose() {
    _disposed = true;
    notesController.dispose();
    super.dispose();
  }

  Future<void> submitForm(
    BuildContext context,
    isLoading,
    VoidCallback? onSubmitSuccess,
  ) async {
    if (!validateForm(context)) return;

    isLoading = true;
    notifyListeners();

    final status = StatusModel(
      type: selectedType!,
      notes: notesController.text,
      startDate: singleDate ?? dateRange?.start ?? DateTime.now(),
      endDate: dateRange?.end,
      startTime: startTime?.format(context),
      endTime: endTime?.format(context),
    );

    try {
      final data = await StatusRepository().submitStatus(status);

      print('Data : $data');

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(data['message'])));
      if (data['status'] == "success") {
        Navigator.of(context).pop();
        if (onSubmitSuccess != null) {
          onSubmitSuccess();
        }
      } else {
        Navigator.of(context).pop();
      }
      // close modal
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Submission failed: ${e.toString()}")),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
