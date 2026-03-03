import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/rfq_inbox_cubit.dart';
import '../bloc/rfq_inbox_state.dart';
import '../widgets/rfq_list_item.dart';

class RfqInboxPage extends StatefulWidget {
  const RfqInboxPage({super.key});

  @override
  State<RfqInboxPage> createState() => _RfqInboxPageState();
}

class _RfqInboxPageState extends State<RfqInboxPage> {
  @override
  void initState() {
    super.initState();
    context.read<RfqInboxCubit>().loadInbox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('factory.inbox'.tr())),
      body: BlocBuilder<RfqInboxCubit, RfqInboxState>(
        builder: (context, state) {
          if (state is RfqInboxLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RfqInboxError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: const TextStyle(color: AppColors.error),
                  ),
                  ElevatedButton(
                    onPressed: () => context.read<RfqInboxCubit>().loadInbox(),
                    child: Text('common.retry'.tr()),
                  ),
                ],
              ),
            );
          } else if (state is RfqInboxLoaded) {
            if (state.rfqs.isEmpty) {
              return Center(child: Text('factory.no_recent_rfqs'.tr()));
            }

            return RefreshIndicator(
              onRefresh: () => context.read<RfqInboxCubit>().refreshInbox(),
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.rfqs.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final rfq = state.rfqs[index];
                  // Check if the factory has already quoted this RFQ
                  final hasQuoted = state.myQuotes.any(
                    (quote) => quote.rfqId == rfq.id,
                  );

                  return RfqListItem(
                    rfq: rfq,
                    hasQuoted: hasQuoted,
                    onTap: () {
                      if (hasQuoted) {
                        // Go to chat
                        context.pushNamed(
                          AppRoutes.chat,
                          pathParameters: {'id': rfq.id},
                        );
                      } else {
                        // Go to submit quote
                        context.pushNamed(
                          AppRoutes.submitQuote,
                          pathParameters: {'id': rfq.id},
                        );
                      }
                    },
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
