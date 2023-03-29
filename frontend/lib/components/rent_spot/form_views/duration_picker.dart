import 'package:flutter/material.dart';
import 'package:duration_picker/duration_picker.dart';

class DurationPickerModal extends StatefulWidget {
  final Duration initialDuration;
  final DateTime endDuration;
  final void Function(Duration duration) onDurationSelected;

  const DurationPickerModal({
    super.key,
    required this.initialDuration,
    required this.endDuration,
    required this.onDurationSelected,
  });

  @override
  State<DurationPickerModal> createState() => _DurationPickerModalState();
}

class _DurationPickerModalState extends State<DurationPickerModal> {
  late Duration _duration;
  late Duration _maxDuration;

  @override
  void initState() {
    super.initState();
    _maxDuration = widget.endDuration.difference(DateTime.now());
    _duration = widget.initialDuration > _maxDuration
        ? _maxDuration
        : widget.initialDuration;
    print(_maxDuration);
  }

  void handleDurationChange(Duration duration) {
    _maxDuration = widget.endDuration.difference(DateTime.now());
    const minDuration = Duration(minutes: 15);
    setState(() {
      if (duration <= _maxDuration && duration >= minDuration) {
        _duration = duration;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          'Select Duration (max:${_maxDuration.inHours}h ${(_maxDuration.inMinutes.remainder(60))}m)'),
      content: DurationPicker(
        duration: _duration,
        onChange: (duration) => handleDurationChange(duration),
        // snapToMins: 15,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            widget.onDurationSelected(widget.initialDuration); // user cancelled
            Navigator.of(context).pop();
          },
          child: const Text('CANCEL'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onDurationSelected(_duration); // user selected a duration
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}


// class DurationPicker extends StatefulWidget {
//   final Spot spot;
//   const DurationPicker({Key? key, required this.spot}) : super(key: key);

//   @override
//   State<DurationPicker> createState() => _DurationPicker();
// }

// class _DurationPicker extends State<DurationPicker> {
//   int availableDuration = 0;
//   TimeOfDay availableHoursAndMinutes = const TimeOfDay(hour: 0, minute: 0);
//   Time _time = Time(hour: 0, minute: 30);

//   // late num _totalPrice;
//   double _minMinute = 15;

//   @override
//   void initState() {
//     super.initState();
//     availableDuration =
//         calcAvailableDuration(DateTime.now(), widget.spot.time.end);
//     availableHoursAndMinutes =
//         calcAvailableHoursAndMinutes(availableDuration, 0);
//     // _totalPrice = calcTotalPrice(_time, widget.spot.priceRate);
//   }

//   void onTimeChanged(Time newTime) {
//     setState(() {
//       _time = newTime;
//       availableDuration =
//           calcAvailableDuration(DateTime.now(), widget.spot.time.end);
//       availableHoursAndMinutes =
//           calcAvailableHoursAndMinutes(availableDuration, newTime.hour);
//       // _totalPrice = calcTotalPrice(_time, widget.spot.priceRate);
//       if (_time.hour == 0 && availableHoursAndMinutes.minute > 15) {
//         _minMinute = 15;
//       } else {
//         _minMinute = 0;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             Text(
//               'Duration: ${_time.hour} hours ${_time.minute} minutes',
//               style: Theme.of(context).textTheme.titleLarge,
//             ),
//       floatingActionButton: Builder(
//           builder: (BuildContext context) => FloatingActionButton(
//                 onPressed: () async {
//                   var resultingDuration = await showDurationPicker(
//                     context: context,
//                     initialTime: Duration(minutes: 30),
//                   );
//                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                       content: Text('Chose duration: $resultingDuration')));
//                 },
//                 tooltip: 'Popup Duration Picker',
//                 child: Icon(Icons.add),
//               )),
//             // showPicker(
//             //   elevation: 1,
//             //   height: 230,
//             //   accentColor: Colors.grey,
//             //   isInlinePicker: true,
//             //   isOnChangeValueMode: true,
//             //   context: context,
//             //   value: _time,
//             //   is24HrFormat: true,
//             //   disableAutoFocusToNextInput: true,
//             //   displayHeader: false,
//             //   onChange: onTimeChanged,
//             //   minuteInterval: TimePickerInterval.FIFTEEN,
//             //   // maxHour: availableHoursAndMinutes.hour.toDouble(),
//             //   maxHour: 30,
//             //   maxMinute: availableHoursAndMinutes.minute.toDouble(),
//             //   minMinute: _minMinute,
//             //   iosStylePicker: true,
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// //calculates the available duration in minutes from start and end time
// int calcAvailableDuration(DateTime start, DateTime end) {
//   int availableTimeInMinutes =
//       convertDateTimeToMinutes(end) - convertDateTimeToMinutes(start);
//   return availableTimeInMinutes;
// }

// // calculates the number of minutes passed in the day from a DateTime
// int convertDateTimeToMinutes(DateTime time) {
//   int timeInMinutes;
//   timeInMinutes = time.hour * 60 + time.minute;
//   return timeInMinutes;
// }

// TimeOfDay calcAvailableHoursAndMinutes(
//     int spotDurationInMinutes, int selectedHour) {
//   int maxHours = spotDurationInMinutes ~/ 60;
//   TimeOfDay availableTime;
//   // if remaining duration is less than the minimum time step, set the time to be the remaining time on spot
//   if (spotDurationInMinutes < 15) {
//     availableTime = TimeOfDay(hour: 0, minute: spotDurationInMinutes);
//   } else {
//     int maxMinutes;
//     // if hour hour scroller is at its max or min, adjust selectable minutes accordingly
//     if (maxHours < 0 || selectedHour == maxHours) {
//       maxMinutes = ((spotDurationInMinutes ~/ 15) * 15) - (selectedHour * 60);
//     } else {
//       maxMinutes = 45;
//     }
//     availableTime = TimeOfDay(hour: maxHours, minute: maxMinutes);
//   }
//   return availableTime;
// }

