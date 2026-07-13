import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.nightSnow),
        scaffoldBackgroundColor: const Color.fromARGB(255, 245, 245, 245),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: AppColors.purpleSnail,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.nightSnow,
          showSelectedLabels: true,
          showUnselectedLabels: false,
        ),
        dialogTheme: const DialogThemeData(
          backgroundColor: AppColors.plasmaTrail,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        listTileTheme: const ListTileThemeData(
          iconColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.all(Radius.circular(10)),
            ),
            backgroundColor: AppColors.purpleSnail,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.purpleSnail,
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        tabBarTheme: const TabBarThemeData(labelColor: Colors.black),
      );
}
