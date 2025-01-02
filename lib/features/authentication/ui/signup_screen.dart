import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_my_way/core/shared/widgets/back_button.dart';

import 'package:on_my_way/core/shared/widgets/dynamic_form_field.dart';
import 'package:on_my_way/core/styles/app_colors.dart';
import 'package:form_validator/form_validator.dart';

import '../../../core/shared/helpers/ftoast_helper.dart';
import '../../../core/utils/app_routes.dart';
import '../../../core/utils/enums.dart';
import '../providers/auth_provider.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    addressController.dispose();
    formKey.currentState?.dispose();

    super.dispose();
  }

  void signUp() async {
    final nav = Navigator.of(context);
    final authNotifier = ref.read(authStateProvider.notifier);
    if (formKey.currentState?.validate() != true) {
      FtoastHelper.showErrorToast('Please fill out the form');
      return;
    }
    await authNotifier.register(
      email: emailController.text,
      password: passwordController.text,
      passwordConfirmation: confirmPasswordController.text,
      address: addressController.text,
      phoneNumber: phoneController.text,
      name: nameController.text,
    );
    final authState = ref.read(authStateProvider);
    if (authState.requestState == RequestState.error &&
        authState.authMessage.isNotEmpty) {
      FtoastHelper.showErrorToast(authState.authMessage);
    }
    if (authState.requestState == RequestState.loaded) {
      nav.pushReplacementNamed(
        AppRoutes.chooseServiceScreen,
      );
      FtoastHelper.showSuccessToast(authState.authMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
                  flex: 1,
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          "Sign Up",
                          style: textTheme.displaySmall?.copyWith(
                            color: AppColors.pumpkinOrange,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Please sign up to get started",
                          style: textTheme.titleMedium?.copyWith(
                            color: AppColors.cadetGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
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
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 22),

                          const Text("NAME"),
                          const SizedBox(height: 5),
                          DynamicFormField(
                            controller: nameController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: ValidationBuilder().minLength(3).build(),
                          ),

                          const SizedBox(height: 16),
                          //
                          const Text("EMAIL"),
                          const SizedBox(height: 5),
                          DynamicFormField(
                            controller: emailController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: ValidationBuilder().email().build(),
                          ),

                          const SizedBox(height: 16),
                          //
                          const Text("PASSWORD"),
                          const SizedBox(height: 5),
                          DynamicFormField(
                            obscureText: true,
                            controller: passwordController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: ValidationBuilder().minLength(6).build(),
                          ),

                          const SizedBox(height: 16),
                          //
                          const Text("CONFIRM PASSWORD"),
                          const SizedBox(height: 5),
                          DynamicFormField(
                            obscureText: true,
                            controller: confirmPasswordController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == passwordController.value.text) {
                                return null;
                              }
                              return 'Passwords must match';
                            },
                          ),

                          const SizedBox(height: 16),
                          //
                          const Text("PHONE"),
                          const SizedBox(height: 5),
                          DynamicFormField(
                            controller: phoneController,
                          ),

                          const SizedBox(height: 16),
                          //
                          const Text("ADDRESS"),
                          const SizedBox(height: 5),
                          DynamicFormField(
                            controller: addressController,
                          ),

                          const SizedBox(height: 22),

                          ElevatedButton(
                            onPressed: () async {
                              signUp();
                            },
                            style: Theme.of(context)
                                .elevatedButtonTheme
                                .style
                                ?.copyWith(
                                    minimumSize: const WidgetStatePropertyAll(
                                        Size.fromHeight(62))),
                            child: Text(
                              'SIGN UP',
                              style: textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 22),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
