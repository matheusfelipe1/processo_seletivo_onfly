import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:processo_seletivo_onfly/shared/extensions/app_extensions.dart';

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
    int days = DateTime.now().difference(DateTime.parse(widget.date.onlyDate)).inDays;
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
  void didUpdateWidget(covariant CardDateTime oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    if (mounted) {
      setState(() {
        int days =
            DateTime.now().difference(DateTime.parse(widget.date.onlyDate)).inDays;
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(top: 10),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: widget.size.minWidth * .1),
        child: Text(
          date,
          style: TextStyle(
              fontFamily: 'Poppins-Bold',
              color: Colors.grey,
              fontSize: widget.size.minWidth * .05),
        ),
      ),
    );
  }
}
