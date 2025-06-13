import 'package:flutter/material.dart';
import 'package:istaff/views/status/status_form_viewmodel.dart';
import 'package:provider/provider.dart';

class StatusFAB extends StatelessWidget {
  final List<dynamic> statuses;
  // This constructor is not used in the current implementation, but can be useful for future enhancements.
  // It allows passing a list of statuses if needed.
  const StatusFAB({super.key, required this.statuses});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StatusFormViewModel(),
      child: Consumer<StatusFormViewModel>(
        builder: (context, vm, child) {
          return FloatingActionButton(
            onPressed: () => _showAddStatusModal(context, vm),
            child: const Icon(Icons.add),
          );
        },
      ),
    );
  }

  void _showAddStatusModal(BuildContext context, StatusFormViewModel vm) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return ChangeNotifierProvider(
          create: (_) => StatusFormViewModel(),
          child: Consumer<StatusFormViewModel>(
            builder: (context, vm, child) {
              return AddStatusForm(statuses: statuses, vm: vm);
            },
          ),
        );
      },
    );
  }
}

class AddStatusForm extends StatefulWidget {
  final List<dynamic> statuses;
  final StatusFormViewModel vm;

  const AddStatusForm({super.key, required this.statuses, required this.vm});

  @override
  State<AddStatusForm> createState() => _AddStatusFormState();
}

class _AddStatusFormState extends State<AddStatusForm> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Form(
          key: widget.vm.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Add Status",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              _buildStatusTypeDropdown(),
              const SizedBox(height: 12),

              _buildDateSection(),
              const SizedBox(height: 20),

              TextFormField(
                controller: widget.vm.notesController,
                decoration: const InputDecoration(labelText: 'Notes'),
              ),
              const SizedBox(height: 16),

              ElevatedButton(
                child: const Text("Submit"),
                onPressed: (){
                  widget.vm.submitForm(context);
                  
                } 
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusTypeDropdown() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(labelText: "Status"),
      items:
          widget.statuses.map<DropdownMenuItem<String>>((status) {
            return DropdownMenuItem<String>(
              value: status['key'] as String,
              child: Text(status['name']),
            );
          }).toList(),

      onChanged: (value) {
        setState(() {
          widget.vm.selectedType = value;
          _resetSelections();
        });
      },
      validator: (value) => value == null ? 'Select a status type' : null,
    );
  }

  Widget _buildDateSection() {
    if (widget.vm.selectedType == null) return Container();

    if (widget.vm.selectedType == '4JAM') {
      return Column(
        children: [
          // _buildSingleDatePicker(),
          if (widget.vm.selectedType == '4JAM') ...[
            const SizedBox(height: 12),
            _buildTimeRangePicker(),
          ],
        ],
      );
    } else {
      return _buildDateRangePicker();
    }
  }

  Widget _buildSingleDatePicker() {
    return ElevatedButton.icon(
      icon: const Icon(Icons.date_range),
      label: Text(
        widget.vm.singleDate == null
            ? 'Pick Date'
            : _formatDate(widget.vm.singleDate!),
      ),
      onPressed: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: widget.vm.singleDate ?? DateTime.now(),
          firstDate: DateTime.now(), // prevent past date
          lastDate: DateTime(2030),
        );
        if (picked != null) {
          setState(() => widget.vm.singleDate = picked);
        }
      },
    );
  }

  Widget _buildDateRangePicker() {
    return ElevatedButton.icon(
      icon: const Icon(Icons.date_range),
      label: Text(
        widget.vm.dateRange == null
            ? 'Pick Date Range'
            : '${_formatDate(widget.vm.dateRange!.start)} - ${_formatDate(widget.vm.dateRange!.end)}',
      ),
      onPressed: () async {
        final picked = await showDateRangePicker(
          context: context,
          initialDateRange:
              widget.vm.dateRange ??
              DateTimeRange(
                start: DateTime.now(),
                end: DateTime.now().add(const Duration(days: 1)),
              ),
          firstDate: DateTime.now(), // prevent past date
          lastDate: DateTime(2030),
        );
        if (picked != null) {
          setState(() => widget.vm.dateRange = picked);
        }
      },
    );
  }

  Widget _buildTimeRangePicker() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.access_time),
            label: Text(
              widget.vm.startTime == null
                  ? 'Start Time'
                  : widget.vm.startTime!.format(context),
            ),
            onPressed: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: widget.vm.startTime ?? TimeOfDay.now(),
              );
              if (picked != null) setState(() => widget.vm.startTime = picked);
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.access_time),
            label: Text(
              widget.vm.endTime == null
                  ? 'End Time'
                  : widget.vm.endTime!.format(context),
            ),
            onPressed: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: widget.vm.endTime ?? TimeOfDay.now(),
              );
              if (picked != null) setState(() => widget.vm.endTime = picked);
            },
          ),
        ),
      ],
    );
  }

  bool _isTimeRangeValid() {
    if (widget.vm.startTime == null || widget.vm.endTime == null) return false;

    final start = DateTime(
      0,
      0,
      0,
      widget.vm.startTime!.hour,
      widget.vm.startTime!.minute,
    );
    final end = DateTime(
      0,
      0,
      0,
      widget.vm.endTime!.hour,
      widget.vm.endTime!.minute,
    );
    return end.isAfter(start);
  }

  void _resetSelections() {
    widget.vm.singleDate = null;
    widget.vm.dateRange = null;
    widget.vm.startTime = null;
    widget.vm.endTime = null;
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
