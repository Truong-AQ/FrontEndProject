import 'package:flutter/material.dart';
import 'package:project/resources/strings.dart';
import 'package:project/screens/patient/test/ui.dart';
import 'package:project/util/function/logout.dart';
import 'package:project/widgets/show_error.dart';

void showDialogOfApp(BuildContext context,
    {String error,
    Function onRetry,
    Function onNext,
    Type typeWidgetCurrent,
    String message}) {
  if (error == noNetwork)
    _showDialogNoNetwork(context, onRetry);
  else if (error == cookieExpiredApp)
    _showDialogLogout(context, typeWidgetCurrent);
  else if (error == wrongLogin ||
      error == missLogin ||
      error == errorRoleApp ||
      error == noMatchPassword ||
      error == passwordNoValid ||
      error == userExist)
    _showDialogWarningAccount(context, error);
  else if (error == clientError)
    _showDialogClientError(context, onRetry);
  else if (message != null) _showDialogMsg(context, message, onNext);
}

void _showDialogMsg(BuildContext context, String message, Function onNext) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ShowErrorOrMsg(msg: message, actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (onNext != null) onNext();
                },
                child: Text('OK'))
          ]));
}

void _showDialogClientError(BuildContext context, Function onRetry) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ShowErrorOrMsg(error: clientError, actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK')),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  onRetry();
                },
                child: Text('Thử lại'))
          ]));
}

void _showDialogWarningAccount(BuildContext context, String error) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ShowErrorOrMsg(error: error, actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'))
          ]));
}

void _showDialogLogout(BuildContext context, Type typeWidgetCurrent) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ShowErrorOrMsg(error: cookieExpiredApp, actions: [
            TextButton(
                onPressed: () {
                  if (typeWidgetCurrent == Test) Navigator.pop(context);
                  Navigator.pop(context);
                  logout();
                },
                child: Text('Đăng xuất'))
          ]));
}

void _showDialogNoNetwork(BuildContext context, Function onRetry) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ShowErrorOrMsg(error: noNetwork, actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK')),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  onRetry();
                },
                child: Text('Thử lại'))
          ]));
}
