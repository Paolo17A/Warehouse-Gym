import 'package:camera/camera.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Populated in main() before runApp
List<CameraDescription> appCameras = [];

final camerasProvider = Provider<List<CameraDescription>>(
  (_) => appCameras,
);
