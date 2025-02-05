import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_my_way/core/utils/enums.dart';

import '../../../core/shared/widgets/back_button.dart';
import '../../../core/shared/widgets/dynamic_form_field.dart';
import '../../../core/styles/app_colors.dart';
import '../providers/auth_provider.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final authNotifier = ref.read(authStateProvider.notifier);
    final authState = ref.watch(authStateProvider);
    return Scaffold(
      backgroundColor: AppColors.antiFlashWhite,
      body: SafeArea(
        child: Stack(
          children: [
            const Positioned(
              top: 15,
              left: 15,
              child: BackButtonWidget(),
            ),
            Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        "Forgot Password",
                        style: textTheme.displaySmall?.copyWith(
                          color: AppColors.pumpkinOrange,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Please enter your email",
                        style: textTheme.titleMedium?.copyWith(
                          color: AppColors.cadetGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 22),
                        const Text("EMAIL"),
                        const SizedBox(height: 5),
                        DynamicFormField(
                          controller: emailController,
                        ),
                        const SizedBox(height: 22),
                        ElevatedButton(
                          onPressed: authState.requestState.isLoading
                              ? null
                              : () async {
                                  final success = await authNotifier
                                      .sendEmail(emailController.text);
                                  if (success) {
                                    Navigator.of(context).pop();
                                  }
                                },
                          style: Theme.of(context)
                              .elevatedButtonTheme
                              .style
                              ?.copyWith(
                                minimumSize: const WidgetStatePropertyAll(
                                  Size.fromHeight(62),
                                ),
                              ),
                          child: authState.requestState.isLoading
                              ? const CircularProgressIndicator()
                              : Text(
                                  'SEND CODE',
                                  style: textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
