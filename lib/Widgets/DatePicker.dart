import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local_notification/Utils/Constants/SizeConfig.dart';

import '../Utils/Constants/AllColors.dart';

class DatePickerField extends StatelessWidget {
  final DateTime? initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime> onChanged;
  final String? label;

  const DatePickerField({
    this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.onChanged,
    this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return _DatePickerFieldInner(
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      onChanged: onChanged,
      label: label,
    );
  }
}

class _DatePickerFieldInner extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime> onChanged;
  final String? label;

  const _DatePickerFieldInner({
    this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.onChanged,
    this.label,
  });

  @override
  State<_DatePickerFieldInner> createState() => _DatePickerFieldInnerState();
}

class _DatePickerFieldInnerState extends State<_DatePickerFieldInner> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  Future<void> _pickDate() async {
    // Ensure initialDate is not before firstDate
    final DateTime safeInitialDate =
    (_selectedDate != null && !_selectedDate!.isBefore(widget.firstDate))
        ? _selectedDate!
        : widget.firstDate;

    final picked = await showDatePicker(
      context: context,
      initialDate: safeInitialDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      widget.onChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _pickDate,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: widget.label,
            border: InputBorder.none,
           /// border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),),
            contentPadding:  EdgeInsets.symmetric(
              horizontal: getWidth(12),),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _selectedDate == null
                    ? 'Select date...'
                    : DateFormat('MM/dd/yyyy').format(_selectedDate!),
                style:AppColors().customTextStyle12(fontWeight: FontWeight.w400,color: AppColors.black)
              ),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    );
  }
}