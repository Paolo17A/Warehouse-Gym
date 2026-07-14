import 'package:the_warehouse_gym/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Full-screen loading overlay matching the original stackedLoadingContainer.
class AuthLoadingStack extends StatelessWidget {
  final bool isLoading;
  final List<Widget> children;

  const AuthLoadingStack({
    super.key,
    required this.isLoading,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ...children,
        if (isLoading)
          ColoredBox(
            color: Colors.black.withValues(alpha: 0.5),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}

/// register.png background used on sign-up.
class RegisterAuthBackground extends StatelessWidget {
  final Widget child;

  const RegisterAuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/backgrounds/register.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: child,
      ),
    );
  }
}

/// loading.png background used on sign-in.
class LoadingAuthBackground extends StatelessWidget {
  final Widget child;

  const LoadingAuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/backgrounds/loading.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: child,
      ),
    );
  }
}

/// White rounded card used on auth screens.
class AuthRoundedCard extends StatelessWidget {
  final Widget child;
  final double heightFactor;
  final double widthFactor;

  const AuthRoundedCard({
    super.key,
    required this.child,
    this.heightFactor = 0.5,
    this.widthFactor = 0.8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * widthFactor,
      height: MediaQuery.of(context).size.height * heightFactor,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: child,
    );
  }
}

/// Logo header on the sign-in screen.
class SignInLogoHeader extends StatelessWidget {
  const SignInLogoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Transform.scale(
        scale: 0.75,
        child: Image.asset('assets/images/warehouse.png'),
      ),
    );
  }
}

/// Logo header on the sign-up screen.
class SignUpLogoHeader extends StatelessWidget {
  const SignUpLogoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: ColoredBox(
        color: Colors.white,
        child: SizedBox(
          width: 200,
          height: 90,
          child: Image.asset(
            'assets/images/warehouse.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

/// Gradient pill button matching gradientOvalButton from fitnessco v1.
class AuthGradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final double width;
  final double? height;

  const AuthGradientButton({
    super.key,
    required this.label,
    required this.onTap,
    this.width = 250,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [AppColors.plasmaTrail, AppColors.nightSnow],
        ),
      ),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.nunitoSans(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

/// Text field matching FitnesscoTextField from fitnessco v1.
class FitnesscoTextField extends StatefulWidget {
  final String text;
  final TextEditingController controller;
  final TextInputType textInputType;
  final Icon? displayPrefixIcon;
  final bool enabled;

  const FitnesscoTextField({
    super.key,
    required this.text,
    required this.controller,
    required this.textInputType,
    required this.displayPrefixIcon,
    this.enabled = true,
  });

  @override
  State<FitnesscoTextField> createState() => _FitnesscoTextFieldState();
}

class _FitnesscoTextFieldState extends State<FitnesscoTextField> {
  late bool isObscured;

  @override
  void initState() {
    super.initState();
    isObscured = widget.textInputType == TextInputType.visiblePassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: widget.enabled,
      controller: widget.controller,
      obscureText: isObscured,
      cursorColor: AppColors.purpleSnail,
      style: const TextStyle(color: AppColors.purpleSnail),
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: widget.text,
        labelStyle: TextStyle(
          color: AppColors.purpleSnail.withValues(alpha: 0.5),
          fontStyle: FontStyle.italic,
        ),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.white.withValues(alpha: 0.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: AppColors.purpleSnail,
            width: 3.0,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        prefixIcon: widget.displayPrefixIcon,
        suffixIcon: widget.textInputType == TextInputType.visiblePassword
            ? IconButton(
                onPressed: () => setState(() => isObscured = !isObscured),
                icon: Icon(
                  isObscured ? Icons.visibility : Icons.visibility_off,
                  color: AppColors.purpleSnail.withValues(alpha: 0.6),
                ),
              )
            : null,
      ),
      keyboardType: widget.textInputType,
      maxLines: widget.textInputType == TextInputType.multiline ? 4 : 1,
    );
  }
}

TextStyle authBoldTextStyle({double size = 20}) {
  return GoogleFonts.nunitoSans(
    fontSize: size,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );
}
