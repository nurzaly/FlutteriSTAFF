import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'status_form_viewmodel.dart';
import 'widgets/date_picker_field.dart';
import 'widgets/date_range_picker_field.dart';
import 'widgets/time_range_picker_field.dart';

class StatusForm extends StatelessWidget {
  const StatusForm({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StatusFormViewModel(),
      child: Consumer<StatusFormViewModel>(
        builder: (context, vm, child) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: Form(
              key: vm.formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Add Status", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: "Status Type"),
                    items: vm.statusTypes.map((status) {
                      return DropdownMenuItem(value: status, child: Text(status));
                    }).toList(),
                    value: vm.selectedType,
                    onChanged: vm.setType,
                    validator: (value) => value == null ? 'Select a status type' : null,
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: vm.notesController,
                    decoration: const InputDecoration(labelText: 'Notes'),
                  ),

                  const SizedBox(height: 16),

                  if (vm.selectedType == 'Present' || vm.selectedType == 'Remote') 
                    DatePickerField(vm: vm),

                  if (vm.selectedType == 'Remote')
                    TimeRangePickerField(vm: vm),

                  if (vm.selectedType == 'Absent' || vm.selectedType == 'On Leave')
                    DateRangePickerField(vm: vm),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    child: const Text("Submit"),
                    onPressed: () {
                      if (vm.validateForm(context)) {
                        Navigator.pop(context);
                        print(vm.getFormData());
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
