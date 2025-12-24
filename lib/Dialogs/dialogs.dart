import 'package:flutter/material.dart';

class Dialogs {
  static bool isShow = false;
  static void showAlert(String message, BuildContext context) {
    if (isShow) return;
    isShow = true;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message))).closed.then((_) {
      isShow = false;
    });
  }

  static void showPrograssBar(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Center(child: CircularProgressIndicator()),
    );
  }
}
