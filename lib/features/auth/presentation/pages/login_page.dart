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

/// Login screen for existing users.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
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
                              'auth.login.title'.tr(),
                              style: AppTextStyles.headlineLarge.copyWith(
                                color: AppColors.textPrimaryLight,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 6.h),

                            // Subtitle
                            Text(
                              'auth.login.subtitle'.tr(),
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondaryLight,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 32.h),

                            // Email
                            AuthTextField(
                              controller: _emailController,
                              labelText: 'auth.login.email_label'.tr(),
                              hintText: 'auth.login.email_hint'.tr(),
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
                              labelText: 'auth.login.password_label'.tr(),
                              hintText: 'auth.login.password_hint'.tr(),
                              prefixIcon: Icons.lock_outlined,
                              obscureText: true,
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'auth.errors.password_required'.tr();
                                }
                                return null;
                              },
                            ),

                            const Spacer(),

                            // Login button
                            CustomButton(
                              text: 'auth.login.button'.tr(),
                              isLoading: isLoading,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<AuthCubit>().signIn(
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text,
                                  );
                                }
                              },
                            ),
                            SizedBox(height: 16.h),

                            // Go to sign up
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'auth.login.no_account'.tr(),
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textSecondaryLight,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => context.go(AppRoutes.signUp),
                                  child: Text(
                                    'auth.login.sign_up_link'.tr(),
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
