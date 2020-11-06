import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:project/resources/app_context.dart';
import 'package:project/resources/strings.dart';
import 'package:project/screens/exercise/controller.dart';
import 'package:project/screens/login/ui.dart';
import 'package:project/screens/profile/ui.dart';
import 'package:project/screens/test/ui.dart';
import 'package:project/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'data.dart';

class Exercise extends StatelessWidget {
  static Widget withDependency() {
    return StateNotifierProvider<ExerciseController, ExerciseData>(
      create: (_) => ExerciseController()
        ..initTests()
        ..startPolling(),
      child: Exercise(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: GlobalKey(),
      onVisibilityChanged: (VisibilityInfo info) {
        var visibilePercentage = info.visibleFraction * 100;
        if (visibilePercentage == 0.0)
          context.read<ExerciseController>().stopPolling();
        else if (visibilePercentage == 100.0)
          context.read<ExerciseController>().startPolling();
      },
      child: Stack(
        children: [
          Scaffold(
              drawer: _buildDrawer(context),
              appBar: AppBar(
                  title: Text('Bai kiem tra cua toi'), centerTitle: true),
              body: SingleChildScrollView(
                child: Container(
                    margin: EdgeInsets.only(top: 15, left: 12, right: 12),
                    child: Column(children: [
                      // _buildExerciseProcess(),
                      _buildExerciseHave()
                    ])),
              )),
          Selector<ExerciseData, bool>(
            selector: (_, dt) => dt.process,
            builder: (_, process, __) {
              return process ? Loading() : Container();
            },
          )
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(children: [
        Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(bottom: 45, top: 70),
            child: Image.asset('assets/images/dish2.png')),
        GestureDetector(
          onTap: () {
            Navigator.push(contextHome,
                MaterialPageRoute(builder: (_) => Profile.withDependency()));
          },
          child: Container(
            padding: EdgeInsets.all(14),
            width: 250,
            color: Colors.grey,
            margin: EdgeInsets.symmetric(vertical: 15),
            child: Text('PROFILE',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: 'monospace')),
          ),
        ),
        GestureDetector(
          onTap: () async {
            SharedPreferences pref = await SharedPreferences.getInstance();
            cookie = '';
            pref.setString('cookie', '');
            Navigator.pushReplacement(contextHome,
                MaterialPageRoute(builder: (_) => Login.withDependency()));
          },
          child: Container(
            padding: EdgeInsets.all(14),
            width: 250,
            color: Colors.grey,
            margin: EdgeInsets.symmetric(vertical: 15),
            child: Text('LOGOUT',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: 'monospace')),
          ),
        )
      ]),
    );
  }

  Widget _buildExerciseProcess() {
    return Selector<ExerciseData, int>(
      selector: (_, dt) => dt.testProcess.length,
      builder: (context, length, __) {
        return Column(children: [
          length > 0
              ? Text('Trong tien trinh: $length',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20))
              : Container(),
          SizedBox(height: 10),
          for (int i = 0; i < length; i++)
            _buildExerciseProcessItem(
                text: context
                    .select((ExerciseData dt) => dt.testProcess)[i]
                    .label,
                time:
                    context.select((ExerciseData dt) => dt.testProcess[i].time))
        ]);
      },
    );
  }

  Widget _buildExerciseHave() {
    return Selector<ExerciseData, int>(
      selector: (_, dt) => dt.testHave.length,
      builder: (context, length, __) {
        return Column(children: [
          length > 0
              ? Text('Co san: $length',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20))
              : Container(),
          SizedBox(height: 10),
          for (int i = 0; i < length; i++)
            _buildExerciseHaveItem(
                text: context.select((ExerciseData dt) => dt.testHave[i].label),
                link: context.select((ExerciseData dt) => dt.testHave[i].link))
        ]);
      },
    );
  }

  Widget _buildExerciseProcessItem({String text, String time}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(color: Colors.blue.withAlpha(30)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(text, style: TextStyle(fontFamily: 'monospace')),
        SizedBox(height: 4),
        Text(time,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
        SizedBox(height: 4),
        Row(children: [
          Spacer(),
          Container(
              padding: EdgeInsets.all(7),
              color: Colors.pink,
              child: Text('TIEP TUC',
                  style: TextStyle(color: Colors.white, fontSize: 12)))
        ])
      ]),
    );
  }

  Widget _buildExerciseHaveItem({String text, String link}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(color: Colors.blue.withAlpha(30)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(text, style: TextStyle(fontFamily: 'monospace')),
        SizedBox(height: 4),
        Row(children: [
          Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  contextHome,
                  MaterialPageRoute(
                      builder: (_) => Test.withDependency(url: link)));
            },
            child: Container(
                padding: EdgeInsets.all(7),
                color: Colors.orange,
                child: Text('BAT DAU',
                    style: TextStyle(color: Colors.white, fontSize: 12))),
          )
        ])
      ]),
    );
  }
}
