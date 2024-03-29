import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:spending_manager/dbModels/spending_entry_model.dart';
import 'package:spending_manager/util/dbTool.dart';
import 'package:spending_manager/widgets/AnalyzePages/SpendingByCategoryWidget.dart';
import 'package:spending_manager/widgets/AnalyzePages/AverageSpendingWidget.dart';
import 'package:spending_manager/widgets/AnalyzePages/TargetSpendingWidget.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:spending_manager/widgets/analyzePages/AccountAmountWidget.dart';

class AnalyzeWidget extends StatefulWidget {
  late Datastore datastore;

  AnalyzeWidget({Key? key, required this.datastore}) : super(key: key);

  @override
  State createState() => _AnalyzeState();
}

class _AnalyzeState extends State<AnalyzeWidget> {
  DateTime datetime = DateTime.now();
  List<SpendingEntry> spendingList = [];
  List<SpendingEntry> monthlyList = [];
  int _currentIndex = 0;

  final pageController = PageController(initialPage: 0);

  changePage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    spendingList = widget.datastore.spendingList;

    processNow();
  }

  void processNow() {
    DateTime start = DateTime(datetime.year, datetime.month, 1);
    DateTime end = (datetime.month < 12)
        ? DateTime(datetime.year, datetime.month + 1, 1)
        : DateTime(datetime.year + 1, 1, 1);

    // Get Monthly Spending list on Change
    monthlyList = widget.datastore.spendingList
        .where((element) =>
            element.dateTime >= start.millisecondsSinceEpoch &&
            element.dateTime < end.millisecondsSinceEpoch)
        .toList();
  }

  Widget monthSelector() {
    return SizedBox(
        height: 70,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      datetime = DateTime(
                          datetime.year, datetime.month - 1, datetime.day);
                      processNow();
                      setState(() {});
                    },
                    icon: const Icon(CarbonIcons.chevron_left)),
                Column(
                  children: [
                    Text(
                      datetime.month.toString(),
                      style: const TextStyle(fontSize: 22),
                    ),
                    Text(
                      datetime.year.toString(),
                      style:
                          const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
                IconButton(
                    onPressed: () {
                      datetime = DateTime(
                          datetime.year, datetime.month + 1, datetime.day);
                      processNow();
                      setState(() {});
                    },
                    icon: const Icon(CarbonIcons.chevron_right))
              ],
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: SizedBox(
              width: mediaQueryData.size.width,
              height: mediaQueryData.size.height - 64,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: mediaQueryData.viewPadding.top + 20,
                  ),
                  monthSelector(),
                  Expanded(
                    child: PageView(
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (index) {
                        FocusScope.of(context).unfocus();
                        changePage(index);
                      },
                      controller: pageController,
                      children: [
                        AccountAmountWidget(
                            key: UniqueKey(),
                            datastore: widget.datastore,
                            monthlyList: monthlyList),
                        SpendingByCategoryWidget(
                            key: UniqueKey(),
                            datastore: widget.datastore,
                            monthlyList: monthlyList),
                        TargetSpendingWidget(
                            key: UniqueKey(),
                            datastore: widget.datastore,
                            monthlyList: monthlyList),
                        AverageSpendingWidget(
                            key: UniqueKey(),
                            datastore: widget.datastore,
                            monthlyList: monthlyList),
                      ],
                    ),
                  )
                ],
              )),
          bottomNavigationBar: monthlyList.isEmpty
              ? null
              : FloatingNavbar(
                  backgroundColor: Colors.black12,
                  unselectedItemColor: Colors.black38,
                  selectedItemColor: Colors.black87,
                  onTap: (int index) {
                    setState(() {
                      _currentIndex = index;
                      pageController.animateToPage(_currentIndex,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease);
                    });
                  },
                  currentIndex: _currentIndex,
                  items: [
                    FloatingNavbarItem(
                        icon: FluentIcons.album_24_regular, title: 'Accounts'),
                    FloatingNavbarItem(
                        icon: FluentIcons.tag_24_regular, title: 'Category'),
                    FloatingNavbarItem(
                        icon: CarbonIcons.chart_line, title: 'Target'),
                    FloatingNavbarItem(
                        icon: CarbonIcons.account, title: 'Average'),

//              FloatingNavbarItem(icon: CarbonIcons.chart_combo, title: 'Average'),
                  ],
                ),
        ));
  }
}
