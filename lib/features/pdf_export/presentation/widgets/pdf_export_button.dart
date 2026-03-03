import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/pdf_export_cubit.dart';
import '../bloc/pdf_export_state.dart';

/// Reusable PDF export button with generate → preview/share/save flow.
class PdfExportButton extends StatelessWidget {
  final VoidCallback onGenerate;
  final String label;

  const PdfExportButton({
    super.key,
    required this.onGenerate,
    this.label = 'Export PDF',
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PdfExportCubit, PdfExportState>(
      listener: (context, state) {
        if (state is PdfExportReady) {
          _showPdfActions(context, state);
        } else if (state is PdfExportError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        final isLoading = state is PdfExportGenerating;
        return ElevatedButton.icon(
          onPressed: isLoading ? null : onGenerate,
          icon: isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.picture_as_pdf),
          label: Text(isLoading ? 'Generating...' : label),
        );
      },
    );
  }

  void _showPdfActions(BuildContext context, PdfExportReady state) {
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
                  context.read<PdfExportCubit>().previewPdf(state.pdfBytes);
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
                  final path = await context.read<PdfExportCubit>().savePdf(
                    state.pdfBytes,
                    state.fileName,
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Saved to: $path')));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
