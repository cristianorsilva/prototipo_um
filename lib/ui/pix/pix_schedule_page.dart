import 'package:flutter/material.dart';
import 'package:prototipo_um/helpers/database/user.dart';
import 'package:prototipo_um/helpers/database/user_account.dart';
import 'package:prototipo_um/helpers/database/user_transaction.dart';
import 'package:prototipo_um/helpers/utils.dart';
import 'package:table_calendar/table_calendar.dart';

class PixSchedulePage extends StatefulWidget {
  const PixSchedulePage({Key? key, this.userTo, this.userTransaction, this.listUserAccount}) : super(key: key);

  @override
  _PixSchedulePageState createState() => _PixSchedulePageState();

  final User? userTo;
  final UserTransaction? userTransaction;
  final List<UserAccount>? listUserAccount;
}

class _PixSchedulePageState extends State<PixSchedulePage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SingleChildScrollView(
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            //padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: Icon(
                        Icons.clear,
                      ),
                      onTap: () {
                        setState(() {
                          Navigator.pop(context, _selectedDay);
                        });


                      },
                    ),
                  ],
                ),
              ],
            ),
          ),



          Padding(padding: EdgeInsets.only(bottom: 10)),
          Text(
            'Para qual dia deseja agendar o pagamento?',
            style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
          ),

          Padding(padding: EdgeInsets.only(bottom: 20)),
          RichText(
            text: TextSpan(style: TextStyle(fontSize: 18.0, color: Colors.black, ), children: [
              new TextSpan(text: 'Você está transferindo ', style: TextStyle(fontSize: 18.0, color: Colors.black)),
              new TextSpan(text: Utils().putCurrencyMask(widget.userTransaction!.value), style: TextStyle(fontSize: 25.0, color: Colors.black, fontWeight: FontWeight.bold)),
              new TextSpan(text: ' para ', style: TextStyle(fontSize: 18.0, color: Colors.black)),
              new TextSpan(text: widget.userTo!.name, style: TextStyle(fontSize: 25.0, color: Colors.black, fontWeight: FontWeight.bold,)),
            ]),
          ),
          Padding(padding: EdgeInsets.only(bottom: 20)),


          TableCalendar(
            headerStyle: HeaderStyle(titleCentered: true, formatButtonVisible: false),
            calendarStyle: CalendarStyle(
                selectedTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                selectedDecoration: BoxDecoration(shape: BoxShape.circle, color: Colors.deepPurple)),
            firstDay: DateTime.now(),
            lastDay: DateTime(2050, 01, 01),
            focusedDay: _selectedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              // Use `selectedDayPredicate` to determine which day is currently selected.
              // If this returns true, then `day` will be marked as selected.

              // Using `isSameDay` is recommended to disregard
              // the time-part of compared DateTime objects.
              return isSameDay(_selectedDay, day);
            },
            locale: 'pt_BR',
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                // Call `setState()` when updating the selected day
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                // Call `setState()` when updating calendar format
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              // No need to call `setState()` here
              _focusedDay = focusedDay;
            },
          ),


        ],
      ),
    ));

  }
}
