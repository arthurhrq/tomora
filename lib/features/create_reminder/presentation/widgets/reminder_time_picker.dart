import 'package:flutter/material.dart';

/// Seletor de horário com duas rodas de rolagem (hora e minuto),
/// no estilo "relógio giratório" do design. O item central fica
/// destacado em branco/negrito, os demais ficam esmaecidos.
class ReminderTimePicker extends StatefulWidget {
  final int initialHour;
  final int initialMinute;
  final ValueChanged<int> onHourChanged;
  final ValueChanged<int> onMinuteChanged;

  const ReminderTimePicker({
    super.key,
    required this.initialHour,
    required this.initialMinute,
    required this.onHourChanged,
    required this.onMinuteChanged,
  });

  @override
  State<ReminderTimePicker> createState() => _ReminderTimePickerState();
}

class _ReminderTimePickerState extends State<ReminderTimePicker> {
  late int _hour = widget.initialHour;
  late int _minute = widget.initialMinute;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _wheel(
            itemCount: 24,
            initialValue: _hour,
            selectedValue: _hour,
            onChanged: (value) {
              setState(() => _hour = value);
              widget.onHourChanged(value);
            },
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              ':',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          _wheel(
            itemCount: 60,
            initialValue: _minute,
            selectedValue: _minute,
            onChanged: (value) {
              setState(() => _minute = value);
              widget.onMinuteChanged(value);
            },
          ),
        ],
      ),
    );
  }

  Widget _wheel({
    required int itemCount,
    required int initialValue,
    required int selectedValue,
    required ValueChanged<int> onChanged,
  }) {
    return SizedBox(
      width: 70,
      child: ListWheelScrollView.useDelegate(
        itemExtent: 46,
        diameterRatio: 1.3,
        physics: const FixedExtentScrollPhysics(),
        controller: FixedExtentScrollController(
          initialItem: initialValue,
        ),
        onSelectedItemChanged: onChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: itemCount,
          builder: (context, index) {
            final isSelected = index == selectedValue;

            return Center(
              child: Text(
                index.toString().padLeft(2, '0'),
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : Colors.white.withOpacity(0.4),
                  fontSize: isSelected ? 24 : 20,
                  fontWeight: isSelected
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}