import 'package:flutter/material.dart';
import '../../../widgets/date_time/DatePicker.dart';

class ScheduleForm extends StatelessWidget {
  final TimeOfDay start;
  final TimeOfDay end;
  final DateTime date;
  final Function handleChange;
  final Function handleDateChange;
  final Function selectStartTime;
  final Function selectEndTime;

  const ScheduleForm({
    Key? key,
    required this.start,
    required this.end,
    required this.date,
    required this.handleChange,
    required this.handleDateChange,
    required this.selectStartTime,
    required this.selectEndTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                padding: const EdgeInsets.all(10),
                child: const Text('What is the Availability')),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    padding: const EdgeInsets.all(0),
                    height: 30,
                    width: 200,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6))),
                    child: Text('${date.month}/${date.day}/${date.year}')),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                  height: 30,
                  width: 30,
                  alignment: Alignment.center,
                  child: DatePicker(callbackDate: handleDateChange),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => selectStartTime(),
                  child: Text(start.format(context)),
                ),
                const SizedBox(width: 8),
                const Text("to"),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => selectEndTime(),
                  child: Text(end.format(context)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
