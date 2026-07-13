import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import '../errors/failures.dart';

void showFailureToast(Failure failure) {
  toastification.show(
    type: failure is NetworkFailure
        ? ToastificationType.warning
        : ToastificationType.error,
    style: ToastificationStyle.flatColored,
    title: Text(failure.message),
    autoCloseDuration: const Duration(seconds: 3),
  );
}

void showErrorToast(String message) {
  showFailureToast(
    message == const NetworkFailure().message
        ? const NetworkFailure()
        : UnexpectedFailure(message),
  );
}

void showSuccessToast(String message) {
  toastification.show(
    type: ToastificationType.success,
    style: ToastificationStyle.flatColored,
    title: Text(message),
    autoCloseDuration: const Duration(seconds: 3),
  );
}

void showInfoToast(String message) {
  toastification.show(
    type: ToastificationType.info,
    style: ToastificationStyle.flatColored,
    title: Text(message),
    autoCloseDuration: const Duration(seconds: 3),
  );
}
