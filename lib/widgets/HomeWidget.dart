import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:spending_manager/util/dbTool.dart';
import 'package:spending_manager/widgets/AnalyzeWidget.dart';
import 'package:spending_manager/widgets/CalendarWidget.dart';
import 'package:spending_manager/widgets/SettingsWidget.dart';
import 'package:spending_manager/widgets/SpendWidget.dart';
import 'package:carbon_icons/carbon_icons.dart';

class HomeWidget extends StatefulWidget {
  final BuildContext parentCtx;
  late Datastore datastore;

  HomeWidget({Key? key, required this.parentCtx, required this.datastore});

  // current = 4 해야지, 언어 바꿀때, 선택이 설정으로 된다.
  static int _currentIndex = 3;

  static void changePage(BuildContext context, int ind) async {
    _HomeState? state = context.findAncestorStateOfType<_HomeState>();
    if (state != null) state.onTabTapped(ind);
  }

  @override
  State createState() => _HomeState();
}

class _HomeState extends State<HomeWidget> {
  final List<Widget> screens = [];

//  DatabaseHelper dbHelper = DatabaseHelper();
  final pageController = PageController(initialPage: 0);
  bool ready = false;
  String? username = "";

  @override
  void initState() {
    super.initState();
    HomeWidget._currentIndex = 0;
  }

  List<Widget> _children() => [
        SpendWidget(datastore: widget.datastore),
        CalendarWidget(datastore: widget.datastore),
        AnalyzeWidget(datastore: widget.datastore),
        SettingsWidget(datastore: widget.datastore),
      ];

  changePage(int index) {
    setState(() {
      HomeWidget._currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    return MediaQuery(
        data: mediaQueryData.copyWith(textScaleFactor: 1.0),
        child: Scaffold(
            body: PageView(
                onPageChanged: (index) {
                  FocusScope.of(context).unfocus();
                  changePage(index);
                },
                controller: pageController,
                children: _children()),
            bottomNavigationBar: SizedBox(
              height: 64,
              child: BottomNavigationBar(
                selectedItemColor: Colors.black,
                unselectedItemColor: Colors.grey.shade500,
                type: BottomNavigationBarType.fixed,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                onTap: onTabTapped,
                // new
                currentIndex: HomeWidget._currentIndex,
                // new
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(
                        FluentIcons.money_hand_24_regular,
                        size: 32,
                      ),
                      label: "Spend"),
                  BottomNavigationBarItem(
                      icon: Icon(
                        FluentIcons.calendar_rtl_32_regular,
                        size: 32,
                      ),
                      label: "Calendar"),
                  BottomNavigationBarItem(
                      icon: Icon(
                        FluentIcons.chart_multiple_24_regular,
                        size: 32,
                      ),
                      label: "Analyze"),
                  BottomNavigationBarItem(
                      icon: Icon(
                        FluentIcons.settings_24_regular,
                        size: 32,
                      ),
                      label: "1"),
                ],
              ),
            )));
  }

  void onTabTapped(int index) {
    setState(() {
      HomeWidget._currentIndex = index;
      pageController.animateToPage(HomeWidget._currentIndex,
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
    });
  }
}
