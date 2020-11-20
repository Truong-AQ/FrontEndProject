import 'package:flutter/material.dart';
import 'package:project/resources/strings.dart';
import 'package:project/util/function/logout.dart';
import 'package:project/widgets/show_error.dart';

void showDialogOfApp(BuildContext context, {String error, Function onRetry}) {
  if (error == noNetwork)
    _showDialogNoNetwork(context, onRetry);
  else if (error == cookieExpired)
    _showDialogLogout(context);
  else if (error == wrongLogin || error == missLogin)
    _showDialogWarningAccount(context, error);
  else if (error == clientError) _showDialogClientError(context, onRetry);
}

void _showDialogClientError(BuildContext context, Function onRetry) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ShowError(error: clientError, actions: [
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
      builder: (context) => ShowError(error: error, actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'))
          ]));
}

void _showDialogLogout(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ShowError(error: cookieExpired, actions: [
            TextButton(
                onPressed: () {
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
      builder: (context) => ShowError(error: noNetwork, actions: [
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
