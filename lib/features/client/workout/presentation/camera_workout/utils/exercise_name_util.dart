/// Maps prescribed exercise names to keys used by pose detection switch cases.
String normalizeExerciseName(String name) {
  const aliases = <String, String>{
    'Left Arm Dumbbell Curl': 'Left Arm Dumbell Curl',
    'Right Arm Dumbbell Curl': 'Right Arm Dumbell Curl',
    'Dumbbell Front Raise': 'Dumbell Front Raise',
    'Inclined Dumbbell Bench Press': 'Inclined Dumbell Bench Press',
    'Dumbbell Triceps Extension': 'Dumbbell Triceps Extension',
  };
  return aliases[name] ?? name;
}

String exerciseGifAsset(String exerciseName) {
  return 'assets/images/gifs/$exerciseName.gif';
}
