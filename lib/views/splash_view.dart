import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:processo_seletivo_onfly/shared/widgets/custom_base_widget.dart';
import 'package:processo_seletivo_onfly/viewmodels/splash_viewmodel.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  late final SplashViewModel controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(SplashViewModel());
    controller.controller = AnimationController(
      animationBehavior: AnimationBehavior.normal,
        vsync: this, duration: const Duration(milliseconds: 1000));
    controller.animate =
        Tween<Offset>(begin: const Offset(170, 0), end: Offset.zero)
            .animate(controller.controller);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.onAnimatedFinish();
      controller.notifyAction = udpatedScreenToAnimate;
    });
  }

  void udpatedScreenToAnimate() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomBaseWidget(
      builder: (size) => Scaffold(
        backgroundColor: Colors.transparent,
        body: AnimatedContainer(
          alignment: Alignment.center,
          duration: const Duration(milliseconds: 50),
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.01)
            ..translate(
                controller.animate.value.dx, controller.animate.value.dy),
          child: Image.asset('assets/images/logo-01.webp'),
        ),
      ),
    );
  }
}
