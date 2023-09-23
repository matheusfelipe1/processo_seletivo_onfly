import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';

class CardTaskWidget extends StatefulWidget {
  const CardTaskWidget({super.key});

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
                    child: Text('Are you sure you want to delete this task?',
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
                  const Text('Delete task',
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
                      child: const Text(
                        'Coffee',
                        style: TextStyle(fontFamily: 'Poppins-Bold'),
                      )),
                  Positioned(
                      top: size.width * .1,
                      left: size.width * .14,
                      child: const Text(
                        'R\$ 10,00',
                        style: TextStyle(fontFamily: 'Poppins'),
                      )),
                  Positioned(
                      top: size.width * .1,
                      right: size.width * .07,
                      child: const Text(
                        '08:00',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Color.fromARGB(255, 205, 205, 205)),
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
