import 'package:flutter/material.dart';

class CardTaskWidget extends StatelessWidget {
  const CardTaskWidget({super.key});

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
          child: Material(
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
                    top: size.width * .04,
                    right: size.width * .07,
                    child: const Text(
                      '22/09/2023',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Color.fromARGB(255, 205, 205, 205)),
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
    );
  }
}
