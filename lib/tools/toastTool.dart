import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

///web端的位置和背景颜色需要重新设置，如webPosition｜ webBgColor
void showSuccessToast(String text) {
  Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.TOP,
    backgroundColor: Colors.green,
    fontSize: 14.0,
    webPosition: 'center',
    webBgColor: 'linear-gradient(0deg,#37ecba 0%, #72afd3 100%)',
  );
}

void showFailedToast(String text) {
  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: Colors.red,
      fontSize: 14.0,
      webPosition: 'center',
      webBgColor: 'linear-gradient(0deg,#f43b47 0%, #453a94 100%)');
}
