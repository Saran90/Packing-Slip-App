import 'dart:math';

import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import 'colors.dart';

int getRandomId() {
  var random = Random();
  int randomNumber = random.nextInt(100);
  return randomNumber;
}

void showToast({required String message, ToastificationType? type}) {
  toastification.dismissAll();
  toastification.show(
    type: type ?? ToastificationType.success,
    style: ToastificationStyle.flat,
    autoCloseDuration: const Duration(seconds: 5),
    title: Text(
      message,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    ),
    alignment: Alignment.topCenter,
    direction: TextDirection.ltr,
    icon: CircleAvatar(
        backgroundColor: type == ToastificationType.success
            ? successMessageIconBackgroundColor
            : redColor,
        radius: 14,
        child: Icon(
          type == ToastificationType.success ? Icons.check : Icons.close,
          color: Colors.white,
          size: 20,
        )),
    showIcon: true,
    backgroundColor: Colors.white,
    foregroundColor: toastTextColor,
    showProgressBar: false,
    closeButtonShowType: CloseButtonShowType.none,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    borderRadius: BorderRadius.circular(16),
    boxShadow: const [
      BoxShadow(
        color: Color(0x07000000),
        blurRadius: 16,
        offset: Offset(0, 16),
        spreadRadius: 0,
      )
    ],
  );
}