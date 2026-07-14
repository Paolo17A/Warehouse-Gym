import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:the_warehouse_gym/core/widgets/fitnessco_ui.dart';
import 'package:the_warehouse_gym/features/client/workout/presentation/camera_workout/utils/workout_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum WarmUpStates {
  start,
  stayAway,
  jog,
  jogCountdown,
  jogDuration,
  jogDone,
  firstRest,
  jumpingJack,
  jumpingJackCountdown,
  jumpingJackDuration,
  jumpingJackDone,
  secondRest,
  hipCircles,
  hipCirclesCountdown,
  hipCirclesDuration,
  hipCirclesDone,
  lastRest,
  finalReminder,
}

class WarmUpPage extends StatefulWidget {
  final Map<String, dynamic> sessionExtra;

  const WarmUpPage({super.key, required this.sessionExtra});

  @override
  State<WarmUpPage> createState() => _WarmUpPageState();
}

class _WarmUpPageState extends State<WarmUpPage> {
  WarmUpStates _currentWarmUpState = WarmUpStates.start;
  final FlutterTts _flutterTts = FlutterTts();
  final AudioPlayer _audioPlayer = AudioPlayer();

  String spokenMessage = 'Hi. Let\'s begin with some whole body warmups.';
  String additionalExplanation = '';
  String imageAssetPath = 'assets/images/warmups/warmup_start.png';
  bool _isDoneWarmingUp = false;
  int _secondsRemaining = 30;
  Timer _timer = Timer(const Duration(seconds: 3), () {});
  int _speechGeneration = 0;
  Completer<void>? _speakCompleter;

  WarmUpStates get _currentState => _currentWarmUpState;

  @override
  void initState() {
    super.initState();
    _configureTts();
    _setState(WarmUpStates.start);
  }

  Future<void> _configureTts() async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.awaitSpeakCompletion(true);
    _flutterTts.setCompletionHandler(() {
      final completer = _speakCompleter;
      if (completer != null && !completer.isCompleted) {
        completer.complete();
      }
    });
    _flutterTts.setCancelHandler(() {
      final completer = _speakCompleter;
      if (completer != null && !completer.isCompleted) {
        completer.complete();
      }
    });
    _flutterTts.setErrorHandler((_) {
      final completer = _speakCompleter;
      if (completer != null && !completer.isCompleted) {
        completer.complete();
      }
    });
  }

  @override
  void dispose() {
    _speechGeneration++;
    _flutterTts.stop();
    _timer.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _stopAudio() async {
    _speechGeneration++;
    final completer = _speakCompleter;
    if (completer != null && !completer.isCompleted) {
      completer.complete();
    }
    await _audioPlayer.stop();
    await _flutterTts.stop();
  }

  Future<void> _onSkipWarmUp() async {
    final confirmed = await confirmSkipWarmUp(context);
    if (!confirmed || !mounted) return;
    await _stopAudio();
    _timer.cancel();
    if (!mounted) return;
    navigateToCameraWorkout(context, widget.sessionExtra);
  }

  void _setState(WarmUpStates state) {
    additionalExplanation = '';
    switch (state) {
      case WarmUpStates.start:
        spokenMessage = 'Hi. Let us begin with some whole body warm ups.';
        imageAssetPath = 'assets/images/warmups/warmup_start.png';
      case WarmUpStates.stayAway:
        spokenMessage =
            'But before we start, position yourself 3-5 feet away from your phone';
        imageAssetPath = 'assets/images/warmups/stay_away.png';
      case WarmUpStates.jog:
        spokenMessage = 'For our first warm up, jogging in place';
        additionalExplanation =
            'Jogging in place is an aerobic exercise that requires you to constantly move and contract your muscles.';
        imageAssetPath = 'assets/images/warmups/jogging.gif';
      case WarmUpStates.jogCountdown:
        spokenMessage = 'Are you ready?';
        imageAssetPath = 'assets/images/warmups/countdown_3.png';
      case WarmUpStates.jogDuration:
        spokenMessage = 'Jog in place for 30 seconds.';
        additionalExplanation =
            'Start standing with feet hip distance apart. Lift one foot then the other to jog in place.';
        imageAssetPath = 'assets/images/warmups/jogging.gif';
      case WarmUpStates.jogDone:
        spokenMessage = 'DONE';
      case WarmUpStates.firstRest:
        spokenMessage = 'Rest for 10 seconds. Prepare for the next exercise';
        imageAssetPath = 'assets/images/warmups/jumping_jack.gif';
      case WarmUpStates.jumpingJack:
        spokenMessage = 'For our second warm up, jumping jacks';
        additionalExplanation =
            'Jumping jacks offer full-body exercise, working muscles in your arms, legs, and core.';
        imageAssetPath = 'assets/images/warmups/jumping_jack.gif';
      case WarmUpStates.jumpingJackCountdown:
        spokenMessage = 'Are you ready?';
        imageAssetPath = 'assets/images/warmups/countdown_3.png';
      case WarmUpStates.jumpingJackDuration:
        spokenMessage = 'Do jumping jacks for 30 seconds.';
        additionalExplanation =
            'Stand up straight, hold your arms at your sides, and stand with your feet shoulder-width apart.';
        imageAssetPath = 'assets/images/warmups/jumping_jack.gif';
      case WarmUpStates.jumpingJackDone:
        spokenMessage = 'DONE';
      case WarmUpStates.secondRest:
        spokenMessage = 'Rest for 10 seconds. Prepare for the next exercise';
        imageAssetPath = 'assets/images/warmups/hip_circle.gif';
      case WarmUpStates.hipCircles:
        spokenMessage = 'For our last warm up, hip circles';
        additionalExplanation =
            'Hip circles involve rotating your hips in a circular motion.';
        imageAssetPath = 'assets/images/warmups/hip_circle.gif';
      case WarmUpStates.hipCirclesCountdown:
        spokenMessage = 'Are you ready?';
        imageAssetPath = 'assets/images/warmups/countdown_3.png';
      case WarmUpStates.hipCirclesDuration:
        spokenMessage = 'Do hip circles for 30 seconds.';
        additionalExplanation =
            'Stand straight with your feet a little wider than shoulder-width apart.';
        imageAssetPath = 'assets/images/warmups/hip_circle.gif';
      case WarmUpStates.hipCirclesDone:
        spokenMessage = 'DONE';
      case WarmUpStates.lastRest:
        spokenMessage = 'Rest for 30 seconds. Prepare for your main workout';
      case WarmUpStates.finalReminder:
        spokenMessage =
            'For your main workout, the exercise will depend on what your trainer prescribed for you.';
    }
    if (!mounted) return;
    setState(() => _currentWarmUpState = state);
    _speechGeneration++;
    final generation = _speechGeneration;
    unawaited(_playMessage(generation));
  }

  Future<void> _speak(String text, int generation) async {
    if (text.trim().isEmpty) return;
    if (generation != _speechGeneration || !mounted) return;

    await _flutterTts.stop();
    if (generation != _speechGeneration || !mounted) return;

    _speakCompleter = Completer<void>();
    final completer = _speakCompleter!;
    // Extra buffer so short phrases don't hang forever if the OS skips
    // the completion callback (common on Android for brief utterances).
    final timeout = Duration(
      milliseconds: (1200 + (text.trim().split(RegExp(r'\s+')).length * 450))
          .clamp(1500, 30000),
    );

    try {
      await _flutterTts.speak(text);
      await completer.future.timeout(timeout);
    } on TimeoutException {
      if (!completer.isCompleted) completer.complete();
    } catch (_) {
      if (!completer.isCompleted) completer.complete();
    }
  }

  Future<void> _playMessage(int generation) async {
    if (generation != _speechGeneration || !mounted) return;

    final isDoneCue = _currentState == WarmUpStates.jogDone ||
        _currentState == WarmUpStates.jumpingJackDone ||
        _currentState == WarmUpStates.hipCirclesDone;

    if (isDoneCue) {
      await _audioPlayer.play(AssetSource('audio/ding.mp3'));
      await Future.delayed(const Duration(milliseconds: 800));
      if (generation != _speechGeneration || !mounted) return;
      _goToNextState();
      return;
    }

    await _speak(spokenMessage, generation);
    if (generation != _speechGeneration || !mounted) return;

    if (_currentState == WarmUpStates.jogCountdown ||
        _currentState == WarmUpStates.hipCirclesCountdown ||
        _currentState == WarmUpStates.jumpingJackCountdown) {
      await _runReadyCountdown(generation);
    } else if (_currentState == WarmUpStates.firstRest ||
        _currentState == WarmUpStates.secondRest) {
      _initializeTimer(10);
    } else if (_currentState == WarmUpStates.jogDuration ||
        _currentState == WarmUpStates.jumpingJackDuration ||
        _currentState == WarmUpStates.hipCirclesDuration ||
        _currentState == WarmUpStates.lastRest) {
      await _speak(additionalExplanation, generation);
      if (generation != _speechGeneration || !mounted) return;
      _initializeTimer(30);
    } else if (_currentState == WarmUpStates.jog ||
        _currentState == WarmUpStates.jumpingJack ||
        _currentState == WarmUpStates.hipCircles) {
      await _speak(additionalExplanation, generation);
      if (generation != _speechGeneration || !mounted) return;
      _goToNextState();
    } else {
      _goToNextState();
    }
  }

  /// 3 → 2 → 1 visual countdown after "Are you ready?".
  /// Driven by delays (not TTS completion) so short speech can't freeze it.
  Future<void> _runReadyCountdown(int generation) async {
    _timer.cancel();
    for (var n = 3; n >= 1; n--) {
      if (generation != _speechGeneration || !mounted) return;
      setState(() {
        _secondsRemaining = n;
        imageAssetPath = 'assets/images/warmups/countdown_$n.png';
      });
      await Future.delayed(const Duration(seconds: 1));
    }
    if (generation != _speechGeneration || !mounted) return;
    _goToNextState();
  }

  void _goToNextState() {
    if (_currentState == WarmUpStates.finalReminder) {
      setState(() => _isDoneWarmingUp = true);
    } else {
      final next = WarmUpStates.values[_currentState.index + 1];
      _setState(next);
    }
  }

  void _initializeTimer(int duration) {
    if (!mounted) return;
    setState(() => _secondsRemaining = duration);
    _timer.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
          if (_currentState == WarmUpStates.jogCountdown ||
              _currentState == WarmUpStates.hipCirclesCountdown ||
              _currentState == WarmUpStates.jumpingJackCountdown) {
            switch (_secondsRemaining) {
              case 3:
                imageAssetPath = 'assets/images/warmups/countdown_3.png';
              case 2:
                imageAssetPath = 'assets/images/warmups/countdown_2.png';
              case 1:
                imageAssetPath = 'assets/images/warmups/countdown_1.png';
            }
          }
        } else {
          timer.cancel();
          _goToNextState();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) await _stopAudio();
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            TextButton(
              onPressed: _onSkipWarmUp,
              child: fitnesscoText(
                'Skip warm-up',
                textStyle: blackBoldStyle(size: 14),
              ),
            ),
          ],
        ),
        body: SimulationBackground(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: fitnesscoText(
                      (_currentState != WarmUpStates.lastRest &&
                              _currentState != WarmUpStates.finalReminder)
                          ? spokenMessage
                          : '',
                      textStyle: blackBoldStyle(),
                    ),
                  ),
                  if (_currentState != WarmUpStates.lastRest &&
                      _currentState != WarmUpStates.finalReminder)
                    Stack(
                      children: [
                        Container(
                          height: 500,
                          width: 400,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(imageAssetPath),
                            ),
                          ),
                        ),
                        if (_currentState == WarmUpStates.hipCirclesDone ||
                            _currentState == WarmUpStates.jogDone ||
                            _currentState == WarmUpStates.jumpingJackDone)
                          Container(
                            height: 500,
                            width: 400,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/images/warmups/DONE.png',
                                ),
                              ),
                            ),
                          ),
                      ],
                    )
                  else
                    SizedBox(
                      height: 500,
                      width: 400,
                      child: Center(
                        child: fitnesscoText(
                          spokenMessage,
                          textStyle: greyBoldStyle(size: 30),
                        ),
                      ),
                    ),
                  if (_currentState == WarmUpStates.hipCirclesDuration ||
                      _currentState == WarmUpStates.jogDuration ||
                      _currentState == WarmUpStates.jumpingJackDuration ||
                      _currentState == WarmUpStates.firstRest ||
                      _currentState == WarmUpStates.secondRest ||
                      _currentState == WarmUpStates.lastRest)
                    fitnesscoText(
                      _secondsRemaining > 0 ? _secondsRemaining.toString() : '',
                      textStyle: blackBoldStyle(size: 75),
                    )
                  else if (_isDoneWarmingUp)
                    ElevatedButton(
                      onPressed: () {
                        navigateToCameraWorkout(context, widget.sessionExtra);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: fitnesscoText(
                        'START MAIN WORKOUT',
                        textStyle: whiteBoldStyle(),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
