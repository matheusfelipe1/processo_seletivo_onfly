import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:processo_seletivo_onfly/shared/enum/card_enum.dart';
import 'package:processo_seletivo_onfly/shared/static/app_colors.dart';

class CardFormField extends StatefulWidget {
  final String title;
  TypeCardTextForm? type = TypeCardTextForm.text;
  final String hint;
  final Function(String)? onComplete;
  final TextInputFormatter? mask;
  final NumberFormat? format;
  final Icon? icon;
  final TextEditingController controller;
  final FocusNode focus;
  CardFormField(
      {super.key,
      required this.title,
      this.onComplete,
      this.mask,
      this.type,
      this.format,
      this.icon,
      required this.hint,
      required this.controller, required this.focus});

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
              validator: (text) {
                if (text == null) return 'This field cannot be empty';
                if (text.isEmpty) return 'This field cannot be empty';
                if (text.trim().isEmpty) return 'This field cannot be empty';
                if (widget.type == TypeCardTextForm.amount) {
                  final newText = text.replaceAll('\$ ', '').replaceAll(',', '');
                  if (double.tryParse(newText) == 0.0) {
                    return 'Amount cannot be \$ 0.0';
                  } else if (double.tryParse(newText) == null) {
                    return 'Invalid amount';
                  } 
                }
                if (widget.type == TypeCardTextForm.time) {
                  final newText = text.replaceAll(':', '');
                  if (newText.length < 4) return 'Invalid time.';
                  if (int.tryParse(newText) == null) {
                    return 'Time cannot be empty';
                  }
                  if (int.parse(newText) > 2359) return 'Invalid time.';
                  if (int.tryParse(newText.split('').getRange(2, 4).join('')) !=
                          null &&
                      (int.tryParse(
                                  newText.split('').getRange(2, 4).join('')) ??
                              60) >
                          59) return 'Invalid time.';
                }
                return null;
              },
              controller: widget.controller,
                      focusNode: widget.focus,
              onTap: () {
                FocusScope.of(context).requestFocus();
              },
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
