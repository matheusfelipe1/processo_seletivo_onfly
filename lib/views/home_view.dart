import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:processo_seletivo_onfly/shared/enum/card_enum.dart';
import 'package:processo_seletivo_onfly/shared/enum/states_enum.dart';
import 'package:processo_seletivo_onfly/shared/extensions/app_extensions.dart';
import 'package:processo_seletivo_onfly/shared/routes/app_paths.dart';
import 'package:processo_seletivo_onfly/shared/static/app_colors.dart';
import 'package:processo_seletivo_onfly/shared/widgets/card_datetime_widget.dart';
import 'package:processo_seletivo_onfly/shared/widgets/card_task_widget.dart';
import 'package:processo_seletivo_onfly/shared/widgets/custom_base_widget.dart';

import '../models/expense/expense_model.dart';
import '../shared/animations/animation_shimmer.dart';
import '../viewmodels/home_viewmodel.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with AutomaticKeepAliveClientMixin {
  late final HomeViewModel controller;
  final _text = TextEditingController();

  List<Widget> listForAnimations = List.generate(10, (index) {
    return AnimationShimmer(
      isAnimating: true,
      child: CardTaskWidget(expense: ExpenseModel()),
    );
  });

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Get.put(HomeViewModel());
    controller.updateContext = () {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {});
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomBaseWidget(
      builder: (size) => Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
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
                    controller: _text,
                    onChanged: (text) => controller.onFiltering(text),
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
                        hintStyle: TextStyle(
                            fontFamily: 'Poppins', color: Colors.grey)),
                  ),
                ),
              ),
              SizedBox(
                height: size.maxHeight * .75,
                child: RefreshIndicator(
                    onRefresh: () async => controller.getAll(true),
                    child: Obx(
                  () =>  SizedBox(child: (() {
                        switch (controller.state.value) {
                          case StateScreen.waiting:
                            return ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: listForAnimations.length,
                                itemBuilder: (_, index) =>
                                    listForAnimations[index]);
                          case StateScreen.hasData:
                            return ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: controller.expensesList.length,
                                itemBuilder: (_, index) => (() {
                                      switch (index == 0 || controller.expensesList
                                          .showDateHere(index)) {
                                        case true:
                                          return Column(
                                            children: [
                                              CardDateTime(
                                                  size: size,
                                                  date: controller
                                                          .expensesList[index]
                                                          .expenseDate ??
                                                      ''),
                                              InkWell(
                                                onTap: () => Get.toNamed(
                                                    AppPaths.details,
                                                    arguments: controller
                                                        .expensesList[index].id),
                                                child: CardTaskWidget(
                                                  expense: controller
                                                      .expensesList[index],
                                                  onDelete: (id) =>
                                                      controller.delete(id),
                                                ),
                                              )
                                            ],
                                          );
                                        default:
                                          return InkWell(
                                            onTap: () => Get.toNamed(
                                                AppPaths.details,
                                                arguments: controller
                                                    .expensesList[index].id),
                                            child: CardTaskWidget(
                                              expense:
                                                  controller.expensesList[index],
                                              onDelete: (id) =>
                                                  controller.delete(id),
                                            ),
                                          );
                                      }
                                    }()));
                                      
                          default:
                            return Center(
                              child: Text(
                                'Nobody task was founded',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: size.minWidth * .05),
                              ),
                            );
                        }
                      })()),
                    ),
                  ),
                ),
              
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.blue,
          onPressed: () {
            Get.toNamed(AppPaths.details);
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
