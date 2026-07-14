import 'package:the_warehouse_gym/core/router/app_router.dart';
import 'package:gap/gap.dart';
import 'package:the_warehouse_gym/core/constants/app_colors.dart';
import 'package:the_warehouse_gym/core/providers/session_providers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

export 'auth_widgets.dart';

// ─── Typography ─────────────────────────────────────────────────────────────

Widget fitnesscoText(
  String label, {
  TextAlign textAlign = TextAlign.center,
  TextStyle? textStyle,
}) {
  return Text(
    label,
    textAlign: textAlign,
    style: GoogleFonts.nunitoSans(textStyle: textStyle),
  );
}

TextStyle blackBoldStyle({double size = 20}) {
  return TextStyle(
    fontSize: size,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );
}

TextStyle whiteBoldStyle({double size = 20}) {
  return TextStyle(
    fontSize: size,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );
}

TextStyle greyBoldStyle({double size = 20}) {
  return TextStyle(
    fontSize: size,
    color: const Color.fromARGB(255, 94, 90, 90),
    fontWeight: FontWeight.bold,
  );
}

// ─── Loading ──────────────────────────────────────────────────────────────────

class SwitchedLoadingContainer extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const SwitchedLoadingContainer({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading ? const Center(child: CircularProgressIndicator()) : child;
  }
}

// ─── Backgrounds ──────────────────────────────────────────────────────────────

class _FullScreenBackground extends StatelessWidget {
  final String assetPath;
  final Widget child;
  final bool safeArea;
  final bool scrollable;

  const _FullScreenBackground({
    required this.assetPath,
    required this.child,
    this.safeArea = false,
    this.scrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      image: DecorationImage(
        image: AssetImage(assetPath),
        fit: BoxFit.cover,
      ),
    );

    if (!scrollable) {
      return SizedBox.expand(
        child: Container(
          decoration: decoration,
          child: safeArea ? SafeArea(child: child) : child,
        ),
      );
    }

    final content = Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: decoration,
      child: child,
    );
    return SingleChildScrollView(
      child: safeArea ? SafeArea(child: content) : content,
    );
  }
}

class HomeBackground extends StatelessWidget {
  final Widget child;
  const HomeBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return _FullScreenBackground(
      assetPath: 'assets/images/backgrounds/register.png',
      child: child,
    );
  }
}

class ViewTrainerBackground extends StatelessWidget {
  final Widget child;
  const ViewTrainerBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return _FullScreenBackground(
      assetPath: 'assets/images/backgrounds/VIEW TRAINER BACKGROUND.png',
      child: child,
    );
  }
}

class WorkoutPlanBackground extends StatelessWidget {
  final Widget child;
  const WorkoutPlanBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/backgrounds/my workout plan.png',
            fit: BoxFit.cover,
          ),
        ),
        SafeArea(child: child),
      ],
    );
  }
}

class StartWorkoutBackground extends StatelessWidget {
  final Widget child;
  const StartWorkoutBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return _FullScreenBackground(
      assetPath: 'assets/images/backgrounds/start_workout_bg.png',
      safeArea: true,
      child: child,
    );
  }
}

class ChatBackground extends StatelessWidget {
  final Widget child;
  const ChatBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return _FullScreenBackground(
      assetPath: 'assets/images/backgrounds/CHAT BACKGROUND.png',
      safeArea: true,
      scrollable: false,
      child: child,
    );
  }
}

class SimulationBackground extends StatelessWidget {
  final Widget child;
  const SimulationBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return _FullScreenBackground(
      assetPath: 'assets/images/backgrounds/SIMULATION Background.png',
      safeArea: true,
      child: child,
    );
  }
}

// ─── Containers ───────────────────────────────────────────────────────────────

Widget roundedContainer({
  required Widget child,
  Color? color,
  double? width,
  double? height,
  Color? borderColor,
}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(20),
      border:
          borderColor != null ? Border.all(color: borderColor, width: 1) : null,
    ),
    child: child,
  );
}

// ─── App bars ─────────────────────────────────────────────────────────────────

AppBar homeAppBar(
  BuildContext context, {
  Widget? title,
  VoidCallback? onRefresh,
  required WidgetRef ref,
}) {
  return AppBar(
    automaticallyImplyLeading: false,
    elevation: 0,
    backgroundColor: Colors.transparent,
    title: title,
    leading: onRefresh != null
        ? IconButton(
            onPressed: onRefresh,
            icon: Image.asset('assets/images/icons/refresh.png'),
          )
        : null,
    actions: [
      IconButton(
        onPressed: () => _showLogOutModal(context, ref),
        icon: Image.asset('assets/images/icons/logout.png'),
      ),
    ],
  );
}

AppBar largeGradientAppBar(String label, {List<Widget>? actions}) {
  return AppBar(
    toolbarHeight: 85,
    elevation: 0,
    flexibleSpace: Ink(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.jigglypuff, AppColors.love],
        ),
      ),
    ),
    title: Center(
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    ),
    actions: actions,
  );
}

void _showLogOutModal(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    constraints:
        BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
    backgroundColor: Colors.transparent,
    builder: (ctx) => Wrap(
      children: [
        ListTile(
          tileColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          title: Center(
            child: fitnesscoText(
              'LOG-OUT',
              textStyle: const TextStyle(
                color: AppColors.plasmaTrail,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onTap: () async {
            Navigator.pop(ctx);
            await ref.read(sessionServiceProvider).signOut();
            if (context.mounted) {
              context.go(AppRouter.welcome);
            }
          },
        ),
      ],
    ),
  );
}

// ─── Home rows ────────────────────────────────────────────────────────────────

Widget homeRowContainer({
  required String iconPath,
  required String label,
  required VoidCallback onPress,
  double imageScale = 75,
}) {
  return GestureDetector(
    onTap: onPress,
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(iconPath, scale: imageScale),
                const Gap(10),
                fitnesscoText(
                  label,
                  textStyle: const TextStyle(color: Colors.black, fontSize: 15),
                ),
              ],
            ),
            Image.asset('assets/images/icons/select_row.png', scale: 50),
          ],
        ),
        const Divider(thickness: 0.5, color: Colors.black),
      ],
    ),
  );
}

// ─── Profile widgets ──────────────────────────────────────────────────────────

Widget buildProfileImage({
  required String profileImageURL,
  required double radius,
  Color backgroundColor = Colors.white,
  Color iconColor = AppColors.purpleSnail,
}) {
  if (profileImageURL.isNotEmpty) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      backgroundImage: NetworkImage(profileImageURL),
    );
  }
  return CircleAvatar(
    radius: radius,
    backgroundColor: backgroundColor,
    child: Transform.scale(
      scale: 2,
      child: Icon(Icons.person, color: iconColor),
    ),
  );
}

Widget trainerProfileImage(String profileImageURL) {
  return buildProfileImage(
    profileImageURL: profileImageURL,
    radius: 50,
    backgroundColor: AppColors.mercury,
    iconColor: const Color.fromARGB(255, 165, 163, 163),
  );
}

Widget clientProfileImage(String profileImageURL) {
  return buildProfileImage(
    profileImageURL: profileImageURL,
    radius: 50,
    backgroundColor: const Color.fromARGB(255, 165, 163, 163),
    iconColor: Colors.white,
  );
}

Widget trainerProfileContent(
  BuildContext context,
  String firstName,
  String lastName,
  List<dynamic> currentClients,
  String sex,
  dynamic age,
) {
  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal: MediaQuery.of(context).size.width * 0.05,
    ),
    child: Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: fitnesscoText(
            '$firstName $lastName',
            textStyle: const TextStyle(
              color: AppColors.purpleSnail,
              fontWeight: FontWeight.bold,
              fontSize: 23,
            ),
          ),
        ),
        Row(
          children: [
            fitnesscoText(sex, textStyle: blackBoldStyle(size: 13)),
            const Gap(10),
            fitnesscoText(
              '${age.toString()} years old',
            ),
          ],
        ),
        fitnesscoText(
          '${currentClients.length} Clients',
          textStyle: blackBoldStyle(size: 15),
        ),
      ],
    ),
  );
}

Widget clientProfileContent(
  BuildContext context,
  String firstName,
  String lastName,
  String sex,
  dynamic age,
) {
  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal: MediaQuery.of(context).size.width * 0.05,
    ),
    child: SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Column(
        children: [
          fitnesscoText(
            '$firstName $lastName',
            textStyle: const TextStyle(
              color: AppColors.purpleSnail,
              fontWeight: FontWeight.bold,
              fontSize: 23,
            ),
          ),
          fitnesscoText(sex, textStyle: blackBoldStyle(size: 13)),
          fitnesscoText('${age.toString()} years old'),
        ],
      ),
    ),
  );
}

Widget userDivider() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Divider(thickness: 2, color: Colors.grey.shade400),
  );
}

// ─── Gradient chips ───────────────────────────────────────────────────────────

Widget sunGradientBox({required String label}) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: Container(
      width: 130,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [AppColors.bananaMilk, AppColors.jigglypuff],
        ),
      ),
      child: Center(
        child: fitnesscoText(label, textStyle: blackBoldStyle()),
      ),
    ),
  );
}

Widget moonGradientBox({required String label}) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: Container(
      width: 130,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [AppColors.mintZest, AppColors.trueSky],
        ),
      ),
      child: Center(
        child: fitnesscoText(label, textStyle: blackBoldStyle()),
      ),
    ),
  );
}

// ─── Calendar day ─────────────────────────────────────────────────────────────

Widget customDayWidget(bool isSelectedDay, int day) {
  return Container(
    width: 45,
    height: 45,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: LinearGradient(
        colors: isSelectedDay
            ? [AppColors.mintZest, AppColors.nearMoon]
            : [AppColors.jigglypuff, AppColors.purpleSnail],
      ),
    ),
    child: Center(child: Text(day.toString(), style: whiteBoldStyle())),
  );
}

// ─── Admin home button ────────────────────────────────────────────────────────

Widget adminHomeScreenButton(
  BuildContext context, {
  required String label,
  required VoidCallback onTap,
  required String imagePath,
  double imageScale = 1,
  required Color color,
}) {
  return SizedBox(
    height: 150,
    child: ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(backgroundColor: color),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: fitnesscoText(
                label,
                textAlign: TextAlign.left,
                textStyle: whiteBoldStyle(size: 25),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Transform.scale(
              scale: imageScale,
              child: Image.asset(imagePath, height: 150),
            ),
          ),
        ],
      ),
    ),
  );
}

// ─── Simple text field (forms) ────────────────────────────────────────────────

Widget fitnesscoFormTextField(
  String text,
  TextInputType textInputType,
  TextEditingController controller, {
  IconData? icon,
  int maxLines = 1,
  bool enabled = true,
}) {
  return TextField(
    controller: controller,
    obscureText: textInputType == TextInputType.visiblePassword,
    enabled: enabled,
    maxLines: textInputType == TextInputType.multiline ? maxLines : 1,
    cursorColor: AppColors.purpleSnail,
    style: GoogleFonts.nunitoSans(
      textStyle: const TextStyle(color: AppColors.purpleSnail),
    ),
    decoration: InputDecoration(
      prefixIcon:
          icon != null ? Icon(icon, color: AppColors.purpleSnail) : null,
      labelText: text,
      labelStyle: GoogleFonts.nunitoSans(
        textStyle: const TextStyle(color: AppColors.purpleSnail),
      ),
      alignLabelWithHint: true,
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withValues(alpha: 0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(width: 1, color: AppColors.nearMoon),
      ),
    ),
    keyboardType: textInputType,
  );
}

// ─── Screen scaffold helpers ──────────────────────────────────────────────────

class FitnesscoScreenShell extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final bool extendBodyBehindAppBar;

  const FitnesscoScreenShell({
    super.key,
    this.appBar,
    required this.body,
    this.extendBodyBehindAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      appBar: appBar,
      body: body,
    );
  }
}
