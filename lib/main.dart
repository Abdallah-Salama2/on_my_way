import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:on_my_way/core/shared/helpers/dio_helper.dart';
import 'package:on_my_way/core/shared/helpers/hive_helper.dart';
import 'package:on_my_way/core/styles/app_colors.dart';
import 'package:on_my_way/core/utils/app_routes.dart';
import 'package:on_my_way/features/authentication/providers/auth_provider.dart';

import 'core/utils/providers_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and Hive Flutter
  await Hive.initFlutter();
  // HiveHelper.clearAllData();
  await HiveHelper.init();

  DioHelper.init();
  EquatableConfig.stringify = true;

  runApp(
    ProviderScope(
      observers: [ProvidersObserver()],
      child: const OnMyWayApp(),
    ),
  );
}

class OnMyWayApp extends ConsumerWidget {
  const OnMyWayApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final bool isAuth = (authState.authEntity != null);
    return MaterialApp(
      title: 'On My Way',
      routes: AppRoutes().routes,
      initialRoute:
          // AppRoutes.onboardingScreen,
          isAuth ? AppRoutes.chooseServiceScreen : AppRoutes.onboardingScreen,
      theme: ThemeData(
        colorSchemeSeed: AppColors.pumpkinOrange,
        textTheme: GoogleFonts.senTextTheme(),
        primaryTextTheme: GoogleFonts.senTextTheme(),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            backgroundColor: AppColors.pumpkinOrange,
            foregroundColor: AppColors.white,
            textStyle: GoogleFonts.senTextTheme().titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
            minimumSize: const Size.fromHeight(52),
          ),
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: AppColors.pumpkinOrange,
          selectionColor: AppColors.brightGray,
          selectionHandleColor: AppColors.pumpkinOrange,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.darkElectricBlue,
            textStyle: GoogleFonts.senTextTheme().titleLarge,
          ),
        ),
      ),
      
    );
  }
}
