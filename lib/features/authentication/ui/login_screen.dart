import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:on_my_way/core/shared/helpers/ftoast_helper.dart';

import 'package:on_my_way/core/shared/widgets/dynamic_form_field.dart';
import 'package:on_my_way/core/styles/app_colors.dart';
import 'package:on_my_way/core/utils/app_routes.dart';
import 'package:on_my_way/core/utils/enums.dart';
import 'package:on_my_way/features/authentication/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool rememberMe = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final authState = ref.watch(authStateProvider);
    final authNotifier = ref.read(authStateProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.antiFlashWhite,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Log In",
                    style: textTheme.displaySmall?.copyWith(
                      color: AppColors.pumpkinOrange,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Please sign in to your existing account",
                    style: textTheme.titleMedium?.copyWith(
                      color: AppColors.cadetGrey,
                    ),
                  ),
                ],
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
                      const Text("EMAIL"),
                      const SizedBox(height: 5),
                      DynamicFormField(
                        controller: emailController,
                      ),

                      const SizedBox(height: 16),

                      //
                      const Text("PASSWORD"),
                      const SizedBox(height: 5),
                      DynamicFormField(
                        obscureText: true,
                        controller: passwordController,
                      ),

                      const SizedBox(height: 16),

                      //
                      Row(
                        children: [
                          Checkbox(
                            value: rememberMe,
                            activeColor: AppColors.pumpkinOrange,
                            side: const BorderSide(
                              color: AppColors.brightGray,
                              width: 2,
                            ),
                            onChanged: (value) {
                              setState(() {
                                rememberMe = value!;
                              });
                            },
                          ),
                          Text(
                            'Remember me',
                            style: textTheme.bodyMedium?.copyWith(
                              color: AppColors.romanSilver,
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(AppRoutes.forgotPasswordScreen);
                            },
                            child: Text(
                              'Forgot Password',
                              style: textTheme.bodyMedium?.copyWith(
                                color: AppColors.pumpkinOrange,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      //
                      ElevatedButton(
                        onPressed:authState.requestState.isLoading ? null : () async {
                          final nav = Navigator.of(context);
                          await authNotifier.logIn(
                            email: emailController.text,
                            password: passwordController.text,
                            stayLoggedIn: rememberMe,
                          );
                          final authState = ref.read(authStateProvider);

                          if (authState.requestState == RequestState.error) {
                            FtoastHelper.showErrorToast(authState.authMessage);
                          } else if (authState.requestState ==
                              RequestState.loaded) {
                            nav.pushReplacementNamed(
                                AppRoutes.chooseServiceScreen);
                          }
                        },
                        style: Theme.of(context)
                            .elevatedButtonTheme
                            .style
                            ?.copyWith(
                                minimumSize: const WidgetStatePropertyAll(
                                    Size.fromHeight(62))),
                        child: Text(
                          'LOG IN',
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      //
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: textTheme.bodyLarge?.copyWith(
                              color: AppColors.darkElectricBlue,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(AppRoutes.signUpScreen);
                            },
                            child: Text(
                              'SIGN UP',
                              style: textTheme.bodyLarge?.copyWith(
                                  color: AppColors.pumpkinOrange,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
