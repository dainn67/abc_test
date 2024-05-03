import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// DatePicker Ultra pro max
enum PickerType { day, month, year }

class CustomDatePicker extends StatefulWidget {
  final DateTime? initialDate;
  final void Function(DateTime selectedDate) onSelectDate;

  const CustomDatePicker(
      {super.key, required this.onSelectDate, this.initialDate});

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  final _dayController = FixedExtentScrollController(initialItem: 0);
  final _monthController = FixedExtentScrollController(initialItem: 0);
  final _yearController = FixedExtentScrollController(initialItem: 0);

  int maxDayIndex = 28;

  final List<String> monthStrings = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  final List<String> yearStrings =
      List.generate(30, (index) => (DateTime.now().year + index).toString());

  @override
  void initState() {
    // Get maximum days in current month
    final currentDateTime = widget.initialDate ?? DateTime.now();
    maxDayIndex = _getDaysInMonth(currentDateTime.year, currentDateTime.month);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _dayController.animateToItem(currentDateTime.day - 1,
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
      _monthController.animateToItem(currentDateTime.month - 1,
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
      _yearController.animateToItem(currentDateTime.year - DateTime.now().year,
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              width: 100,
              child: _customCupertinoPicker(
                  PickerType.day, List.generate(31, (index) => index + 1))),
          Expanded(
              child: _customCupertinoPicker(PickerType.month, monthStrings)),
          SizedBox(
              width: 110,
              child: _customCupertinoPicker(PickerType.year, yearStrings)),
        ],
      ),

      // Magnifier section
      IgnorePointer(
        ignoring: true,
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: 50,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8)),
          ),
        ),
      )
    ]);
  }

  Widget _customCupertinoPicker(PickerType type, List<dynamic> items) =>
      CupertinoPicker(
        scrollController: _getScrollController(type),
        selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(
            background: Colors.transparent),
        offAxisFraction: _getOffAxisFraction(type),
        itemExtent: 35,
        magnification: 1.2,
        diameterRatio: 2,
        squeeze: 0.9,
        onSelectedItemChanged: (int value) => _handleSelectDate(type, value),
        children: List.generate(
            items.length,
            (index) => Align(
                  alignment: type != PickerType.day
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: type != PickerType.day ? 15 : 0,
                        right: type == PickerType.day ? 20 : 0),
                    child: Text(
                      items[index].toString(),
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: type == PickerType.day
                              ? _getDayItemColor(index, maxDayIndex)
                              : null),
                    ),
                  ),
                )),
      );

  _handleSelectDate(PickerType type, int value) {
    switch (type) {
      case PickerType.day:
        {
          if (_dayController.selectedItem + 1 > maxDayIndex){
            _dayController.animateToItem(maxDayIndex - 1,
                duration: const Duration(milliseconds: 200),
                curve: Curves.linear);
          }
          break;
        }
      default:
        {
          setState(() {
            maxDayIndex = _getDaysInMonth(
                _yearController.selectedItem + DateTime.now().year, _monthController.selectedItem + 1);
            if (_dayController.selectedItem + 1 > maxDayIndex) {
              _dayController.animateToItem(maxDayIndex - 1,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.linear);
            }
          });
        }
    }

    _update();
  }

  _update() {
    widget.onSelectDate(DateTime(
        DateTime.now().year + _yearController.selectedItem,
        _monthController.selectedItem + 1,
        _dayController.selectedItem + 1));
  }

  _getScrollController(PickerType type) {
    switch (type) {
      case PickerType.day:
        return _dayController;
      case PickerType.month:
        return _monthController;
      case PickerType.year:
        return _yearController;
    }
  }

  _getOffAxisFraction(PickerType type) {
    switch (type) {
      case PickerType.day:
        return -0.5;
      case PickerType.month:
        return 0.3;
      case PickerType.year:
        return 0.6;
    }
  }

  _getDaysInMonth(int year, int month) {
    if (month == DateTime.february) {
      final bool isLeapYear =
          (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
      return isLeapYear ? 29 : 28;
    }
    const List<int> daysInMonth = <int>[
      31,
      -1,
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31
    ];
    return daysInMonth[month - 1];
  }

  _getDayItemColor(int index, int maxDays) {
    return index >= maxDayIndex ? Colors.grey : null;
  }
}
