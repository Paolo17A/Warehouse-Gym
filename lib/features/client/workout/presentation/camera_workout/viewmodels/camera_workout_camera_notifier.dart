import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:the_warehouse_gym/core/providers/camera_providers.dart';
import 'package:the_warehouse_gym/features/client/workout/presentation/camera_workout/utils/pose_painter_util.dart';
import 'package:the_warehouse_gym/features/client/workout/presentation/camera_workout/utils/pose_rep_handler.dart';
import 'package:the_warehouse_gym/features/client/workout/presentation/camera_workout/utils/workout_instruction_util.dart';
import 'package:the_warehouse_gym/features/client/workout/presentation/camera_workout/viewmodels/camera_workout_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraWorkoutCameraState {
  final bool changingLens;
  final bool isInitialized;
  final String workoutInstruction;
  final CustomPaint? customPaint;
  final bool permissionDenied;
  final bool unavailable;

  const CameraWorkoutCameraState({
    this.changingLens = false,
    this.isInitialized = false,
    this.workoutInstruction = '',
    this.customPaint,
    this.permissionDenied = false,
    this.unavailable = false,
  });

  CameraWorkoutCameraState copyWith({
    bool? changingLens,
    bool? isInitialized,
    String? workoutInstruction,
    CustomPaint? customPaint,
    bool? permissionDenied,
    bool? unavailable,
    bool clearOverlay = false,
  }) {
    return CameraWorkoutCameraState(
      changingLens: changingLens ?? this.changingLens,
      isInitialized: isInitialized ?? this.isInitialized,
      workoutInstruction: workoutInstruction ?? this.workoutInstruction,
      customPaint: clearOverlay ? null : customPaint ?? this.customPaint,
      permissionDenied: permissionDenied ?? this.permissionDenied,
      unavailable: unavailable ?? this.unavailable,
    );
  }
}

class CameraWorkoutCameraNotifier
    extends StateNotifier<CameraWorkoutCameraState> {
  CameraWorkoutCameraNotifier(this._ref)
      : super(const CameraWorkoutCameraState());

  final Ref _ref;
  final PoseDetector _poseDetector =
      PoseDetector(options: PoseDetectorOptions());
  final CameraLensDirection _cameraLensDirection = CameraLensDirection.back;

  CameraController? _controller;
  int _cameraIndex = -1;
  bool _canProcess = true;
  bool _isBusy = false;
  bool _disposed = false;
  bool _resourcesReleased = false;

  void releaseResources() {
    if (_resourcesReleased) return;
    _resourcesReleased = true;
    _disposed = true;
    _canProcess = false;
    _poseDetector.close();
    unawaited(_stopLiveFeed());
  }

  CameraController? get controller => _controller;

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  Future<void> initialize() async {
    final status = await Permission.camera.request();
    if (_disposed) return;

    if (!status.isGranted) {
      state = state.copyWith(permissionDenied: true, unavailable: false);
      return;
    }

    if (appCameras.isEmpty) {
      state = state.copyWith(unavailable: true, permissionDenied: false);
      return;
    }

    state = state.copyWith(permissionDenied: false, unavailable: false);

    for (var i = 0; i < appCameras.length; i++) {
      if (appCameras[i].lensDirection == _cameraLensDirection) {
        _cameraIndex = i;
        break;
      }
    }

    if (_cameraIndex != -1) {
      await _startLiveFeed();
    }
  }

  Future<void> retryPermission() async {
    state = state.copyWith(permissionDenied: false, unavailable: false);
    await initialize();
  }

  Future<void> _startLiveFeed() async {
    final camera = appCameras[_cameraIndex];
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );

    await _controller?.initialize();
    if (_disposed) return;

    await _controller?.startImageStream(_processCameraImage);
    state = state.copyWith(isInitialized: true);
  }

  Future<void> switchCamera() async {
    if (appCameras.isEmpty) return;

    state = state.copyWith(changingLens: true);
    _cameraIndex = (_cameraIndex + 1) % appCameras.length;

    await _stopLiveFeed();
    await _startLiveFeed();
    state = state.copyWith(changingLens: false);
  }

  Future<void> _stopLiveFeed() async {
    await _controller?.stopImageStream();
    await _controller?.dispose();
    _controller = null;
    state = state.copyWith(isInitialized: false, clearOverlay: true);
  }

  void _processCameraImage(CameraImage image) {
    final inputImage = _inputImageFromCameraImage(image);
    if (inputImage == null) return;
    unawaited(_processImage(inputImage));
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess || _isBusy || _disposed) return;

    final workoutState = _ref.read(cameraWorkoutProvider);
    final session = workoutState.session;
    if (session == null || workoutState.phase != WorkoutStates.workout) {
      return;
    }

    _isBusy = true;
    try {
      final exercise = _ref
          .read(cameraWorkoutProvider.notifier)
          .currentExerciseName(session);
      final instruction =
          workoutInstructionFor(exercise, session.mayAddRep);

      if (state.workoutInstruction != instruction) {
        state = state.copyWith(workoutInstruction: instruction);
      }

      final poses = await _poseDetector.processImage(inputImage);
      if (_disposed) return;

      CustomPaint? overlay;
      if (inputImage.metadata != null) {
        overlay = CustomPaint(
          painter: PosePainter(
            poses,
            inputImage.metadata!.size,
            inputImage.metadata!.rotation,
            _cameraLensDirection,
          ),
        );
      }

      final viewModel = _ref.read(cameraWorkoutProvider.notifier);
      final currentMayAddRep =
          _ref.read(cameraWorkoutProvider).session?.mayAddRep ?? true;

      processPosesForExercise(
        exercise: exercise,
        poses: poses,
        mayAddRep: currentMayAddRep,
        onRepDetected: viewModel.addRepFromPose,
        onMayAddRepChanged: viewModel.setMayAddRep,
      );

      if (!_disposed) {
        state = state.copyWith(customPaint: overlay);
      }
    } catch (_) {
      // Keep the live feed running if a single ML Kit frame fails (common in
      // release when models/classes are briefly unavailable).
    } finally {
      _isBusy = false;
    }
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (_controller == null) return null;

    final camera = appCameras[_cameraIndex];
    final sensorOrientation = camera.sensorOrientation;
    InputImageRotation? rotation;

    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation =
          _orientations[_controller!.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (camera.lensDirection == CameraLensDirection.front) {
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }
    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) {
      return null;
    }

    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  @override
  void dispose() {
    releaseResources();
    super.dispose();
  }
}

final cameraWorkoutCameraProvider = StateNotifierProvider.autoDispose<
    CameraWorkoutCameraNotifier, CameraWorkoutCameraState>(
  (ref) => CameraWorkoutCameraNotifier(ref),
);
