import 'package:flutter/material.dart';
import 'package:processo_seletivo_onfly/shared/static/app_colors.dart';
import 'package:processo_seletivo_onfly/shared/widgets/card_task_widget.dart';
import 'package:processo_seletivo_onfly/shared/widgets/custom_base_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.minWidth * .1),
              child: Image.asset(
                'assets/images/logo-01.webp',
                width: size.minWidth * .23,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(size.maxWidth * .07),
              child: Material(
                elevation: 10,
                color: Colors.white,
                borderRadius: BorderRadius.circular(size.maxWidth * .1),
                child: TextFormField(
                  onTapOutside: (detail) => FocusScope.of(context).unfocus(),
                  cursorColor: AppColors.blue,
                  style: const TextStyle(
                      fontFamily: 'Poppins', color: Colors.black),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                      hintText: 'Type here',
                      hintStyle:
                          TextStyle(fontFamily: 'Poppins', color: Colors.grey)),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.minWidth * .1),
              child: Text(
                'Today',
                style: TextStyle(
                    fontFamily: 'Poppins-Bold',
                    color: Colors.grey,
                    fontSize: size.minWidth * .05),
              ),
            ),
            CardTaskWidget(),
            CardTaskWidget(),
            CardTaskWidget(),
            CardTaskWidget(),
            CardTaskWidget(),
            CardTaskWidget(),
          ],
        ),
      ),
    );
  }
}
