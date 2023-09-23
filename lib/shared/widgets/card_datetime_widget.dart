import 'package:flutter/material.dart';

class CardDateTime extends StatelessWidget {
  final BoxConstraints size;
  const CardDateTime({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.minWidth * .1),
      child: Text(
        'Today',
        style: TextStyle(
            fontFamily: 'Poppins-Bold',
            color: Colors.grey,
            fontSize: size.minWidth * .05),
      ),
    );
  }
}
