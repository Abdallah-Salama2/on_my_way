import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_my_way/core/styles/app_colors.dart';
import 'package:on_my_way/core/utils/app_routes.dart';
import 'package:on_my_way/core/utils/enums.dart';
import 'package:on_my_way/features/authentication/providers/auth_provider.dart';
import 'package:on_my_way/features/home/providers/home_state_provider.dart';
import 'package:on_my_way/features/settings/ui/widgets/settings_tile.dart';

/// [SettingsBody] is not called a screen because it's not a scaffold
/// and is a part of [HomeScreen]'s navigation and doesn't have it's own route
///
/// Check `features/home/ui/home_screen.dart` for more details
class SettingsBody extends ConsumerWidget {
  const SettingsBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final borderRadius = BorderRadius.circular(16);
    final textTheme = Theme.of(context).textTheme;

    final homeState = ref.watch(homeStateProvider);
    final profileData = ref.read(authStateProvider).authEntity?.data.user;
    final authNotifier = ref.read(authStateProvider.notifier);
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16),
            child: Text(
              'Profile',
              style: textTheme.titleLarge?.copyWith(
                color: AppColors.pumpkinOrange,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const CircleAvatar(
                radius: 50,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 22.0,
                  left: 44,
                ),
                child: Text(
                  profileData?.name ?? 'Name',
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Material(
            clipBehavior: Clip.antiAlias,
            borderRadius: borderRadius,
            child: Column(
              children: [
                SettingsTile(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(AppRoutes.personalInfoScreen);
                  },
                  icon: const Icon(
                    CupertinoIcons.person,
                    color: AppColors.pumpkinOrange,
                  ),
                  titleText: 'Personal Info',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Material(
            clipBehavior: Clip.antiAlias,
            borderRadius: borderRadius,
            child: Column(
              children: [
                if (homeState.selectedServiceType!.isEcommerce) ...[
                  SettingsTile(
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.cartScreen);
                    },
                    icon: const Icon(
                      CupertinoIcons.cart,
                      color: AppColors.brilliantAzure,
                    ),
                    titleText: 'Cart',
                  ),
                  SettingsTile(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(AppRoutes.favoritesScreen);
                    },
                    icon: const Icon(
                      CupertinoIcons.heart,
                      color: AppColors.purpleX11,
                    ),
                    titleText: 'Favorite',
                  ),
                ],
                SettingsTile(
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.ordersScreen);
                  },
                  icon: const Icon(
                    Icons.receipt_long,
                    color: AppColors.chromeYellow,
                  ),
                  titleText: 'Orders',
                ),
                SettingsTile(
                  onTap: () {},
                  icon: const Icon(
                    CupertinoIcons.creditcard,
                    color: AppColors.brilliantAzure,
                  ),
                  titleText: 'Payment method',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Material(
            clipBehavior: Clip.antiAlias,
            borderRadius: borderRadius,
            child: Column(
              children: [
                SettingsTile(
                  onTap: () {},
                  icon: const Icon(
                    CupertinoIcons.question_circle,
                    color: AppColors.pumpkinOrange,
                  ),
                  titleText: 'FAQs',
                ),
                SettingsTile(
                  onTap: () {},
                  icon: const Icon(
                    CupertinoIcons.envelope,
                    color: AppColors.turquoise,
                  ),
                  titleText: 'Support',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Material(
            clipBehavior: Clip.antiAlias,
            borderRadius: borderRadius,
            child: Column(
              children: [
                SettingsTile(
                  onTap: () {
                    authNotifier.logOut();

                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.loginScreen,
                      (Route<dynamic> route) => false,
                    );
                  },
                  icon: const Icon(
                    CupertinoIcons.square_arrow_right,
                    color: AppColors.orangeRed,
                  ),
                  titleText: 'Log Out',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
