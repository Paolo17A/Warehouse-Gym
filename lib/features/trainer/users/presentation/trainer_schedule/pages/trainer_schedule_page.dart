import 'package:the_warehouse_gym/core/constants/app_colors.dart';
import 'package:the_warehouse_gym/core/errors/failures.dart';
import 'package:the_warehouse_gym/core/providers/session_providers.dart';
import 'package:the_warehouse_gym/core/router/app_router.dart';
import 'package:the_warehouse_gym/core/utils/toast_utils.dart';
import 'package:the_warehouse_gym/core/widgets/fitnessco_ui.dart';
import 'package:the_warehouse_gym/core/widgets/loading_widget.dart';
import 'package:the_warehouse_gym/core/widgets/no_internet_widget.dart';
import 'package:the_warehouse_gym/features/trainer/users/presentation/trainer_schedule/viewmodels/trainer_schedule_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TrainerSchedulePage extends HookConsumerWidget {
  const TrainerSchedulePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trainerUid = ref.watch(sessionUserProvider)?.uid ?? '';
    final state = ref.watch(trainerScheduleViewModelProvider);
    final viewModel = ref.read(trainerScheduleViewModelProvider.notifier);
    final selectedDate = useState(DateTime.now());

    useEffect(() {
      if (trainerUid.isEmpty) return null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.loadSchedule(trainerUid);
      });
      return null;
    }, [trainerUid]);

    ref.listen<TrainerScheduleState>(trainerScheduleViewModelProvider,
        (_, next) {
      next.maybeWhen(
        failure: (message) => showErrorToast(message),
        orElse: () {},
      );
    });

    return state.when(
      loading: () => const Scaffold(body: LoadingWidget()),
      failure: (message) {
        if (message == const NetworkFailure().message) {
          return Scaffold(
            body: NoInternetWidget(
              onRetry: () => viewModel.refresh(trainerUid),
            ),
          );
        }
        return Scaffold(
          appBar: largeGradientAppBar('My Client Schedule'),
          body: Center(child: Text(message)),
        );
      },
      success: (schedule) {
        final workoutsForSelectedDate = schedule.where((item) {
          final date = _parseWorkoutDate(item['workoutDate']);
          if (date == null) return false;
          return _isSameCalendarDay(selectedDate.value, date);
        }).toList();

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: largeGradientAppBar('My Client Schedule'),
          body: ViewTrainerBackground(
            child: SafeArea(
              child: RefreshIndicator(
                onRefresh: () => viewModel.refresh(trainerUid),
                color: AppColors.purpleSnail,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      _ScheduleCalendar(
                        selectedDate: selectedDate.value,
                        onDateSelected: (date) => selectedDate.value = date,
                      ),
                      workoutsForSelectedDate.isEmpty
                          ? SizedBox(
                              height: 275,
                              child: Center(
                                child: fitnesscoText(
                                  'NO CLIENTS FOR THIS DAY',
                                  textStyle: blackBoldStyle(size: 28),
                                ),
                              ),
                            )
                          : _SelectedDateClientsList(
                              workouts: workoutsForSelectedDate,
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  DateTime? _parseWorkoutDate(dynamic raw) {
    if (raw is DateTime) return raw;
    if (raw is String && raw.isNotEmpty) return DateTime.tryParse(raw);
    return null;
  }

  bool _isSameCalendarDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class _ScheduleCalendar extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const _ScheduleCalendar({
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return CalendarCarousel(
      height: 375,
      width: MediaQuery.of(context).size.width * 0.9,
      weekendTextStyle: whiteBoldStyle(),
      daysTextStyle: whiteBoldStyle(),
      showOnlyCurrentMonthDate: true,
      daysHaveCircularBorder: true,
      headerTextStyle: const TextStyle(
        color: AppColors.purpleSnail,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      weekdayTextStyle: GoogleFonts.cambay(textStyle: blackBoldStyle()),
      selectedDateTime: selectedDate,
      todayButtonColor: AppColors.nearMoon,
      todayBorderColor: AppColors.nearMoon,
      selectedDayButtonColor: Colors.transparent,
      selectedDayBorderColor: Colors.transparent,
      leftButtonIcon: Transform.scale(
        scale: 1.5,
        child: const Icon(
          Icons.arrow_circle_left_outlined,
          color: AppColors.purpleSnail,
        ),
      ),
      rightButtonIcon: Transform.scale(
        scale: 1.5,
        child: const Icon(
          Icons.arrow_circle_right_outlined,
          color: AppColors.purpleSnail,
        ),
      ),
      isScrollable: false,
      onDayPressed: (date, _) => onDateSelected(date),
      customDayBuilder: (
        isSelectable,
        index,
        isSelectedDay,
        isToday,
        isPrevMonthDay,
        textStyle,
        isNextMonthDay,
        isThisMonthDay,
        day,
      ) {
        return customDayWidget(isSelectedDay, day.day);
      },
    );
  }
}

class _SelectedDateClientsList extends StatelessWidget {
  final List<Map<String, dynamic>> workouts;

  const _SelectedDateClientsList({required this.workouts});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: workouts.map((item) {
          final clientUid = item['clientUid'] as String? ?? '';
          final clientName = item['clientName'] as String? ?? 'Unknown Client';
          final profileImageURL =
              item['profileImageURL'] as String? ?? '';
          final description = item['description'] as String? ?? '';
          final prescriptionId = item['prescriptionId'] as String? ?? '';

          return Padding(
            padding: const EdgeInsets.all(10),
            child: roundedContainer(
              width: double.infinity,
              height: 130,
              color: AppColors.love,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buildProfileImage(
                      profileImageURL: profileImageURL,
                      radius: 50,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          fitnesscoText(
                            clientName,
                            textStyle: blackBoldStyle(),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: fitnesscoText(
                              description.isNotEmpty
                                  ? description
                                  : 'Workout session',
                              textAlign: TextAlign.left,
                            ),
                          ),
                          SizedBox(
                            height: 33,
                            child: ElevatedButton(
                              onPressed: () {
                                if (clientUid.isEmpty ||
                                    prescriptionId.isEmpty) {
                                  showInfoToast(
                                    'Workout details unavailable.',
                                  );
                                  return;
                                }
                                context.push(
                                  AppRouter.prescribeWorkout(
                                    clientUid,
                                    prescriptionId: prescriptionId,
                                    returnToSchedule: true,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: fitnesscoText(
                                'VIEW WORKOUT',
                                textStyle: whiteBoldStyle(size: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
