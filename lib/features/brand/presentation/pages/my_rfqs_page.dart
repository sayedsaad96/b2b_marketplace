import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../injection_container.dart';
import '../bloc/rfq_cubit.dart';
import '../bloc/rfq_state.dart';
import '../widgets/rfq_card.dart';
import '../widgets/empty_state_widget.dart';
import '../../../pdf_export/presentation/bloc/pdf_export_cubit.dart';
import '../../../pdf_export/presentation/bloc/pdf_export_state.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _cubit),
        BlocProvider(create: (_) => sl<PdfExportCubit>()),
      ],
      child: BlocListener<PdfExportCubit, PdfExportState>(
        listener: (context, state) {
          if (state is PdfExportReady) {
            showModalBottomSheet(
              context: context,
              builder: (_) => SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'PDF Ready: ${state.fileName}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        leading: const Icon(Icons.preview),
                        title: const Text('Preview'),
                        onTap: () {
                          Navigator.pop(context);
                          context.read<PdfExportCubit>().previewPdf(
                            state.pdfBytes,
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.share),
                        title: const Text('Share'),
                        onTap: () {
                          Navigator.pop(context);
                          context.read<PdfExportCubit>().sharePdf(
                            state.pdfBytes,
                            state.fileName,
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.save_alt),
                        title: const Text('Save to Device'),
                        onTap: () async {
                          Navigator.pop(context);
                          final path = await context
                              .read<PdfExportCubit>()
                              .savePdf(state.pdfBytes, state.fileName);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Saved to: $path')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is PdfExportError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
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
      ),
    );
  }
}
