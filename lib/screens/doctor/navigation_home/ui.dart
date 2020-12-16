import 'package:flutter/material.dart';
import 'package:project/screens/doctor/assign_test/ui.dart';
import 'package:project/screens/doctor/group/ui.dart';
import 'package:project/screens/doctor/result/ui.dart';
import 'package:project/screens/doctor/test/ui.dart';
import 'package:project/util/variable.dart';
import 'package:provider/provider.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'controller.dart';
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
        type: BottomNavigationBarType.fixed,
        currentIndex: index,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Bài'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Giao bài'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), label: 'Kết quả'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Nhóm')
        ],
        onTap: (tabIndex) {
          context.read<NavigationHomeController>().updateTabIndex(tabIndex);
          if (tabIndex == 3 && _widgets[tabIndex] is Container) {
            _widgets[3] = Group.withDependency();
          } else if (tabIndex == 2 && _widgets[tabIndex] is Container) {
            _widgets[2] = Result.withDependency();
          } else if (tabIndex == 1 && _widgets[tabIndex] is Container) {
            _widgets[1] = AssignTest.withDependency();
          }
        });
  }

  final List<GlobalKey<NavigatorState>> _navigatorKeys =
      List.generate(4, (index) => GlobalKey());
  final List<Widget> _widgets = [
    Test.withDependency(),
    Container(),
    Container(),
    Container()
  ];
}
