import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../bloc/factory_dashboard_cubit.dart';
import '../bloc/factory_dashboard_state.dart';
import '../../../notifications/presentation/widgets/notification_badge.dart';

class FactoryDashboardPage extends StatefulWidget {
  const FactoryDashboardPage({super.key});

  @override
  State<FactoryDashboardPage> createState() => _FactoryDashboardPageState();
}

class _FactoryDashboardPageState extends State<FactoryDashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<FactoryDashboardCubit>().loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('factory.dashboard'.tr()),
        actions: [
          const NotificationBadge(),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.pushNamed(AppRoutes.myProfile),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Sign out logic
              context.goNamed(AppRoutes.login);
            },
          ),
        ],
      ),
      body: BlocBuilder<FactoryDashboardCubit, FactoryDashboardState>(
        builder: (context, state) {
          if (state is FactoryDashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FactoryDashboardError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: const TextStyle(color: AppColors.error),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<FactoryDashboardCubit>().loadDashboard(),
                    child: Text('common.retry'.tr()),
                  ),
                ],
              ),
            );
          } else if (state is FactoryDashboardLoaded) {
            return RefreshIndicator(
              onRefresh: () =>
                  context.read<FactoryDashboardCubit>().loadDashboard(),
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  _buildStatsSection(state.stats),
                  const SizedBox(height: 24),
                  _buildQuickActions(context),
                  const SizedBox(height: 24),
                  _buildRecentRfqs(context, state),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildStatsSection(Map<String, int> stats) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: 'factory.stats.new_rfqs'.tr(),
            value: stats['newRfqs'].toString(),
            icon: Icons.mark_email_unread_outlined,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            title: 'factory.stats.profile_views'.tr(),
            value: stats['profileViews'].toString(),
            icon: Icons.visibility_outlined,
            color: AppColors.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('factory.quick_actions'.tr(), style: AppTextStyles.h2),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 2.5,
          children: [
            _ActionCard(
              title: 'factory.inbox'.tr(),
              icon: Icons.inbox_outlined,
              onTap: () => context.pushNamed(AppRoutes.rfqInbox),
            ),
            _ActionCard(
              title: 'factory.active_orders'.tr(),
              icon: Icons.local_shipping_outlined,
              onTap: () => context.pushNamed(AppRoutes.activeOrders),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentRfqs(BuildContext context, FactoryDashboardLoaded state) {
    if (state.recentRfqs.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            'factory.no_recent_rfqs'.tr(),
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('factory.recent_rfqs'.tr(), style: AppTextStyles.h2),
            TextButton(
              onPressed: () => context.pushNamed(AppRoutes.rfqInbox),
              child: Text('common.view_all'.tr()),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.recentRfqs.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final rfq = state.recentRfqs[index];
            return Card(
              child: ListTile(
                title: Text(rfq.title, style: AppTextStyles.h3),
                subtitle: Text(
                  '${rfq.quantity} units • ${DateFormat.yMMMd().format(rfq.createdAt)}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  context.pushNamed(
                    AppRoutes.submitQuote,
                    pathParameters: {'id': rfq.id},
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: AppTextStyles.h1.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.h3,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
