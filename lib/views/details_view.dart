import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:processo_seletivo_onfly/shared/static/app_colors.dart';
import 'package:processo_seletivo_onfly/shared/widgets/card_date_widget.dart';

import '../shared/widgets/card_form_field.dart';
import '../shared/widgets/custom_base_widget.dart';

class DetailsView extends GetView {
  DetailsView({super.key});
  final format = NumberFormat('###.0#', 'en_US');

  @override
  Widget build(BuildContext context) {
    return CustomBaseWidget(
        builder: (size) => Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.maxHeight * .08,
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.navigate_before_rounded)),
                      Text(
                        'Coffee',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: size.maxWidth * .055),
                      ),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.minWidth * .1),
                        child: Image.asset(
                          'assets/images/logo-01.webp',
                          width: size.minWidth * .23,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.maxHeight * .05,
                  ),
                  const CardFormField(
                    title: 'Description',
                    hint: 'Ex.: Have lunch',
                  ),
                  CardFormField(
                    hint: 'Ex.: 5.00',
                    title: 'Amount',
                    mask: CurrencyTextInputFormatter(
                      locale: 'en_US',
                      decimalDigits: 0,
                      symbol: '\$ ',
                    ),
                  ),
                  Wrap(
                    children: [
                      SizedBox(
                          width: size.maxWidth * .55,
                          child: const CardDateField(title: 'Date')),
                      SizedBox(
                        width: size.maxWidth * .45,
                        child: CardFormField(
                          hint: 'HH:mm',
                          title: 'Time',
                          icon: const Icon(Icons.alarm),
                          mask: MaskTextInputFormatter(mask: '##:## H'),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              bottomSheet:  Padding(
                padding: EdgeInsets.all(size.maxWidth * .03),
                child: SizedBox(
                  width: double.maxFinite,
                  height: size.maxWidth * .12,
                  child: Material(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        color: AppColors.blue,
                        child: InkWell(
                          onTap: () => Get.back(result: 'Yes'),
                          child: Center(
                            child: Text('Register',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: size.maxWidth * .05)),
                          ),
                        ),
                      ),
                ),
              ),
            ));
  }
}
