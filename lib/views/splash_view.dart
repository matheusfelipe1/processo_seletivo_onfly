import 'package:flutter/material.dart';
import 'package:processo_seletivo_onfly/shared/widgets/custom_base_widget.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  Widget build(BuildContext context) {
    return CustomBaseWidget(
      builder: (size) => Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Image.asset('assets/images/logo-01.webp'),
        ),
      ),
    );
  }
}
