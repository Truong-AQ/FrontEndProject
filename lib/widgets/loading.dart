import 'package:flutter/material.dart';
import 'package:project/resources/colors.dart';
import 'package:project/resources/dimens.dart';
import 'package:project/util/variable.dart';

class Loading extends StatefulWidget {
  Loading({this.backgroundColor});
  final Color backgroundColor;
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();
    gifLoading.evict();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor ?? color2.withAlpha(dimen7),
      body: Center(
        child: Column(children: [
          SizedBox(height: 80),
          Image(image: gifLoading),
          SizedBox(height: 15),
          Text('Dữ liệu đang được tải đừng nóng ...',
              style: TextStyle(fontFamily: 'monospace', fontSize: 16))
        ]),
      ),
    );
  }
}
