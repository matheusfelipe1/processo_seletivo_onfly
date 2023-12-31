import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:intl/intl.dart';
import 'package:processo_seletivo_onfly/models/expense/expense_model.dart';

class CardTaskWidget extends StatefulWidget {
  final ExpenseModel expense;
  final Function(String id)? onDelete;
  const CardTaskWidget({super.key, required this.expense, this.onDelete});

  @override
  State<CardTaskWidget> createState() => _CardTaskWidgetState();
}

class _CardTaskWidgetState extends State<CardTaskWidget> {
  void _showBottomSheet() async {
    final size = MediaQuery.of(context).size;
    final result = await showModalBottomSheet<String?>(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        context: context,
        showDragHandle: true,
        enableDrag: true,
        builder: (context) => SizedBox(
              height: size.width * .5,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(size.width * .05),
                    child: Text('Are you sure you want to delete this expense?',
                        style: TextStyle(
                            fontFamily: 'Poppins', fontSize: size.width * .05)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(size.width * .05),
                    child: SizedBox(
                      width: double.maxFinite,
                      height: size.width * .1,
                      child: Material(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        color: Colors.red,
                        child: InkWell(
                          onTap: () => Get.back(result: 'Yes'),
                          child: Center(
                            child: Text('Yes',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: size.width * .05)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ));
    if (result == null) {
      setState(() {});
    } else {
      widget.onDelete?.call(widget.expense.id ?? '');
    }
  }

  final numberFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$ ');
  final timeFormat = DateFormat("HH:mm 'h'");
  String showTime = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final date = DateTime.tryParse(widget.expense.expenseDate ?? '');
    if (date != null) {
      showTime = timeFormat.format(date);
    }
  }

  @override
  void didUpdateWidget(covariant CardTaskWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    final date = DateTime.tryParse(widget.expense.expenseDate ?? '');
    if (date != null) {
      showTime = timeFormat.format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: size.width * .035),
      child: SizedBox(
        width: size.width,
        height: size.width * .2,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * .05),
          child: Dismissible(
            key: GlobalKey(),
            direction: DismissDirection.startToEnd,
            confirmDismiss: (direction) async {
              return true;
            },
            onDismissed: (direction) {
              _showBottomSheet();
            },
            dragStartBehavior: DragStartBehavior.start,
            background: Container(
              width: size.width,
              height: size.width * .2,
              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(size.width * .02)),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        _showBottomSheet();
                      },
                      icon: const Icon(FontAwesomeIcons.trash)),
                  const Text('Delete expense',
                      style: TextStyle(fontFamily: 'Poppins'))
                ],
              ),
            ),
            child: Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(size.width * .02),
              child: Stack(
                children: [
                  Positioned(
                      top: size.width * .06,
                      left: size.width * .03,
                      child: const Icon(Icons.task_alt_outlined)),
                  Positioned(
                      top: size.width * .03,
                      left: size.width * .14,
                      child: Text(
                        widget.expense.description ?? '',
                        style: const TextStyle(fontFamily: 'Poppins-Bold'),
                      )),
                  Positioned(
                      top: size.width * .1,
                      left: size.width * .14,
                      child: Text(
                        numberFormat.format(widget.expense.amount ?? 0),
                        style: const TextStyle(fontFamily: 'Poppins'),
                      )),
                  Positioned(
                      top: size.width * .1,
                      right: size.width * .07,
                      child: Text(
                        showTime,
                        style: const TextStyle(
                            fontFamily: 'Poppins',
                            color: Color.fromARGB(255, 205, 205, 205)),
                      )),
                  Positioned(
                      top: size.width * .03,
                      right: size.width * .07,
                      child: Icon(
                        (widget.expense.notSynchronized ?? true)
                            ? Icons.sync_problem_rounded
                            : Icons.cloud_sync_rounded,
                        color: (widget.expense.notSynchronized ?? true)
                            ? Colors.red
                            : Colors.green,
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
