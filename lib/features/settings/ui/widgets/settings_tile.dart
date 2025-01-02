import 'package:flutter/material.dart';
import 'package:on_my_way/core/styles/app_colors.dart';

class SettingsTile extends StatelessWidget {
  final void Function()? onTap;
  final Widget icon;
  final String titleText;
  final String? subtitleText;
  final Widget? trailing;

  const SettingsTile({
    super.key,
    this.onTap,
    required this.icon,
    required this.titleText,
    this.trailing,
    this.subtitleText,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ListTile(
      tileColor: AppColors.antiFlashWhite,
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        child: icon,
      ),
      title: Text(
        titleText,
        style: textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitleText != null ? Text(subtitleText!) : null,
      trailing: trailing == null
          ? null
          : const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 20,
              color: AppColors.davysGrey,
            ),
    );
  }
}
