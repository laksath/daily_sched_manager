import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransactions extends StatefulWidget {
  final Function newTransaction;

  NewTransactions(this.newTransaction);

  @override
  _NewTransactionsState createState() => _NewTransactionsState();
}

class _NewTransactionsState extends State<NewTransactions> {
  DateTime _chosenDate = DateTime.now();
  TimeOfDay _chosenTime = TimeOfDay(
    hour: int.parse(DateFormat.Hm().format(DateTime.now()).substring(0, 2)),
    minute: int.parse(DateFormat.Hm().format(DateTime.now()).substring(3)),
  );
  Duration _olderTime;
  final _titleTextField = TextEditingController();
  final _moneyTextField = TextEditingController();

  void submitData(BuildContext context) {
    if (_moneyTextField.text.isEmpty ||
        double.parse(_moneyTextField.text).round() <= 0 ||
        _titleTextField.text.isEmpty) {
      return;
    }
    widget.newTransaction(
      title: _titleTextField.text,
      money: double.parse(_moneyTextField.text).round(),
      date: _chosenDate,
    );

    Navigator.of(context).pop();
  }

  void _displayDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) return;
      setState(() {
        if (_olderTime == null) {
          _chosenDate = value.add(
              Duration(hours: _chosenTime.hour, minutes: _chosenTime.minute));
        } else {
          _chosenDate = value.add(
              Duration(hours: _chosenTime.hour, minutes: _chosenTime.minute));
        }
        _olderTime =
            Duration(hours: _chosenTime.hour, minutes: _chosenTime.minute);
      });
    });
  }

  void _displayTimePicker(BuildContext context) {
    showTimePicker(
      context: context,
      initialTime:
          TimeOfDay(hour: _chosenTime.hour, minute: _chosenTime.minute),
    ).then((value) {
      if (value == null) return;
      setState(() {
        if (_olderTime == null) {
          if (DateFormat.Hm().format(_chosenDate) == "00:00") {
            _chosenDate = _chosenDate.add(
                Duration(hours: _chosenTime.hour, minutes: _chosenTime.minute));
          } else {
            _chosenDate = _chosenDate
                .subtract(Duration(
                    hours: _chosenTime.hour, minutes: _chosenTime.minute))
                .add(Duration(hours: value.hour, minutes: value.minute));
          }
          _chosenTime = value;
        } else {
          _chosenTime = value;
          _chosenDate = _chosenDate.subtract(_olderTime).add(
              Duration(hours: _chosenTime.hour, minutes: _chosenTime.minute));
        }
        _olderTime =
            Duration(hours: _chosenTime.hour, minutes: _chosenTime.minute);
      });
    });
  }

  String get showDate {
    if (_chosenDate == null) {
      return "No date chosen yet";
    }
    return "Date entry: ${DateFormat.d().format(_chosenDate)}/${DateFormat.M().format(_chosenDate)}/${DateFormat.y().format(_chosenDate)}";
    // return DateFormat.yMMMEd().add_Hms().format(_chosenDate);
  }

  String get showTime {
    if (_chosenTime == null) {
      return "No time chosen yet";
    }
    String hour = int.parse(_chosenTime.hour.toString()) < 10
        ? "0" + _chosenTime.hour.toString()
        : int.parse(_chosenTime.hour.toString()) < 13
            ? _chosenTime.hour.toString()
            : int.parse(_chosenTime.hour.toString()) >= 22
                ? (int.parse(_chosenTime.hour.toString()) - 12).toString()
                : "0" +
                    (int.parse(_chosenTime.hour.toString()) - 12).toString();
    String minute = int.parse(_chosenTime.minute.toString()) < 10
        ? "0" + _chosenTime.minute.toString()
        : _chosenTime.minute.toString();
    String amPM = int.parse(_chosenTime.hour.toString()) < 12 ? "AM" : "PM";
    return "Time of entry: $hour:$minute $amPM";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Wrap(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: "TITLE",
            ),
            controller: _titleTextField,
          ),
          TextField(
            decoration: InputDecoration(
              labelText: "MONEY",
            ),
            controller: _moneyTextField,
            keyboardType: TextInputType.number,
            onSubmitted: (String _) => submitData(context),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Row(
              children: [
                Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: Text(
                    showDate,
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontSize: 18,
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: IconButton(
                      icon: Icon(
                        Icons.calendar_today,
                        color: Theme.of(context).primaryColorLight,
                        size: 40,
                      ),
                      onPressed: () => _displayDatePicker(context),
                    ),
                  ),
                ),
                Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: Text(
                    showTime,
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontSize: 18,
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: IconButton(
                    icon: Icon(
                      Icons.watch_later_outlined,
                      color: Theme.of(context).primaryColorLight,
                      size: 40,
                    ),
                    onPressed: () => _displayTimePicker(context),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: RaisedButton(
              onPressed: () => submitData(context),
              child: Text("Ok"),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
            ),
            alignment: Alignment.topRight,
            margin: EdgeInsets.only(top: 5, right: 10, bottom: 5),
            decoration: BoxDecoration(),
          )
        ],
      ),
    );
  }
}
