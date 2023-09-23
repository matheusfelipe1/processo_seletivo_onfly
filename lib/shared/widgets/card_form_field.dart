import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:processo_seletivo_onfly/shared/static/app_colors.dart';

class CardFormField extends StatefulWidget {
  final String title;
  final String hint;
  final Function(String)? onComplete;
  final TextInputFormatter? mask;
  final NumberFormat? format;
  final Icon? icon;
  const CardFormField(
      {super.key,
      required this.title,
      this.onComplete,
      this.mask,
      this.format,
      this.icon,
      required this.hint});

  @override
  State<CardFormField> createState() => _CardFormFieldState();
}

class _CardFormFieldState extends State<CardFormField> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: size.width * .05, vertical: size.width * .05),
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                  fontFamily: 'Poppins-Bold',
                  color: Color.fromARGB(255, 131, 131, 131)),
            ),
            TextFormField(
              keyboardType: widget.mask != null || widget.format != null
                  ? TextInputType.number
                  : TextInputType.text,
              inputFormatters: [widget.mask ?? MaskTextInputFormatter()],
              onChanged: (text) => widget.onComplete?.call(text),
              onTapOutside: (val) => FocusScope.of(context).unfocus(),
              onFieldSubmitted: (val) => FocusScope.of(context).nextFocus(),
              decoration: InputDecoration(
                  suffixIcon: widget.icon,
                  hintText: widget.hint,
                  disabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.blue))),
            )
          ],
        ),
      ),
    );
  }
}
