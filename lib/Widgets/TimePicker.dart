import 'package:flutter/material.dart';
import 'package:local_notification/Utils/Constants/SizeConfig.dart';

class TimePickerField extends StatefulWidget {
  final TimeOfDay? initialTime;
  final ValueChanged<TimeOfDay> onChanged;

  const TimePickerField({
    this.initialTime,
    required this.onChanged,
    super.key,
  });

  @override
  State<TimePickerField> createState() => _TimePickerFieldState();
}

class _TimePickerFieldState extends State<TimePickerField> {
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime;
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() => _selectedTime = picked);
      widget.onChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _pickTime,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: InputDecorator(
          decoration: InputDecoration(
            border: InputBorder.none,
          //  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
            contentPadding:  EdgeInsets.symmetric(horizontal: getWidth(12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _selectedTime == null
                    ? 'Select time...'
                    : _selectedTime!.format(context),
              ),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    );
  }
}