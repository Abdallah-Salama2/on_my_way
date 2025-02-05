import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_my_way/core/shared/widgets/back_button.dart';
import 'package:on_my_way/core/utils/app_routes.dart';

import '../../../core/styles/app_colors.dart';
import '../../authentication/providers/auth_provider.dart';
import 'widgets/settings_tile.dart';

class PersonalInfoScreen extends ConsumerWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final borderRadius = BorderRadius.circular(16);
    final textTheme = Theme.of(context).textTheme;

    final profileData = ref.read(authStateProvider).authEntity?.data.user;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(22),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const BackButtonWidget(
                  iconColor: AppColors.pumpkinOrange,
                  color: AppColors.antiFlashWhite,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    'Personal Info',
                    style: textTheme.titleLarge?.copyWith(
                      color: AppColors.pumpkinOrange,
                    ),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(AppRoutes.editProfileScreen);
                  },
                  child: const Text(
                    'EDIT',
                    style: TextStyle(
                      color: AppColors.pumpkinOrange,
                      decoration: TextDecoration.underline,
                      decorationThickness: 2,
                      decorationColor: AppColors.pumpkinOrange,
                    ),
                  ),
                ),
              ],
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
                    icon: const Icon(
                      CupertinoIcons.person,
                      color: AppColors.pumpkinOrange,
                    ),
                    titleText: 'FULL NAME',
                    subtitleText: profileData?.name,
                    trailing: null,
                  ),
                  SettingsTile(
                    icon: const Icon(
                      CupertinoIcons.mail,
                      color: AppColors.palatinateBlue,
                    ),
                    titleText: 'EMAL',
                    subtitleText: profileData?.email,
                    trailing: null,
                  ),
                  SettingsTile(
                    icon: const Icon(
                      CupertinoIcons.phone,
                      color: AppColors.brilliantAzure,
                    ),
                    titleText: 'PHONE NUMBER',
                    subtitleText: profileData?.phone,
                    trailing: null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
