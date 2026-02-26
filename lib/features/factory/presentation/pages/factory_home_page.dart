import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../injection_container.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

/// Placeholder Factory Home screen.
class FactoryHomePage extends StatelessWidget {
  const FactoryHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthCubit>(),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            context.go(AppRoutes.login);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.backgroundLight,
          appBar: AppBar(
            title: Text('factory_home.title'.tr()),
            centerTitle: true,
            actions: [
              Builder(
                builder: (context) {
                  return IconButton(
                    icon: const Icon(Icons.logout_rounded),
                    tooltip: 'factory_home.sign_out'.tr(),
                    onPressed: () {
                      context.read<AuthCubit>().signOut();
                    },
                  );
                },
              ),
            ],
          ),
          body: Center(
            child: Text(
              'factory_home.title'.tr(),
              style: AppTextStyles.headlineLarge.copyWith(
                color: AppColors.textPrimaryLight,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
