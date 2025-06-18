import 'package:flutter/material.dart';
import 'package:istaff/views/status/status_form.dart';
import 'package:istaff/views/status/status_form_viewmodel.dart';
import 'package:provider/provider.dart';

class StatusFAB extends StatelessWidget {
  final List<dynamic> statuses;
  final isLoading;
  // This constructor is not used in the current implementation, but can be useful for future enhancements.
  // It allows passing a list of statuses if needed.
  const StatusFAB({super.key, required this.statuses, required bool this.isLoading});

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
              return StatusForm(statuses: statuses, vm: vm, isLoading: isLoading);
            },
          ),
        );
      },
    );
  }
}

