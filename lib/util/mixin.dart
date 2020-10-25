import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

mixin PortraitModeMixin on StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return null;
  }
}
