import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:processo_seletivo_onfly/shared/static/app_colors.dart';
import 'package:processo_seletivo_onfly/shared/widgets/card_date_widget.dart';

import '../shared/enum/card_enum.dart';
import '../shared/widgets/card_form_field.dart';
import '../shared/widgets/custom_base_widget.dart';
import '../viewmodels/details_viewmodel.dart';

class DetailsView extends StatefulWidget {
  final String? id;
  const DetailsView({super.key, this.id});

  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  final format = NumberFormat('###.0#', 'en_US');
  late final DetailsViewModel controller;
  final formatDate = DateFormat('yyyy/MM/dd');
  final key = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Get.put(DetailsViewModel(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return CustomBaseWidget(
        builder: (size) => Scaffold(
              backgroundColor: Colors.transparent,
              body: Form(
                key: key,
                child: Column(
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
                          widget.id == null ? 'New expense' : 'Details expense',
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
                    CardFormField(
                      title: 'Description',
                      hint: 'Ex.: Have lunch',
                      controller: controller.description,
                    ),
                    CardFormField(
                      hint: 'Ex.: 5.00',
                      controller: controller.amount,
                      title: 'Amount',
                      type: TypeCardTextForm.amount,
                      mask: CurrencyTextInputFormatter(
                        locale: 'en_US',
                        decimalDigits: 2,
                        symbol: '\$ ',
                      ),
                    ),
                    Wrap(
                      children: [
                        SizedBox(
                            width: size.maxWidth * .55,
                            child: CardDateField(
                              title: 'Date',
                              controller: controller.date,
                              onComplete: (val) {
                                if (DateTime.tryParse(val) != null) {
                                  controller.date.text =
                                      formatDate.format(DateTime.parse(val));
                                }
                              },
                            )),
                        SizedBox(
                          width: size.maxWidth * .45,
                          child: CardFormField(
                            controller: controller.time,
                            hint: 'HH:mm',
                            title: 'Time',
                            type: TypeCardTextForm.time,
                            icon: const Icon(Icons.alarm),
                            mask: MaskTextInputFormatter(mask: '##:## H'),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              bottomSheet: Padding(
                padding: EdgeInsets.all(size.maxWidth * .03),
                child: SizedBox(
                  width: double.maxFinite,
                  height: size.maxWidth * .12,
                  child: Material(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    color: controller.amount.text.isEmpty ||
                              controller.description.text.isEmpty ||
                              controller.date.text.isEmpty ||
                              controller.time.text.isEmpty
                          ? Colors.grey: AppColors.blue,
                    child: InkWell(
                      onTap: controller.amount.text.isEmpty ||
                              controller.description.text.isEmpty ||
                              controller.date.text.isEmpty ||
                              controller.time.text.isEmpty
                          ? null
                          : () {
                              if (key.currentState?.validate() ?? false) {
                                controller.registerOrEdit();
                              }
                            },
                      child: Center(
                        child: Text(widget.id == null ? 'Register' : 'Edit',
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
