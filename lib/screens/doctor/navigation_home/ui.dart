import 'package:flutter/material.dart';
import 'package:project/resources/strings.dart';
import 'package:project/screens/doctor/group/ui.dart';
import 'package:project/util/function/logout.dart';
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
            drawer: _buildDrawer(context),
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

  Widget _buildDrawer(BuildContext context) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(children: [
        Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(bottom: 0, top: 70),
            child: Image.asset(urlIconProfile, scale: 128 / 150)),
        Container(
            padding: EdgeInsets.all(14),
            margin: EdgeInsets.only(top: 15),
            child: Selector<NavigationHomeData, String>(
              selector: (_, dt) => dt.name,
              builder: (_, name, __) {
                return Text(name ?? "",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: 'monospace'));
              },
            )),
        GestureDetector(
          onTap: () async {
            logout();
          },
          child: Container(
            padding: EdgeInsets.all(14),
            width: 250,
            color: Colors.grey,
            margin: EdgeInsets.symmetric(vertical: 15),
            child: Text('Đăng xuất',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: 'monospace')),
          ),
        )
      ]),
    );
  }

  Widget _buildBottomNavigationBar(int index, BuildContext context) {
    return BottomNavigationBar(
        currentIndex: index,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Nhóm'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Bài'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'Người làm bài'),
          // BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Kết quả')
        ],
        onTap: (tabIndex) {
          context.read<NavigationHomeController>().updateTabIndex(tabIndex);
        });
  }

  final List<GlobalKey<NavigatorState>> _navigatorKeys =
      List.generate(3, (index) => GlobalKey());
  final List<Widget> _widgets = [
    Group.withDependency(),
    Container(),
    Container(),
    // Container()
  ];
}
