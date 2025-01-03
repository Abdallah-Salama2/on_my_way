import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_my_way/core/utils/app_routes.dart';
import 'package:on_my_way/core/utils/extensions.dart';
import 'package:on_my_way/features/cart/providers/cart_provider.dart';

import '../../../core/shared/widgets/back_button.dart';
import '../../../core/styles/app_colors.dart';

class PaymentScreen extends ConsumerWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const verticalSpace = SliverToBoxAdapter(child: SizedBox(height: 12));
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            floating: false,
            pinned: false,
            snap: false,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            clipBehavior: Clip.antiAlias,
            title: Text(
              'Payment',
              style: TextStyle(color: AppColors.darkGunMetal),
            ),
            leadingWidth: 60,
            leading: Row(
              children: [
                SizedBox(width: 15),
                BackButtonWidget(
                  color: AppColors.brightGray,
                  iconColor: AppColors.darkGunMetal,
                ),
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
          ),
          verticalSpace,
          verticalSpace,
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.only(left: 16),
              height: 120,
              child: ListView(
                  clipBehavior: Clip.none,
                  scrollDirection: Axis.horizontal,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 110,
                            height: 90,
                            margin: const EdgeInsets.only(bottom: 7),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: AppColors.antiFlashWhite,
                              border: Border.all(
                                color: AppColors.pumpkinOrange,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: SizedBox(
                                height: 24,
                                width: 24,
                                child: Image.asset(
                                  'assets/cash.png',
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Text(
                          'Cash',
                          style: TextStyle(
                            color: AppColors.cadetGrey,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ]),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            fillOverscroll: true,
            child: Column(
              children: [
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12,
                  ),
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'TOTAL:',
                            style: TextStyle(
                              color: AppColors.cadetGrey,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "${ref.read(cartProvider).requireValue.totalPrice.roundedToHundredth.toString()}EGP",
                            style: textTheme.headlineLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      ElevatedButton(
                        onPressed: ref.watch(cartProvider).isReloading
                            ? null
                            : () async {
                                await ref
                                    .read(cartProvider.notifier)
                                    .createOrder();

                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.success,
                                  headerAnimationLoop: false,
                                  animType: AnimType.bottomSlide,
                                  title: 'Congratulations!',
                                  desc:
                                      'You successfully made a payment.\nYou can track it now from your Orders.',
                                  buttonsTextStyle:
                                      const TextStyle(color: Colors.black),
                                  btnOkText: 'Go to Orders',
                                  dismissOnBackKeyPress: false,
                                  dismissOnTouchOutside: false,
                                  btnOkOnPress: () {
                                    
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                      AppRoutes.ordersScreen,
                                      (route) =>
                                          route.settings.name ==
                                          AppRoutes.homeScreen,
                                    );
                                  },
                                ).show();
                              },
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size.fromHeight(62),
                        ),
                        child: const Text('PAY & CONFIRM'),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
