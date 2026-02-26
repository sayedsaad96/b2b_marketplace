import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../widgets/role_card.dart';

/// Enum for user roles.
enum UserRole { brand, factory_ }

/// Role selection screen — Brand or Factory.
class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({super.key});

  @override
  State<RoleSelectionPage> createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {
  UserRole? _selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 40.h),

                    // Title
                    Text(
                      'role_selection.title'.tr(),
                      style: AppTextStyles.headlineLarge.copyWith(
                        color: AppColors.textPrimaryLight,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 6.h),

                    // Subtitle
                    Text(
                      'role_selection.subtitle'.tr(),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondaryLight,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 32.h),

                    // Brand card
                    RoleCard(
                      titleKey: 'role_selection.brand',
                      descriptionKey: 'role_selection.brand_desc',
                      icon: Icons.store_rounded,
                      isSelected: _selectedRole == UserRole.brand,
                      onTap: () {
                        setState(() => _selectedRole = UserRole.brand);
                      },
                    ),

                    SizedBox(height: 12.h),

                    // Factory card
                    RoleCard(
                      titleKey: 'role_selection.factory',
                      descriptionKey: 'role_selection.factory_desc',
                      icon: Icons.precision_manufacturing_rounded,
                      isSelected: _selectedRole == UserRole.factory_,
                      onTap: () {
                        setState(() => _selectedRole = UserRole.factory_);
                      },
                    ),

                    const Spacer(),

                    // Continue button → navigate to sign-up
                    CustomButton(
                      text: 'role_selection.continue_btn'.tr(),
                      onPressed: _selectedRole != null
                          ? () {
                              final roleString = _selectedRole == UserRole.brand
                                  ? 'brand'
                                  : 'factory';
                              context.go(AppRoutes.signUp, extra: roleString);
                            }
                          : null,
                      isDisabled: _selectedRole == null,
                    ),

                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
