import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:the_warehouse_gym/core/constants/app_colors.dart';

import 'coordinates_translator.dart';

class PosePainter extends CustomPainter {
  PosePainter(
    this.poses,
    this.imageSize,
    this.rotation,
    this.cameraLensDirection,
  );

  final List<Pose> poses;
  final Size imageSize;
  final InputImageRotation rotation;
  final CameraLensDirection cameraLensDirection;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = AppColors.nearMoon;

    final dotPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.rosePink;

    for (final pose in poses) {
      pose.landmarks.forEach((_, landmark) {
        canvas.drawCircle(
            Offset(
              translateX(
                landmark.x,
                size,
                imageSize,
                rotation,
                cameraLensDirection,
              ),
              translateY(
                landmark.y,
                size,
                imageSize,
                rotation,
                cameraLensDirection,
              ),
            ),
            3,
            dotPaint);
      });

      void paintLine(
          PoseLandmarkType type1, PoseLandmarkType type2, Paint paintType) {
        final PoseLandmark joint1 = pose.landmarks[type1]!;
        final PoseLandmark joint2 = pose.landmarks[type2]!;
        canvas.drawLine(
            Offset(
                translateX(
                  joint1.x,
                  size,
                  imageSize,
                  rotation,
                  cameraLensDirection,
                ),
                translateY(
                  joint1.y,
                  size,
                  imageSize,
                  rotation,
                  cameraLensDirection,
                )),
            Offset(
                translateX(
                  joint2.x,
                  size,
                  imageSize,
                  rotation,
                  cameraLensDirection,
                ),
                translateY(
                  joint2.y,
                  size,
                  imageSize,
                  rotation,
                  cameraLensDirection,
                )),
            paintType);
      }

      //Draw arms
      paintLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow,
          linePaint);
      paintLine(
          PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist, linePaint);
      paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow,
          linePaint);
      paintLine(
          PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist, linePaint);

      //Draw Body
      paintLine(
          PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip, linePaint);
      paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip,
          linePaint);
      paintLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder,
          linePaint);
      paintLine(PoseLandmarkType.leftHip, PoseLandmarkType.rightHip, linePaint);

      //Draw legs
      paintLine(
          PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee, linePaint);
      paintLine(
          PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle, linePaint);
      paintLine(
          PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee, linePaint);
      paintLine(
          PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.poses != poses;
  }
}
