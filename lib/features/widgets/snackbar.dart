import 'package:flutter/material.dart';
import 'package:get/get.dart';

SnackbarController successSnackbar({required String msg}) {
  return Get.snackbar(
    'Success',
    msg,
    borderRadius: 8,
    colorText: Color(0XFFD9D9D9),
    backgroundColor: Color(0x3E009345),
    margin: EdgeInsets.only(top: 10, left: 10, right: 10),
  );
}

SnackbarController errorSnackbar({required String msg}) {
  return Get.snackbar(
    'Error',
    msg,
    borderRadius: 8,
    colorText: Color(0XFFD9D9D9),
    backgroundColor: Color(0x3EEC1C24),
    margin: EdgeInsets.only(top: 10, left: 10, right: 10),
  );
}
