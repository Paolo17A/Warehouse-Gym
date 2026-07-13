import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_warehouse_gym/core/router/app_router.dart';

Future<bool> confirmSkipWarmUp(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Skip warm-up?'),
      content: const Text(
        "You'll go straight to today's exercises without the warm-up routine.",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: const Text('Skip warm-up'),
        ),
      ],
    ),
  );
  return result ?? false;
}

void navigateToCameraWorkout(
  BuildContext context,
  Map<String, dynamic> sessionExtra,
) {
  context.push(AppRouter.cameraWorkout, extra: sessionExtra);
}

void navigateToWarmUp(
  BuildContext context,
  Map<String, dynamic> sessionExtra,
) {
  context.push(AppRouter.warmUp, extra: sessionExtra);
}
