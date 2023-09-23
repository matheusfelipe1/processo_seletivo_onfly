import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../static/app_colors.dart';

class CardDateField extends StatefulWidget {
  final String title;
  final Function(String)? onComplete;
  const CardDateField({
    super.key,
    required this.title,
    this.onComplete,
  });

  @override
  State<CardDateField> createState() => _CardDateFieldState();
}

class _CardDateFieldState extends State<CardDateField> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: size.width * .05, vertical: size.width * .05),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                  fontFamily: 'Poppins-Bold',
                  color: Color.fromARGB(255, 131, 131, 131)),
            ),
            InkWell(
              onTap: () => showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2019),
                  lastDate: DateTime(2026)),
              child: TextFormField(
                onFieldSubmitted: (val) => FocusScope.of(context).nextFocus(),
                keyboardType: TextInputType.datetime,
                enabled: false,
                onTap: () => showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2019),
                    lastDate: DateTime(2026)),
                onChanged: (text) => widget.onComplete?.call(text),
                onTapOutside: (val) => FocusScope.of(context).unfocus(),
                decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.calendar_today),
                    hintText: 'yyyy/mm/dd',
                    disabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.blue))),
              ),
            )
          ],
        ),
      ),
    );
  }
}
