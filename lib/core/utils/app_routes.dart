import 'package:flutter/widgets.dart';
import 'package:on_my_way/features/authentication/ui/login_screen.dart';
import 'package:on_my_way/features/authentication/ui/signup_screen.dart';
import 'package:on_my_way/features/authentication/ui/forgot_password_screen.dart';
import 'package:on_my_way/features/cart/ui/cart_screen.dart';
import 'package:on_my_way/features/go_food/ui/category_items_screen.dart';

import 'package:on_my_way/features/go_food/ui/restaurant_screen.dart';
import 'package:on_my_way/features/home/ui/choose_service_screen.dart';
import 'package:on_my_way/features/home/ui/home_screen.dart';
import 'package:on_my_way/features/onboarding/ui/onboarding_screen.dart';
import 'package:on_my_way/features/settings/ui/edit_profile_screen.dart';
import 'package:on_my_way/features/settings/ui/personal_info_screen.dart';

class AppRoutes {
  static final _instance = AppRoutes._();
  factory AppRoutes() {
    return _instance;
  }
  AppRoutes._();

  static const String onboardingScreen = '/onboarding-screen';
  static const String loginScreen = '/login';
  static const String signUpScreen = '/sign-up';
  static const String chooseServiceScreen = '/choose-service';
  static const String homeScreen = '/home';
  static const String forgotPasswordScreen = '/forgot-password';
  static const String personalInfoScreen = '/personal-info';
  static const String editProfileScreen = '/edit-profile';
  static const String restaurantScreen = '/restaurant';
  static const String cartScreen = '/cart';
  static const String categoryItemsScreen = '/category-items';

  final Map<String, Widget Function(BuildContext context)> routes = {
    onboardingScreen: (context) => const OnboardingScreen(),
    loginScreen: (context) => const LoginScreen(),
    signUpScreen: (context) => const SignUpScreen(),
    forgotPasswordScreen: (context) => const ForgotPasswordScreen(),
    chooseServiceScreen: (context) => const ChooseServiceScreen(),
    homeScreen: (context) => const HomeScreen(),
    personalInfoScreen: (context) => const PersonalInfoScreen(),
    editProfileScreen: (context) => const EditProfileScreen(),
    restaurantScreen: (context) => const RestaurantScreen(),
    cartScreen: (context) => const CartScreen(),
    categoryItemsScreen: (context) => const CategoryItemsScreen(),
  };
}
