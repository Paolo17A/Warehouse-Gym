import 'package:the_warehouse_gym/features/client/workout/presentation/camera_workout/utils/pose_detector_util.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

typedef RepDetectedCallback = void Function();
typedef MayAddRepChangedCallback = void Function(bool mayAddRep);

void processPosesForExercise({
  required String exercise,
  required List<Pose> poses,
  required bool mayAddRep,
  required RepDetectedCallback onRepDetected,
  required MayAddRepChangedCallback onMayAddRepChanged,
}) {
  switch (exercise) {
    case 'Sit-ups':
      for (final pose in poses) {
        if (mayAddRep && isFinishedSitUpPosition(pose)) {
          onRepDetected();
          return;
        }
        if (!mayAddRep && isStartingSitUpPosition(pose)) {
          onMayAddRepChanged(true);
        }
      }
      break;
    case 'Crunches':
      for (final pose in poses) {
        if (mayAddRep && isFinishedCrunchPosition(pose)) {
          onRepDetected();
          return;
        }
        if (!mayAddRep && isStartingCrunchPosition(pose)) {
          onMayAddRepChanged(true);
        }
      }
      break;
    case 'Squats':
      for (final pose in poses) {
        if (mayAddRep && isFinishedSquatPosition(pose)) {
          onRepDetected();
          return;
        }
        if (!mayAddRep && isStandingPosition(pose)) {
          onMayAddRepChanged(true);
        }
      }
      break;
    case 'Russian Twists':
      for (final pose in poses) {
        if (mayAddRep && isFinishedRussianTwistPosition(pose)) {
          onRepDetected();
          return;
        }
        if (!mayAddRep && isStartingSitUpPosition(pose)) {
          onMayAddRepChanged(true);
        }
      }
      break;
    case 'Left Arm Dumbell Curl':
      for (final pose in poses) {
        if (mayAddRep && isFinishingLeftArmWristCurl(pose)) {
          onRepDetected();
          return;
        }
        if (!mayAddRep && isStartingLeftArmWristCurl(pose)) {
          onMayAddRepChanged(true);
        }
      }
      break;
    case 'Right Arm Dumbell Curl':
      for (final pose in poses) {
        if (mayAddRep && isFinishingRightArmWristCurl(pose)) {
          onRepDetected();
          return;
        }
        if (!mayAddRep && isStartingRightArmWristCurl(pose)) {
          onMayAddRepChanged(true);
        }
      }
      break;
    case 'Barbell Curl':
      for (final pose in poses) {
        if (mayAddRep &&
            isFinishingRightArmWristCurl(pose) &&
            isFinishingLeftArmWristCurl(pose)) {
          onRepDetected();
          return;
        }
        if (!mayAddRep &&
            isStartingRightArmWristCurl(pose) &&
            isStartingLeftArmWristCurl(pose)) {
          onMayAddRepChanged(true);
        }
      }
      break;
    case 'Bent-Over Row':
      for (final pose in poses) {
        if (mayAddRep && isFinishedBentRowPosition(pose)) {
          onRepDetected();
          return;
        }
        if (!mayAddRep && isStartingBentRowPosition(pose)) {
          onMayAddRepChanged(true);
        }
      }
      break;
    case 'Deadlifts':
      for (final pose in poses) {
        if (mayAddRep && isFinishedDeadliftPosition(pose)) {
          onRepDetected();
          return;
        }
        if (!mayAddRep && isStartingDeadliftPosition(pose)) {
          onMayAddRepChanged(true);
        }
      }
      break;
    case 'Lunges':
      for (final pose in poses) {
        if (mayAddRep && isFinishingLungePosition(pose)) {
          onRepDetected();
          return;
        }
        if (!mayAddRep && isStartingLungePosition(pose)) {
          onMayAddRepChanged(true);
        }
      }
      break;
    case 'Kettlebell Swings':
      for (final pose in poses) {
        if (mayAddRep && isFinishedKettlebellPosition(pose)) {
          onRepDetected();
          return;
        }
        if (!mayAddRep && isStartingKettlebellPosition(pose)) {
          onMayAddRepChanged(true);
        }
      }
      break;
    case 'Flat Barbell Bench Press':
      for (final pose in poses) {
        if (mayAddRep && isFinishingFlatBarbellPosition(pose)) {
          onRepDetected();
          return;
        }
        if (!mayAddRep && isStartingFlatBarbellPosition(pose)) {
          onMayAddRepChanged(true);
        }
      }
      break;
    case 'Inclined Dumbell Bench Press':
      for (final pose in poses) {
        if (mayAddRep && isFinishingInclinedDumbellPosition(pose)) {
          onRepDetected();
          return;
        }
        if (!mayAddRep && isStartingInclinedDumbellPosition(pose)) {
          onMayAddRepChanged(true);
        }
      }
      break;
    case 'Chest Pushups':
      for (final pose in poses) {
        if (mayAddRep && isFinishingPushUpPosition(pose)) {
          onRepDetected();
          return;
        }
        if (!mayAddRep && isStartingPushUpPosition(pose)) {
          onMayAddRepChanged(true);
        }
      }
      break;
    case 'Overhead Press':
      for (final pose in poses) {
        if (mayAddRep && isFinishingOverheadPressPosition(pose)) {
          onRepDetected();
          return;
        }
        if (!mayAddRep && isStartingOverheadPressPosition(pose)) {
          onMayAddRepChanged(true);
        }
      }
      break;
    case 'Dumbell Front Raise':
      for (final pose in poses) {
        if (mayAddRep && isFinishingDumbellFrontRaisePosition(pose)) {
          onRepDetected();
          return;
        }
        if (!mayAddRep && isStartingDumbellFrontRaisePosition(pose)) {
          onMayAddRepChanged(true);
        }
      }
      break;
    case 'Upright Rows':
      for (final pose in poses) {
        if (mayAddRep && isFinishingUprightRowPosition(pose)) {
          onRepDetected();
          return;
        }
        if (!mayAddRep && isStartingUprightRowPosition(pose)) {
          onMayAddRepChanged(true);
        }
      }
      break;
    case 'Dumbbell Triceps Extension':
      for (final pose in poses) {
        if (mayAddRep && isFinishingDumbellTricepsExtensionPosition(pose)) {
          onRepDetected();
          return;
        }
        if (!mayAddRep && isStartingDumbellTricepsExtensionPosition(pose)) {
          onMayAddRepChanged(true);
        }
      }
      break;
    case 'Tricep Pushups':
      for (final pose in poses) {
        if (mayAddRep && isFinishingPushUpPosition(pose)) {
          onRepDetected();
          return;
        }
        if (!mayAddRep && isStartingPushUpPosition(pose)) {
          onMayAddRepChanged(true);
        }
      }
      break;
    case 'Tricep Rope Pushdown':
      for (final pose in poses) {
        if (mayAddRep && isFinishingTricepRopePushdown(pose)) {
          onRepDetected();
          return;
        }
        if (!mayAddRep && isStartingTricepRopePushdown(pose)) {
          onMayAddRepChanged(true);
        }
      }
      break;
    default:
      for (final pose in poses) {
        if (mayAddRep && isLeftHandAboveHead(pose)) {
          onRepDetected();
          return;
        }
        if (!mayAddRep && isLeftHandBelowHip(pose)) {
          onMayAddRepChanged(true);
        }
      }
      break;
  }
}
