import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../injection_container.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../bloc/factory_search_cubit.dart';
import '../bloc/factory_search_state.dart';
import '../widgets/factory_card.dart';
import '../../../notifications/presentation/bloc/notification_cubit.dart';
import '../../../notifications/presentation/widgets/notification_badge.dart';

class BrandHomePage extends StatefulWidget {
  const BrandHomePage({super.key});

  @override
  State<BrandHomePage> createState() => _BrandHomePageState();
}

class _BrandHomePageState extends State<BrandHomePage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<FactorySearchCubit>()..loadHomeData()),
        BlocProvider(
          create: (_) => sl<NotificationCubit>()..loadNotifications(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('brand.home.title'.tr()),
          actions: [
            const NotificationBadge(),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthCubit>().signOut();
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            // we need a context with cubit
            // but we are outside the builder, so let's use a Builder or a key,
            // actually we can put RefreshIndicator inside the BlocBuilder or use a GlobalKey.
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(context),
                _buildQuickActions(context),
                _buildTopFactoriesSection(),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.pushNamed('myRfqs'),
          icon: const Icon(Icons.history),
          label: Text('brand.home.my_rfqs'.tr()),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'brand.home.search_hint'.tr(),
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        ),
        onSubmitted: (query) {
          if (query.isNotEmpty) {
            context.pushNamed('factorySearch', extra: {'query': query});
          }
        },
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final categories = [
      'T-shirts',
      'Denim',
      'Jackets',
      'Activewear',
      'Dresses',
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'brand.home.categories'.tr(),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 40.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: ActionChip(
                    label: Text(category),
                    onPressed: () {
                      context.pushNamed(
                        'factorySearch',
                        extra: {'category': category},
                      );
                    },
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildTopFactoriesSection() {
    return BlocBuilder<FactorySearchCubit, FactorySearchState>(
      builder: (context, state) {
        if (state is FactorySearchLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FactorySearchLoaded) {
          if (state.topFactories.isEmpty) {
            return const SizedBox.shrink();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'brand.home.top_factories'.tr(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.pushNamed('factorySearch'),
                      child: Text('brand.home.view_all'.tr()),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.topFactories.length,
                itemBuilder: (context, index) {
                  final factory = state.topFactories[index];
                  return FactoryCard(
                    factoryEntity: factory,
                    onTap: () => context.pushNamed(
                      'factoryProfile',
                      pathParameters: {'id': factory.id},
                    ),
                  );
                },
              ),
            ],
          );
        } else if (state is FactorySearchLoaded && state.error != null) {
          return Center(child: Text(state.error!));
        }
        return const SizedBox.shrink();
      },
    );
  }
}
