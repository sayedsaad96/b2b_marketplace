import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../bloc/onboarding_cubit.dart';
import '../widgets/onboarding_slide.dart';

/// Onboarding screen with 3 swipable slides.
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext(OnboardingCubit cubit) {
    if (cubit.isLastPage) {
      context.go(AppRoutes.roleSelection);
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onSkip() {
    context.go(AppRoutes.roleSelection);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: SafeArea(
          child: BlocBuilder<OnboardingCubit, OnboardingState>(
            builder: (context, state) {
              final cubit = context.read<OnboardingCubit>();
              return Column(
                children: [
                  // Skip button
                  Align(
                    alignment: AlignmentDirectional.topEnd,
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: TextButton(
                        onPressed: cubit.isLastPage ? null : _onSkip,
                        child: Text(
                          'onboarding.skip'.tr(),
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: cubit.isLastPage
                                ? AppColors.disabled
                                : AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Page slides
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: cubit.setPage,
                      children: [
                        OnboardingSlide(
                          icon: Icons.factory_rounded,
                          title: 'onboarding.title_1'.tr(),
                          description: 'onboarding.desc_1'.tr(),
                          color: AppColors.primary,
                        ),
                        OnboardingSlide(
                          icon: Icons.connect_without_contact,
                          title: 'onboarding.title_2'.tr(),
                          description: 'onboarding.desc_2'.tr(),
                          color: AppColors.secondary,
                        ),
                        OnboardingSlide(
                          icon: Icons.rocket_launch_rounded,
                          title: 'onboarding.title_3'.tr(),
                          description: 'onboarding.desc_3'.tr(),
                          color: AppColors.success,
                        ),
                      ],
                    ),
                  ),

                  // Dots indicator
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: OnboardingCubit.totalPages,
                    effect: ExpandingDotsEffect(
                      activeDotColor: AppColors.primary,
                      dotColor: AppColors.disabled,
                      dotHeight: 8.h,
                      dotWidth: 8.w,
                      expansionFactor: 3,
                      spacing: 6.w,
                    ),
                  ),

                  SizedBox(height: 32.h),

                  // Bottom button
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: CustomButton(
                      text: cubit.isLastPage
                          ? 'onboarding.get_started'.tr()
                          : 'onboarding.next'.tr(),
                      onPressed: () => _onNext(cubit),
                    ),
                  ),

                  SizedBox(height: 32.h),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
