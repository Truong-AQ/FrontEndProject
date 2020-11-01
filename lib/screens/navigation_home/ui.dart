import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/resources/app_context.dart';
import 'package:project/screens/home/ui.dart';
import 'package:provider/provider.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:project/screens/navigation_home/controller.dart';
import 'package:project/screens/register/ui.dart';
import 'package:project/screens/search/ui.dart';

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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
          BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded), label: 'Search')
        ],
        onTap: (tabIndex) {
          context.read<NavigationHomeController>().updateTabIndex(tabIndex);
        });
  }

  final List<GlobalKey<NavigatorState>> _navigatorKeys =
      List.generate(3, (index) => GlobalKey());
  final List<Widget> _widgets = [
    Home.withDependency(),
    Register.withDependency(),
    Search.withDependency()
  ];
}
