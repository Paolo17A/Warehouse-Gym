String workoutInstructionFor(String exercise, bool mayAddRep) {
  switch (exercise) {
    case 'Sit-ups':
      return mayAddRep
          ? 'Lie in the floor,  bend your knees so your feet are flat on the floor, to lift your back'
          : 'Lower your back to the starting position';
    case 'Squats':
      return mayAddRep
          ? 'Stand with your feet with hip-distance apart,  hips back and bend your knees'
          : 'Straighten your legs to return to a standing position';
    case 'Crunches':
      return mayAddRep
          ? 'Lie in the floor, bend your knees so your feet are flat on the floor, lift your chest '
          : 'Lower your back to the starting position';
    case 'Russian Twists':
      return mayAddRep
          ? 'Sit on the floor with your knees bent and feet flat on the floor'
          : 'Twist your torso to the right or to the left';
    case 'Left Arm Dumbell Curl':
      return mayAddRep
          ? 'Pull your left wrist upward'
          : 'Stretch out your left arm';
    case 'Right Arm Dumbell Curl':
      return mayAddRep
          ? 'Pull your right wrist upward'
          : 'Stretch out your right arm';
    case 'Barbell Curl':
      return mayAddRep
          ? 'Lift the barbell towards your chest'
          : 'Slowly lower the barbell as you stretch out your arms';
    case 'Deadlifts':
      return mayAddRep
          ? 'Slowly stand up as you lift the barbell upwards'
          : 'Bend your knees and hips slowly as you lower the barbell back to the floor';
    case 'Bent-Over Row':
      return mayAddRep
          ? 'Bend forward and pull your arms back and bend your elbows as you lift the barbell'
          : 'Outstretch your arms as lower the barbell back to the floor';
    case 'Lunges':
      return mayAddRep
          ? 'Step forward as you put one knee downward. Form a right angle with your knee'
          : 'Slowly return to a standing position';
    case 'Kettlebell Swings':
      return mayAddRep
          ? 'Swing the kettlbell upwards as you stand up straight'
          : 'Bring the kettlebell back down as you bend forward';
    case 'Flat Barbell Bench Press':
      return mayAddRep
          ? 'Push the barbell upwards while lying flat on your back'
          : 'Slowly bring the barbell back down to chest level';
    case 'Inclined Dumbell Bench Press':
      return mayAddRep
          ? 'Push the dumbells upwards while lying inclined on your back'
          : 'Slowly bring the barbell back down to chest level';
    case 'Chest Pushups':
      return mayAddRep
          ? 'Begin in a plank position with your hands placed slightly wider than shoulder-width apart and push yourself upwards.'
          : 'Lower your chest towards the ground by bending your elbows, and maintaining your straight plank position';
    case 'Overhead Press':
      return mayAddRep
          ? 'Raise the weights above your head'
          : 'Lower the weights back to shoulder level';
    case 'Dumbell Front Raise':
      return mayAddRep
          ? 'Raise the dumbells forward up to shoulder level.'
          : 'Lower the dumbells back to hip level';
    case 'Upright Rows':
      return mayAddRep
          ? 'Raise the barbell upward up to shoulder level.'
          : 'Lower the barbell back down to hip level';
    case 'Dumbbell Triceps Extension':
      return mayAddRep
          ? 'Bend your elbows to lower the dumbell behind your head.'
          : 'Straighten your elbows to raise the dumbell back abouve your head';
    case 'Tricep Pushups':
      return mayAddRep
          ? 'Begin in a plank position with your hands placed wider than shoulder-width apart and push yourself upwards.'
          : 'Lower your chest towards the ground by bending your elbows, and maintaining your straight plank position';
    case 'Tricep Rope Pushdown':
      return mayAddRep
          ? 'Pull the rope by extending your arm downwards.'
          : 'Bend your arms back up a you let the rope bring down thw weights.';
    default:
      return mayAddRep
          ? 'Put your left hand above your nose (This workout has not been implemented yet)'
          : 'Put your left hand below your left hip (This workout has not been implemented yet)';
  }
}
