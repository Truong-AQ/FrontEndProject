import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:project/resources/app_context.dart';
import 'package:project/resources/strings.dart';
import 'package:project/screens/exercise/controller.dart';
import 'package:project/screens/login/ui.dart';
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
        var visiblePercentage = info.visibleFraction * 100;

        if (visiblePercentage == 0.0) {
          try {
            context.read<ExerciseController>().stopPolling();
          } on Error catch (_) {}
        } else if (visiblePercentage == 100.0)
          context.read<ExerciseController>().startPolling();
      },
      child: Stack(
        children: [
          Scaffold(
              drawer: _buildDrawer(context),
              appBar: AppBar(
                  title: Text('Bài kiểm tra của tôi'), centerTitle: true),
              body: SingleChildScrollView(
                child: Container(
                    margin: EdgeInsets.only(top: 15, left: 12, right: 12),
                    child: Column(children: [
                      _buildExercise(),
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
            margin: EdgeInsets.only(bottom: 0, top: 70),
            child:
                Image.asset('assets/images/ic_profile.png', scale: 128 / 150)),
        Container(
            padding: EdgeInsets.all(14),
            margin: EdgeInsets.only(top: 15),
            child: Selector<ExerciseData, String>(
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
            SharedPreferences pref = await SharedPreferences.getInstance();
            cookie = '';
            pref.setString('cookie', '');
            context.read<ExerciseController>().stopPolling();
            Navigator.pushReplacement(contextHome,
                MaterialPageRoute(builder: (_) => Login.withDependency()));
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

  Widget _buildExercise() {
    return Selector<ExerciseData, List>(
      selector: (_, dt) => dt.test,
      builder: (context, test, __) {
        if (test.length == 0) return Container();
        return Column(children: [
          SizedBox(height: 10),
          for (int i = 0; i < test.length; i++)
            _buildExerciseItem(context,
                text: context.select((ExerciseData dt) => dt.test[i]).label,
                time: context.select((ExerciseData dt) => dt.test[i].time),
                link: context.select((ExerciseData dt) => dt.test[i].link),
                isProcess:
                    context.select((ExerciseData dt) => dt.test[i]).isProcess,
                numAttempt:
                    context.select((ExerciseData dt) => dt.test[i].numAttempts))
        ]);
      },
    );
  }

  Widget _buildExerciseItem(BuildContext context,
      {String text,
      String time,
      String link,
      bool isProcess,
      String numAttempt}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(color: Colors.blue.withAlpha(30)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(text, style: TextStyle(fontFamily: 'monospace')),
        SizedBox(height: 4),
        time != null
            ? Text(time,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w600))
            : SizedBox(height: 0),
        if (time != null) SizedBox(height: 4),
        numAttempt != null
            ? Text(numAttempt,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w600))
            : SizedBox(height: 0),
        SizedBox(height: 4),
        Row(children: [
          Spacer(),
          GestureDetector(
            onTap: () async {
              if (link == '#') return;
              await Navigator.push(
                  contextHome,
                  MaterialPageRoute(
                      builder: (_) => Test.withDependency(url: link)));
              context.read<ExerciseController>().stopPolling();
              await context.read<ExerciseController>().initTests();
              context.read<ExerciseController>().startPolling();
            },
            child: Container(
                padding: EdgeInsets.all(7),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: link == '#'
                        ? Colors.grey
                        : (isProcess ? Colors.pink : Colors.greenAccent)),
                child: Text(
                    link == '#'
                        ? 'HOÀN THÀNH'
                        : (isProcess ? 'TIẾP TỤC' : 'BẮT ĐẦU'),
                    style: TextStyle(color: Colors.white, fontSize: 12))),
          )
        ])
      ]),
    );
  }
}
