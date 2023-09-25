import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:processo_seletivo_onfly/core/provider/controllers/provider_controller.dart';
import 'package:processo_seletivo_onfly/shared/static/app_colors.dart';
import 'package:processo_seletivo_onfly/shared/utils/internet_info.dart';
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
  final focusDesc = FocusNode();
  final focusAmount = FocusNode();
  final focusTime = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Get.put(DetailsViewModel(widget.id));
    controller.updateContext = () => setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    ProividerController().onDisposeDetails();
  }

  @override
  Widget build(BuildContext context) {
    return CustomBaseWidget(
        builder: (size) => KeyboardVisibilityBuilder(
          builder: (context, isVisible) => Scaffold(
                backgroundColor: Colors.transparent,
                body: SizedBox(
                  height: isVisible ? size.maxHeight * .55 : size.maxHeight,
                  child: Form(
                    onChanged: () {
                      controller.validValues();
                      InternetInfo.removeSnackbar;
                    },
                    key: key,
                    child: SingleChildScrollView(
                       physics: const BouncingScrollPhysics(
                                  parent: AlwaysScrollableScrollPhysics()),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: size.maxHeight * .08,
                          ),
                          SizedBox(
                            width: size.maxWidth,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
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
                                  SizedBox(width: size.maxWidth * .085,),
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
                            ),
                          ),
                          SizedBox(
                            height: size.maxHeight * .05,
                          ),
                          CardFormField(
                            title: 'Description',
                            focus: focusDesc,
                            hint: 'Ex.: Have lunch',
                            controller: controller.description,
                          ),
                          CardFormField(
                            hint: 'Ex.: 5.00',
                            focus: focusAmount,
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
                                  focus: focusTime,
                                  hint: 'HH:mm',
                                  title: 'Time',
                                  type: TypeCardTextForm.time,
                                  icon: const Icon(Icons.alarm),
                                  mask: MaskTextInputFormatter(mask: '##:## H'),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: size.maxHeight * .3,)
                        ],
                      ),
                    ),
                  ),
                ),
                bottomSheet: Padding(
                  padding: EdgeInsets.all(size.maxWidth * .03),
                  child: SizedBox(
                    width: double.maxFinite,
                    height: size.maxWidth * .12,
                    child: Obx(
                      () => Material(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        color: !controller.validForm.value
                              ? Colors.grey: AppColors.blue,
                        child: InkWell(
                          onTap: !controller.validForm.value
                              ? null
                              : () {
                                  if (key.currentState?.validate() ?? false) {
                                    controller.registerOrEdit();
                                  }
                                },
                          child: Center(
                            child: Text(controller.id == null ? 'Register' : 'Edit',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: size.maxWidth * .05)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
        ));
  }
}
