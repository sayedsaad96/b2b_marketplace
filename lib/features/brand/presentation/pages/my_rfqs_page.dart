import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../injection_container.dart';
import '../bloc/rfq_cubit.dart';
import '../bloc/rfq_state.dart';
import '../widgets/rfq_card.dart';
import '../widgets/empty_state_widget.dart';

class MyRfqsPage extends StatefulWidget {
  const MyRfqsPage({super.key});

  @override
  State<MyRfqsPage> createState() => _MyRfqsPageState();
}

class _MyRfqsPageState extends State<MyRfqsPage> {
  late RfqCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<RfqCubit>()..loadMyRfqs();
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
        appBar: AppBar(title: Text('brand.my_rfqs.title'.tr())),
        body: BlocBuilder<RfqCubit, RfqState>(
          builder: (context, state) {
            if (state is RfqListLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RfqListError) {
              return EmptyStateWidget(
                icon: Icons.error_outline,
                title: 'Error',
                message: state.message,
                onRetry: () => _cubit.loadMyRfqs(),
              );
            } else if (state is RfqListLoaded) {
              if (state.rfqs.isEmpty) {
                return EmptyStateWidget(
                  icon: Icons.assignment_outlined,
                  title: 'brand.my_rfqs.no_rfqs'.tr(),
                  message: '',
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  await _cubit.loadMyRfqs();
                },
                child: ListView.builder(
                  itemCount: state.rfqs.length,
                  itemBuilder: (context, index) {
                    return RfqCard(rfq: state.rfqs[index]);
                  },
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
