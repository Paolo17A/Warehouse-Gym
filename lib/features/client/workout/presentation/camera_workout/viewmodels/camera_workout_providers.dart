import 'package:the_warehouse_gym/features/client/workout/presentation/camera_workout/viewmodels/camera_workout_camera_notifier.dart';
import 'package:the_warehouse_gym/features/client/workout/presentation/camera_workout/viewmodels/camera_workout_viewmodel.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

export 'camera_workout_camera_notifier.dart';
export 'camera_workout_viewmodel.dart';

void releaseCameraWorkoutResources(WidgetRef ref) {
  ref.read(cameraWorkoutCameraProvider.notifier).releaseResources();
  ref.read(cameraWorkoutProvider.notifier).releaseResources();
  ref.invalidate(cameraWorkoutCameraProvider);
  ref.invalidate(cameraWorkoutProvider);
}
