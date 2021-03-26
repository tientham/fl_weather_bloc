import 'package:flutter/material.dart';

class LastUpdated extends StatelessWidget {
  final DateTime dateTime;

  LastUpdated({required this.dateTime});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Updated: ${TimeOfDay.fromDateTime(dateTime).format(context)}',
      style: TextStyle(
          fontSize: 18, fontWeight: FontWeight.w200, color: Colors.white),
    );
  }
}
