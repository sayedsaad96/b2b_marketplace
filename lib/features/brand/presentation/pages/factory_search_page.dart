import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../injection_container.dart';
import '../bloc/factory_search_cubit.dart';
import '../bloc/factory_search_state.dart';
import '../widgets/factory_card.dart';
import '../widgets/empty_state_widget.dart';

class FactorySearchPage extends StatefulWidget {
  final String? initialQuery;
  final String? initialCategory;

  const FactorySearchPage({super.key, this.initialQuery, this.initialCategory});

  @override
  State<FactorySearchPage> createState() => _FactorySearchPageState();
}

class _FactorySearchPageState extends State<FactorySearchPage> {
  final _scrollController = ScrollController();
  late TextEditingController _searchController;
  late FactorySearchCubit _cubit;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _cubit = sl<FactorySearchCubit>();
    _searchController = TextEditingController(text: widget.initialQuery);
    _selectedCategory = widget.initialCategory;

    _cubit.searchFactories(
      query: widget.initialQuery,
      category: widget.initialCategory,
    );

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _cubit.fetchMoreFactories();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _cubit.close();
    super.dispose();
  }

  void _onSearchSubmit(String query) {
    _cubit.searchFactories(query: query, category: _selectedCategory);
  }

  void _onCategorySelect(String? category) {
    setState(() {
      _selectedCategory = category;
    });
    _cubit.searchFactories(
      query: _searchController.text,
      category: _selectedCategory,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: AppBar(
          title: Text('brand.search.title'.tr()),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60.h),
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'brand.search.search_hint'.tr(),
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
                onSubmitted: _onSearchSubmit,
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            _buildFilterBar(),
            Expanded(
              child: BlocBuilder<FactorySearchCubit, FactorySearchState>(
                builder: (context, state) {
                  if (state is FactorySearchLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is FactorySearchLoaded) {
                    if (state.searchResults.isEmpty) {
                      return EmptyStateWidget(
                        icon: Icons.search_off,
                        title: 'brand.search.no_results'.tr(),
                        message: 'brand.search.try_different'.tr(),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        _cubit.searchFactories(
                          query: _searchController.text,
                          category: _selectedCategory,
                        );
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount:
                            state.searchResults.length +
                            (state.hasReachedMax ? 0 : 1),
                        itemBuilder: (context, index) {
                          if (index == state.searchResults.length) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          final factory = state.searchResults[index];
                          return FactoryCard(
                            factoryEntity: factory,
                            onTap: () => context.pushNamed(
                              'factoryProfile',
                              pathParameters: {'id': factory.id},
                            ),
                          );
                        },
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBar() {
    final categories = [
      'T-shirts',
      'Denim',
      'Jackets',
      'Activewear',
      'Dresses',
    ];

    return Container(
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          FilterChip(
            label: Text('All'),
            selected: _selectedCategory == null,
            onSelected: (_) => _onCategorySelect(null),
          ),
          SizedBox(width: 8.w),
          ...categories.map(
            (category) => Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: FilterChip(
                label: Text(category),
                selected: _selectedCategory == category,
                onSelected: (_) => _onCategorySelect(category),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
