import 'package:flutter/material.dart';
import '../static/app_colors.dart';

class CustomBaseWidget extends StatelessWidget {
  final Widget Function(BoxConstraints) builder;
  const CustomBaseWidget({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        decoration: BoxDecoration(
            gradient:
                LinearGradient(colors: [AppColors.black1, AppColors.black2])),
        child: builder.call(constraints),
      );
    });
  }
}
