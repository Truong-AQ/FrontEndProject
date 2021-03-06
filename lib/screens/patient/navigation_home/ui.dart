import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/util/variable.dart';
import 'package:project/screens/patient/exercise/ui.dart';
import 'package:project/screens/patient/result/ui.dart';
import 'package:project/screens/patient/study/ui.dart';
import 'package:provider/provider.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:project/screens/patient/navigation_home/controller.dart';

import 'data.dart';

// ignore: must_be_immutable
class NavigationHome extends StatelessWidget {
  static withDependency() {
    return StateNotifierProvider<NavigationHomeController, NavigationHomeData>(
        create: (context) {
          contextHome = context;
          return NavigationHomeController();
        },
        child: NavigationHome());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationHomeData>(builder: (_, dt, __) {
      return WillPopScope(
        onWillPop: () async {
          final isFirstInCurrentTab =
              !await _navigatorKeys[context.read<NavigationHomeData>().tabIndex]
                  .currentState
                  .maybePop();
          return isFirstInCurrentTab;
        },
        child: Scaffold(
            body: IndexedStack(
                children: List.generate(
                    _widgets.length,
                    (index) => Navigator(
                        key: _navigatorKeys[index],
                        onGenerateRoute: (route) => MaterialPageRoute(
                              builder: (_) => _widgets[index],
                            ))),
                index: dt.tabIndex),
            bottomNavigationBar:
                _buildBottomNavigationBar(dt.tabIndex, context)),
      );
    });
  }

  Widget _buildBottomNavigationBar(int index, BuildContext context) {
    return BottomNavigationBar(
        currentIndex: index,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Bài tập'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), label: 'Kết quả'),
          BottomNavigationBarItem(icon: Icon(Icons.label), label: 'Học tập')
        ],
        onTap: (tabIndex) {
          if (tabIndex == 1 && _widgets[tabIndex] is Container) {
            _widgets[1] = Result.withDependency();
          } else if (tabIndex == 2 && _widgets[tabIndex] is Container) {
            _widgets[2] = Study.withDependency();
          }
          context.read<NavigationHomeController>().updateTabIndex(tabIndex);
        });
  }

  final List<GlobalKey<NavigatorState>> _navigatorKeys =
      List.generate(3, (index) => GlobalKey());
  final List<Widget> _widgets = [
    Exercise.withDependency(),
    Container(),
    Container(),
  ];
}
