import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../injection_container.dart';
import '../bloc/factory_search_cubit.dart';
import '../bloc/factory_search_state.dart';
import '../widgets/photo_gallery.dart';

class FactoryProfilePage extends StatefulWidget {
  final String factoryId;

  const FactoryProfilePage({super.key, required this.factoryId});

  @override
  State<FactoryProfilePage> createState() => _FactoryProfilePageState();
}

class _FactoryProfilePageState extends State<FactoryProfilePage> {
  late FactorySearchCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<FactorySearchCubit>()..getFactoryDetails(widget.factoryId);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: AppBar(title: Text('brand.profile.title'.tr())),
        body: BlocBuilder<FactorySearchCubit, FactorySearchState>(
          builder: (context, state) {
            if (state is FactoryProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FactoryProfileError) {
              return Center(child: Text(state.message));
            } else if (state is FactoryProfileLoaded) {
              final factory = state.factoryEntity;

              return SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            factory.name,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (factory.verified)
                          const Icon(
                            Icons.verified,
                            color: Colors.blue,
                            size: 28,
                          ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          factory.location,
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Icon(Icons.star, size: 20, color: Colors.amber),
                        SizedBox(width: 4.w),
                        Text(
                          factory.rating.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),

                    Text(
                      'brand.profile.specialization'.tr(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: factory.specialization
                          .map((spec) => Chip(label: Text(spec)))
                          .toList(),
                    ),
                    SizedBox(height: 24.h),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${'brand.profile.moq'.tr()}: ${factory.moq}',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '${'brand.profile.lead_time'.tr()}: ${factory.avgLeadTime} days',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),

                    if (factory.photos.isNotEmpty) ...[
                      Text(
                        'brand.profile.photos'.tr(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      PhotoGallery(photoUrls: factory.photos),
                      SizedBox(height: 32.h),
                    ],

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          context.pushNamed('rfqForm', extra: factory.id);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                        ),
                        child: Text('brand.profile.request_rfq'.tr()),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
