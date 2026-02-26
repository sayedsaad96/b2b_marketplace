import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../injection_container.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_text_field.dart';

/// Sign-up screen for new users.
///
/// Expects the selected role passed via [GoRouterState.extra].
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key, required this.role});

  /// Pre-selected role from the Role Selection screen.
  final String role;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: SafeArea(
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthAuthenticated) {
                final role = state.userProfile.role;
                switch (role) {
                  case 'brand':
                    context.go(AppRoutes.brandHome);
                  case 'factory':
                    context.go(AppRoutes.factoryHome);
                  case 'admin':
                    context.go(AppRoutes.adminDashboard);
                  default:
                    context.go(AppRoutes.login);
                }
              } else if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            builder: (context, state) {
              final isLoading = state is AuthLoading;
              return CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: 60.h),

                            // Title
                            Text(
                              'auth.signup.title'.tr(),
                              style: AppTextStyles.headlineLarge.copyWith(
                                color: AppColors.textPrimaryLight,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 6.h),

                            // Subtitle with role
                            Text(
                              'auth.signup.subtitle'.tr(
                                namedArgs: {
                                  'role': widget.role == 'brand'
                                      ? 'role_selection.brand'.tr()
                                      : 'role_selection.factory'.tr(),
                                },
                              ),
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondaryLight,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 32.h),

                            // Full name
                            AuthTextField(
                              controller: _nameController,
                              labelText: 'auth.signup.name_label'.tr(),
                              hintText: 'auth.signup.name_hint'.tr(),
                              prefixIcon: Icons.person_outlined,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'auth.errors.name_required'.tr();
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.h),

                            // Email
                            AuthTextField(
                              controller: _emailController,
                              labelText: 'auth.signup.email_label'.tr(),
                              hintText: 'auth.signup.email_hint'.tr(),
                              prefixIcon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'auth.errors.email_required'.tr();
                                }
                                if (!value.contains('@')) {
                                  return 'auth.errors.email_invalid'.tr();
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.h),

                            // Password
                            AuthTextField(
                              controller: _passwordController,
                              labelText: 'auth.signup.password_label'.tr(),
                              hintText: 'auth.signup.password_hint'.tr(),
                              prefixIcon: Icons.lock_outlined,
                              obscureText: true,
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'auth.errors.password_required'.tr();
                                }
                                if (value.length < 6) {
                                  return 'auth.errors.password_short'.tr();
                                }
                                return null;
                              },
                            ),

                            const Spacer(),

                            // Sign up button
                            CustomButton(
                              text: 'auth.signup.button'.tr(),
                              isLoading: isLoading,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<AuthCubit>().signUp(
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text,
                                    fullName: _nameController.text.trim(),
                                    role: widget.role,
                                  );
                                }
                              },
                            ),
                            SizedBox(height: 16.h),

                            // Go to login
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'auth.signup.has_account'.tr(),
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textSecondaryLight,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => context.go(AppRoutes.login),
                                  child: Text(
                                    'auth.signup.login_link'.tr(),
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 24.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
