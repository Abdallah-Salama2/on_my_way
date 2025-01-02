import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_my_way/core/shared/widgets/dynamic_form_field.dart';

import '../../../core/shared/widgets/back_button.dart';
import '../../../core/styles/app_colors.dart';
import '../../authentication/providers/auth_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController bioController;

  @override
  void initState() {
    super.initState();
    final profileData = ref.read(authStateProvider).authEntity?.data.user;
    nameController = TextEditingController(text: profileData?.name);
    emailController = TextEditingController(text: profileData?.email);
    phoneController = TextEditingController(text: profileData?.phone);
    bioController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
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
                    'Edit Profile',
                    style: textTheme.titleLarge?.copyWith(
                      color: AppColors.pumpkinOrange,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 65,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton.filled(
                      onPressed: () {},
                      style: const ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(AppColors.pumpkinOrange)),
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),

            //
            const SizedBox(height: 12),
            const Text('FULL NAME'),
            const SizedBox(height: 5),
            DynamicFormField(
              controller: nameController,
            ),

            //
            const SizedBox(height: 12),
            const Text('EMAIL'),
            const SizedBox(height: 5),
            DynamicFormField(
              controller: emailController,
            ),

            //
            const SizedBox(height: 12),
            const Text('PHONE NUMBER'),
            const SizedBox(height: 5),
            DynamicFormField(
              controller: phoneController,
            ),

            //
            const SizedBox(height: 12),
            const Text('BIO'),
            const SizedBox(height: 5),
            DynamicFormField(
              maxLines: 5,
              controller: bioController,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(62),
              ),
              child: const Text('SAVE'),
            ),
          ],
        ),
      ),
    );
  }
}
