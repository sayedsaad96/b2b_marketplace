import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../../../../core/services/pdf_service.dart';
import 'pdf_export_state.dart';

/// Cubit managing PDF generation, preview, save, and share.
class PdfExportCubit extends Cubit<PdfExportState> {
  final PdfService _pdfService;

  PdfExportCubit({required PdfService pdfService})
    : _pdfService = pdfService,
      super(PdfExportInitial());

  /// Generate an RFQ PDF.
  Future<void> generateRfqPdf({
    required String rfqId,
    required String rfqTitle,
    required String rfqDescription,
    required int quantity,
    required String brandName,
    required String brandEmail,
    required String? factoryName,
    required DateTime createdAt,
  }) async {
    emit(PdfExportGenerating());
    try {
      final bytes = await _pdfService.generateRfqPdf(
        rfqTitle: rfqTitle,
        rfqDescription: rfqDescription,
        quantity: quantity,
        brandName: brandName,
        brandEmail: brandEmail,
        factoryName: factoryName,
        createdAt: createdAt,
        rfqId: rfqId,
      );
      final fileName = 'RFQ_${rfqId.substring(0, 8).toUpperCase()}.pdf';
      emit(PdfExportReady(pdfBytes: bytes, fileName: fileName));
    } catch (e) {
      emit(PdfExportError('Failed to generate PDF: $e'));
    }
  }

  /// Generate a Quote PDF.
  Future<void> generateQuotePdf({
    required String quoteId,
    required String rfqId,
    required String rfqTitle,
    required int quantity,
    required double price,
    required int leadTime,
    required String? notes,
    required String factoryName,
    required String brandName,
    required DateTime createdAt,
  }) async {
    emit(PdfExportGenerating());
    try {
      final bytes = await _pdfService.generateQuotePdf(
        quoteId: quoteId,
        rfqTitle: rfqTitle,
        quantity: quantity,
        price: price,
        leadTime: leadTime,
        notes: notes,
        factoryName: factoryName,
        brandName: brandName,
        createdAt: createdAt,
        rfqId: rfqId,
      );
      final fileName = 'Quote_${quoteId.substring(0, 8).toUpperCase()}.pdf';
      emit(PdfExportReady(pdfBytes: bytes, fileName: fileName));
    } catch (e) {
      emit(PdfExportError('Failed to generate PDF: $e'));
    }
  }

  /// Preview the generated PDF.
  Future<void> previewPdf(Uint8List bytes) async {
    await Printing.layoutPdf(onLayout: (_) => bytes);
  }

  /// Share the generated PDF.
  Future<void> sharePdf(Uint8List bytes, String fileName) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes);
    await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
  }

  /// Save the PDF to device downloads.
  Future<String> savePdf(Uint8List bytes, String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes);
    return file.path;
  }
}
