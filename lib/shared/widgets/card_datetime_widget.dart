import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CardDateTime extends StatefulWidget {
  final BoxConstraints size;
  final String date;
  const CardDateTime({super.key, required this.size, required this.date});

  @override
  State<CardDateTime> createState() => _CardDateTimeState();
}

class _CardDateTimeState extends State<CardDateTime> {
  String date = '';
  final format = DateFormat('yyyy/MM/dd');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    int days = DateTime.now().difference(DateTime.parse(widget.date)).inDays;
    switch (days) {
      case 0:
        date = 'Today';
        break;
      case 1:
        date = 'Yesterday';
        break;
      default:
        date = format.format(DateTime.parse(widget.date));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.size.minWidth * .1),
      child: Text(
        date,
        style: TextStyle(
            fontFamily: 'Poppins-Bold',
            color: Colors.grey,
            fontSize: widget.size.minWidth * .05),
      ),
    );
  }
}
